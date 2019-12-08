//
//  RepeatViewController.swift
//  Memorize
//
//  Created by Вика on 27/11/2019.
//  Copyright © 2019 Vika Olegova. All rights reserved.
//

import UIKit

protocol RepeatViewInput: class {
    func show(mistakeCount: Int)
    func show(translationsCount: Int, from allCount: Int)
    func show(fromToLanguage: String)
    func show(originalWord: String)
    func show(image: UIImage?)
    func show(titleButton: String)
    func clearTextField()
    func showKeyboard()
    func hideMistakes()
    func show(title: String)
    func showRightBarButtonItem(show: Bool)
}

protocol RepeatViewOutput: class {
    func viewDidLoad()
    func viewWillAppear()
    func textFieldChanged(textIsEmpty: Bool)
    func didEnterTranslation(_ enteredTranslation: String)
    func playAudioTapped()
    func didOpenKeyboard()
    func didTapRightBarButtonItem()
}

class RepeatViewController: UIViewController {
    let translationsAndMistakesCount = TranslationsAndMistakesCount()
    let audioQuestion = AudioLabel()
    let translation = TitleTextFieldView()
    let imageView = UIImageView()
    let greenButton = BigGreenButton()
    
    let presenter: RepeatViewOutput
    
    private var imageHeightConstraint: NSLayoutConstraint?
    
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
        
        presenter.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.viewWillAppear()
    }
    
    func passAnswerToPresenter() {
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
        
        if let existing = imageHeightConstraint {
            imageView.removeConstraint(existing)
        }
        if let image = image, image.size.height < image.size.width {
            imageHeightConstraint = imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor,
                                                                      multiplier: image.size.height / image.size.width)
        } else {
            imageView.bottomAnchor.constraint(lessThanOrEqualTo: greenButton.topAnchor, constant: -10).isActive = true
        }
        
        imageHeightConstraint?.isActive = true
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
