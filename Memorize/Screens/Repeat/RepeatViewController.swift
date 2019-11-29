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
    func show(image: UIImage)
    func show(titleButton: String)
    func show(popViewController: UIViewController)
    func clearTextField()
}

protocol RepeatViewOutput: class {
    func viewDidLoad()
    func textFieldChanged(textIsEmpty: Bool)
    func greenButtonTapped(enteredTranslation: String)
    func playAudioTapped()
}

class RepeatViewController: UIViewController {
    let stack = UIStackView()
    let translationsAndMistakesCount = TranslationsAndMistakesCount()
    let audioQuestion = AudioLabel()
    let translation = TitleTextFieldView()
    let imageView = UIImageView()
    let greenButton = BigGreenButton()
    
    let presenter: RepeatViewOutput
    
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
        navigationItem.title = "Повторение"
        
        translation.label.text = "Перевод"
        translation.label.textColor = .gray
        translation.textField.placeholder = "Введите перевод"
        translation.textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        imageView.contentMode = .scaleAspectFit
        greenButton.setTitle("Показать перевод", for: .normal)
        
        greenButton.addTarget(self, action: #selector(greenButtonTapped), for: .touchUpInside)
        audioQuestion.audioButton.addTarget(self, action: #selector(audioButtonTapped), for: .touchUpInside)
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stack)
        view.addSubview(imageView)
        view.addSubview(greenButton)
        
        stack.axis = .vertical
        stack.spacing = 15
        
        stack.addArrangedSubview(translationsAndMistakesCount)
        stack.addArrangedSubview(audioQuestion)
        stack.addArrangedSubview(translation)
        
        stack.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 18).isActive = true
        stack.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -18).isActive = true
        stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 18).isActive = true
        
        greenButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 18).isActive = true
        greenButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -18).isActive = true
        greenButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -18).isActive = true
        
        imageView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 18).isActive = true
        imageView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -18).isActive = true
        imageView.topAnchor.constraint(equalTo: stack.bottomAnchor, constant: 18).isActive = true
        imageView.bottomAnchor.constraint(equalTo: greenButton.topAnchor, constant: -50).isActive = true
        
        presenter.viewDidLoad()
    }
    
    @objc func greenButtonTapped() {
        presenter.greenButtonTapped(enteredTranslation: translation.textField.text ?? "")
    }
    
    @objc func audioButtonTapped() {
        presenter.playAudioTapped()
    }
    
    private var oldTextIsEmpty = true
    
    @objc func textFieldDidChange() {
        guard let text = translation.textField.text, !text.isEmpty else {
            oldTextIsEmpty = true
            presenter.textFieldChanged(textIsEmpty: oldTextIsEmpty)
            return
        }
        guard oldTextIsEmpty else { return }
        oldTextIsEmpty = false
        presenter.textFieldChanged(textIsEmpty: oldTextIsEmpty)
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
    
    func show(image: UIImage) {
        imageView.image = image
    }
    
    func show(titleButton: String) {
        greenButton.setTitle(titleButton, for: .normal)
    }
    
    func show(popViewController: UIViewController) {
        popViewController.willMove(toParent: self)
        self.addChild(popViewController)
        popViewController.view.frame = self.view.frame
        self.view.addSubview(popViewController.view)
        popViewController.didMove(toParent: self)
    }
    
    func clearTextField() {
        translation.textField.text = ""
    }
}
