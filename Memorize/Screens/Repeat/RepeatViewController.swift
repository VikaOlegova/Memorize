//
//  RepeatViewController.swift
//  Memorize
//
//  Created by Вика on 27/11/2019.
//  Copyright © 2019 Vika Olegova. All rights reserved.
//

import UIKit

/// Протокол входных данных для экрана повторения\заучивания ошибок
protocol RepeatViewInput: class {
    /// Показывает кол-во допущенных ошибок
    ///
    /// - Parameter mistakeCount: кол-во ошибок
    func show(mistakeCount: Int)
    
    /// Показывает номер текущего отвечаемого слова и кол-во всех слов для повторения\исправления ошибок
    ///
    /// - Parameters:
    ///   - translationsCount: номер текущего отвечаемого слова
    ///   - allCount: кол-во всех слов для повторения\исправления ошибок
    func show(translationsCount: Int, from allCount: Int)
    
    /// Показывает с какого языка на какой нужно перевести
    ///
    /// - Parameter fromToLanguage: с какого языка на какой нужно перевести
    func show(fromToLanguage: String)
    
    /// Показывает слово для перевода
    ///
    /// - Parameter originalWord: слово для перевода
    func show(originalWord: String)
    
    /// Показывает картинку-ассоциацию для спрашиваемого слова
    ///
    /// - Parameter image: картинка
    func show(image: UIImage?)
    
    /// Показывает текст зеленой кнопки
    ///
    /// - Parameter titleButton: текст кнопки
    func show(titleButton: String)
    
    /// Очищает поле ввода
    func clearTextField()
    
    /// Показывает клавиатуру
    func showKeyboard()
    
    /// Скрывает информацию об ошибках
    func hideMistakes()
    
    /// Показывает заголовок экрана
    ///
    /// - Parameter title: текст заголовка
    func show(title: String)
    
    /// Показывает кнопку справа в навигейшн баре
    ///
    /// - Parameter show: показать или нет
    func showRightBarButtonItem(show: Bool)
}

/// Протокол выходных данных с экрана повторения\заучивания ошибок
protocol RepeatViewOutput: class {
    func viewDidLoad()
    func viewWillAppear()
    
    /// Событие на изменение текста в поле ввода
    ///
    /// - Parameter textIsEmpty: пустой текст или нет
    func textFieldChanged(textIsEmpty: Bool)
    
    /// Событие на нажатие зеленой кнопки
    ///
    /// - Parameter enteredTranslation: введенный перевод
    func didEnterTranslation(_ enteredTranslation: String)
    
    /// Событие на нажатие аудиокнопки
    func playAudioTapped()
    
    /// Событие на открытие клавиатуры
    func didOpenKeyboard()
    
    /// Событие на нажатие правой кнопки в навигейшн баре
    func didTapRightBarButtonItem()
}

/// Экран повторения\заучивания ошибок
class RepeatViewController: UIViewController {
    private let translationsAndMistakesCount = TranslationsAndMistakesCount()
    private let audioQuestion = AudioLabel()
    private let translation = TitleTextFieldView()
    private let imageView = UIImageView()
    private let greenButton = BigGreenButton()
    
    private let presenter: RepeatViewOutput
    
    private var imageHeightConstraint: NSLayoutConstraint!
    
    init(presenter: RepeatViewOutput) {
        self.presenter = presenter
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        translation.label.text = "Перевод"
        translation.label.textColor = .gray
        translation.textField.placeholder = "Введите перевод"
        translation.textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        translation.textField.returnKeyType = .done
        translation.textField.delegate = self
        
        imageView.contentMode = .scaleAspectFit
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapImage)))
        imageView.isUserInteractionEnabled = true
        
        greenButton.setTitle("Показать перевод", for: .normal)
        greenButton.addTarget(self, action: #selector(greenButtonTapped), for: .touchUpInside)
        
        audioQuestion.audioButton.addTarget(self, action: #selector(audioButtonTapped), for: .touchUpInside)
        
        let stack = UIStackView(arrangedSubviews: [translationsAndMistakesCount,
                                                   audioQuestion,
                                                   translation])
        stack.axis = .vertical
        stack.spacing = 15

        stack.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stack)
        view.addSubview(imageView)
        view.addSubview(greenButton)
        
        stack.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 18).isActive = true
        stack.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -18).isActive = true
        stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 18).isActive = true
        
        greenButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 18).isActive = true
        greenButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -18).isActive = true
        greenButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -18).isActive = true
        
        imageView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 18).isActive = true
        imageView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -18).isActive = true
        imageView.topAnchor.constraint(equalTo: stack.bottomAnchor, constant: 18).isActive = true
        
        imageHeightConstraint = imageView.heightAnchor.constraint(equalToConstant: 100)
        imageHeightConstraint.isActive = true
        
        presenter.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.viewWillAppear()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateImageViewHeight()
    }
    
    private func updateImageViewHeight() {
        guard let image = imageView.image else { return }
        
        let aspect = image.size.height / image.size.width
        let targetHeight = aspect * imageView.frame.width
        let maxHeight = greenButton.frame.minY - imageView.frame.minY - 10
        let height = min(targetHeight, maxHeight)
        imageHeightConstraint.constant = height
        imageView.layoutIfNeeded()
    }
    
    private func passAnswerToPresenter() {
        presenter.didEnterTranslation(translation.textField.text ?? "")
    }
    
    @objc func didTapImage() {
        view.endEditing(true)
    }
    
    @objc func greenButtonTapped() {
        passAnswerToPresenter()
    }
    
    @objc func audioButtonTapped() {
        presenter.playAudioTapped()
    }
    
    private var oldTextIsEmpty = true
    
    @objc func textFieldDidChange() {
        let isEmpty = translation.textField.text?.isEmpty ?? true
        
        guard isEmpty != oldTextIsEmpty else { return }
        oldTextIsEmpty = isEmpty
        presenter.textFieldChanged(textIsEmpty: isEmpty)
    }
    
    @objc func rightBarButtonItemTapped() {
        presenter.didTapRightBarButtonItem()
    }
}

extension RepeatViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if !(textField.text?.isEmpty ?? true) {
            passAnswerToPresenter()
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        presenter.didOpenKeyboard()
    }
}

extension RepeatViewController: RepeatViewInput {
    func show(fromToLanguage: String) {
        translationsAndMistakesCount.fromToLanguageLabel.text = fromToLanguage
    }
    
    func show(mistakeCount: Int) {
        translationsAndMistakesCount.mistakeCounter.text = String(mistakeCount)
    }
    
    func show(translationsCount: Int, from allCount: Int) {
        translationsAndMistakesCount.translationCounter.text = "\(translationsCount)/\(allCount)"
    }
    
    func show(originalWord: String) {
        audioQuestion.wordLabel.text = originalWord
    }
    
    func show(image: UIImage?) {
        imageView.image = image
    }
    
    func show(titleButton: String) {
        greenButton.setTitle(titleButton, for: .normal)
    }
    
    func clearTextField() {
        translation.textField.text = nil
        textFieldDidChange()
    }
    
    func showKeyboard() {
        translation.textField.becomeFirstResponder()
    }
    
    func hideMistakes() {
        translationsAndMistakesCount.hideMistakes()
    }
    
    func show(title: String) {
        navigationItem.title = title
    }
    
    func showRightBarButtonItem(show: Bool) {
        if show {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop,
                                                                target: self,
                                                                action: #selector(rightBarButtonItemTapped))
        }
    }
}
