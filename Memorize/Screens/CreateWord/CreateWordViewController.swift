//
//  CreateWordViewController.swift
//  Memorize
//
//  Created by Вика on 26/11/2019.
//  Copyright © 2019 Vika Olegova. All rights reserved.
//

import UIKit

protocol CreateWordViewInput: class {
    func showWords(original: String, translation: String)
    func show(image: UIImage)
    func show(languageInfo: String)
    func show(reverseTranslationEnabled: Bool)
    func show(title: String)
}

protocol CreateWordViewOutput: class {
    func saveTapped(originalWord: String?,
                    translationWord: String?,
                    reverseTranslationEnabled: Bool )
    func viewDidLoad()
}

class CreateWordViewController: UIViewController {
    let originalView = TitleTextFieldView()
    let fromToButton = UIButton()
    let createReverseTranslationLabel = UILabel()
    let checkBox = CheckBox()
    let translationView = TitleTextFieldView()
    let imageView = UIImageView()
    let saveButton = BigGreenButton()
    
    let presenter: CreateWordViewOutput
    
    init(presenter: CreateWordViewOutput) {
        self.presenter = presenter
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        fromToButton.translatesAutoresizingMaskIntoConstraints = false
        createReverseTranslationLabel.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(originalView)
        view.addSubview(fromToButton)
        view.addSubview(createReverseTranslationLabel)
        view.addSubview(checkBox)
        view.addSubview(translationView)
        view.addSubview(imageView)
        view.addSubview(saveButton)
        
        originalView.label.text = "Новое слово или фраза"
        originalView.textField.placeholder = "Введите слово"
        fromToButton.setTitleColor(.black, for: .normal)
        fromToButton.addTarget(self, action:#selector(fromToButtonTapped), for: .touchUpInside)
        createReverseTranslationLabel.text = "Создать обратный перевод"
        translationView.label.text = "Перевод"
        translationView.textField.placeholder = "Введите перевод"
        imageView.backgroundColor = .gray
        saveButton.setTitle("Сохранить", for: .normal)
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        
        let safeArea = view.safeAreaLayoutGuide
        
        originalView.leftAnchor.constraint(equalTo: safeArea.leftAnchor, constant: 18).isActive = true
        originalView.rightAnchor.constraint(equalTo: safeArea.rightAnchor, constant: -18).isActive = true
        originalView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 18).isActive = true
        
        fromToButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        fromToButton.topAnchor.constraint(equalTo: originalView.bottomAnchor, constant: 18).isActive = true
        fromToButton.heightAnchor.constraint(equalToConstant: 21).isActive = true
        
        createReverseTranslationLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        createReverseTranslationLabel.topAnchor.constraint(equalTo: fromToButton.bottomAnchor, constant: 8).isActive = true
        createReverseTranslationLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        checkBox.rightAnchor.constraint(equalTo: createReverseTranslationLabel.leftAnchor, constant: -10).isActive = true
        checkBox.centerYAnchor.constraint(equalTo: createReverseTranslationLabel.centerYAnchor).isActive = true
        checkBox.heightAnchor.constraint(equalToConstant: 24).isActive = true
        checkBox.widthAnchor.constraint(equalToConstant: 24).isActive = true
        
        translationView.leftAnchor.constraint(equalTo: safeArea.leftAnchor, constant: 18).isActive = true
        translationView.rightAnchor.constraint(equalTo: safeArea.rightAnchor, constant: -18).isActive = true
        translationView.topAnchor.constraint(equalTo: checkBox.bottomAnchor, constant: 18).isActive = true
        
        saveButton.leftAnchor.constraint(equalTo: safeArea.leftAnchor, constant: 18).isActive = true
        saveButton.rightAnchor.constraint(equalTo: safeArea.rightAnchor, constant: -18).isActive = true
        saveButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -18).isActive = true
        
        imageView.leftAnchor.constraint(equalTo: safeArea.leftAnchor, constant: 18).isActive = true
        imageView.rightAnchor.constraint(equalTo: safeArea.rightAnchor, constant: -18).isActive = true
        imageView.topAnchor.constraint(equalTo: translationView.bottomAnchor, constant: 18).isActive = true
        imageView.bottomAnchor.constraint(equalTo: saveButton.topAnchor, constant: -32).isActive = true
        
        presenter.viewDidLoad()
    }
    
    @objc func fromToButtonTapped() {
        
    }
    
    @objc func saveButtonTapped() {
        presenter.saveTapped(originalWord: originalView.textField.text,
                             translationWord: translationView.textField.text,
                             reverseTranslationEnabled: checkBox.isSelected)
    }
}

extension CreateWordViewController: CreateWordViewInput {
    func showWords(original: String, translation: String) {
        originalView.textField.text = original
        translationView.textField.text = translation
    }
    
    func show(image: UIImage) {
        imageView.image = image
    }
    
    func show(languageInfo: String) {
        fromToButton.setTitle(languageInfo, for: .normal)
    }
    
    func show(reverseTranslationEnabled: Bool) {
        checkBox.isSelected = reverseTranslationEnabled
    }
    
    func show(title: String) {
        navigationItem.title = title
    }
    
    
}
