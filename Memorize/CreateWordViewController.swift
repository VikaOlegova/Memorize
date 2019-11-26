//
//  CreateWordViewController.swift
//  Memorize
//
//  Created by Вика on 26/11/2019.
//  Copyright © 2019 Vika Olegova. All rights reserved.
//

import UIKit

class CreateWordViewController: UIViewController {
    let newWord = TitleTextFieldView()
    let fromToButton = UIButton()
    let createTranslationLabel = UILabel()
    let checkBox = CheckBox()
    let translation = TitleTextFieldView()
    let spinner = UIActivityIndicatorView(style: .gray)
    let imageView = UIImageView()
    let saveButton = BigGreenButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        navigationItem.title = "Создать"
        
        fromToButton.translatesAutoresizingMaskIntoConstraints = false
        createTranslationLabel.translatesAutoresizingMaskIntoConstraints = false
        spinner.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(newWord)
        view.addSubview(fromToButton)
        view.addSubview(createTranslationLabel)
        view.addSubview(checkBox)
        view.addSubview(translation)
        view.addSubview(spinner)
        view.addSubview(imageView)
        view.addSubview(saveButton)
        
        newWord.label.text = "Новое слово или фраза"
        newWord.textField.placeholder = "Введите слово"
        fromToButton.setTitle("RU -> EN", for: .normal)
        fromToButton.setTitleColor(.black, for: .normal)
        fromToButton.addTarget(self, action:#selector(fromToButtonClicked), for: UIControl.Event.touchUpInside)
        createTranslationLabel.text = "Создать обратный перевод"
        translation.label.text = "Перевод"
        translation.textField.placeholder = "Введите перевод"
        spinner.startAnimating()
        imageView.backgroundColor = .gray
        saveButton.setTitle("Сохранить", for: .normal)
        
        let safeArea = view.safeAreaLayoutGuide
        
        newWord.leftAnchor.constraint(equalTo: safeArea.leftAnchor, constant: 18).isActive = true
        newWord.rightAnchor.constraint(equalTo: safeArea.rightAnchor, constant: -18).isActive = true
        newWord.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 18).isActive = true
        
        fromToButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        fromToButton.topAnchor.constraint(equalTo: newWord.bottomAnchor, constant: 18).isActive = true
        fromToButton.heightAnchor.constraint(equalToConstant: 21).isActive = true
        
        createTranslationLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        createTranslationLabel.topAnchor.constraint(equalTo: fromToButton.bottomAnchor, constant: 8).isActive = true
        createTranslationLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        checkBox.rightAnchor.constraint(equalTo: createTranslationLabel.leftAnchor, constant: -10).isActive = true
        checkBox.centerYAnchor.constraint(equalTo: createTranslationLabel.centerYAnchor).isActive = true
        checkBox.heightAnchor.constraint(equalToConstant: 24).isActive = true
        checkBox.widthAnchor.constraint(equalToConstant: 24).isActive = true
        
        translation.leftAnchor.constraint(equalTo: safeArea.leftAnchor, constant: 18).isActive = true
        translation.rightAnchor.constraint(equalTo: safeArea.rightAnchor, constant: -18).isActive = true
        translation.topAnchor.constraint(equalTo: checkBox.bottomAnchor, constant: 18).isActive = true
        
        spinner.leftAnchor.constraint(equalTo: translation.rightAnchor, constant: 7).isActive = true
        spinner.topAnchor.constraint(equalTo: checkBox.bottomAnchor, constant: 18).isActive = true
        spinner.heightAnchor.constraint(equalToConstant: 22).isActive = true
        
        saveButton.leftAnchor.constraint(equalTo: safeArea.leftAnchor, constant: 18).isActive = true
        saveButton.rightAnchor.constraint(equalTo: safeArea.rightAnchor, constant: -18).isActive = true
        saveButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -18).isActive = true
        
        imageView.leftAnchor.constraint(equalTo: safeArea.leftAnchor, constant: 18).isActive = true
        imageView.rightAnchor.constraint(equalTo: safeArea.rightAnchor, constant: -18).isActive = true
        imageView.topAnchor.constraint(equalTo: translation.bottomAnchor, constant: 18).isActive = true
        imageView.bottomAnchor.constraint(equalTo: saveButton.topAnchor, constant: -32).isActive = true
    }
    
    @objc func fromToButtonClicked() {
        if fromToButton.title(for: .normal) == "RU -> EN" {
            fromToButton.setTitle("EN -> RU", for: .normal)
        } else {
            fromToButton.setTitle("RU -> EN", for: .normal)
        }
    }
}
