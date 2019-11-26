//
//  CreateWordViewController.swift
//  Memorize
//
//  Created by Вика on 26/11/2019.
//  Copyright © 2019 Vika Olegova. All rights reserved.
//

import UIKit

class CreateWordViewController: UIViewController {
    let newWordLabel = UILabel()
    let newWordTextField = UITextField()
    let newWordSplitter = UIView()
    let fromToButton = UIButton()
    let createTranslationLabel = UILabel()
    let checkBox = CheckBox()
    let translationLabel = UILabel()
    let spinner = UIActivityIndicatorView(style: .gray)
    let translationTextField = UITextField()
    let translationSplitter = UIView()
    let imageView = UIImageView()
    let saveButton = BigGreenButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        navigationItem.title = "Создать"
        
        newWordLabel.translatesAutoresizingMaskIntoConstraints = false
        newWordTextField.translatesAutoresizingMaskIntoConstraints = false
        newWordSplitter.translatesAutoresizingMaskIntoConstraints = false
        fromToButton.translatesAutoresizingMaskIntoConstraints = false
        createTranslationLabel.translatesAutoresizingMaskIntoConstraints = false
        translationLabel.translatesAutoresizingMaskIntoConstraints = false
        spinner.translatesAutoresizingMaskIntoConstraints = false
        translationTextField.translatesAutoresizingMaskIntoConstraints = false
        translationSplitter.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(newWordLabel)
        view.addSubview(newWordTextField)
        view.addSubview(newWordSplitter)
        view.addSubview(fromToButton)
        view.addSubview(createTranslationLabel)
        view.addSubview(checkBox)
        view.addSubview(translationLabel)
        view.addSubview(spinner)
        view.addSubview(translationTextField)
        view.addSubview(translationSplitter)
        view.addSubview(imageView)
        view.addSubview(saveButton)
        
        newWordLabel.text = "Новое слово или фраза"
        newWordTextField.placeholder = "Введите слово"
        newWordSplitter.backgroundColor = UIColor(white: 210/255.0, alpha: 1)
        fromToButton.setTitle("RU -> EN", for: .normal)
        fromToButton.setTitleColor(.black, for: .normal)
        fromToButton.addTarget(self, action:#selector(fromToButtonClicked), for: UIControl.Event.touchUpInside)
        createTranslationLabel.text = "Создать обратный перевод"
        translationLabel.text = "Перевод"
        translationTextField.placeholder = "Введите перевод"
        translationSplitter.backgroundColor = newWordSplitter.backgroundColor
        spinner.startAnimating()
        imageView.backgroundColor = .gray
        saveButton.setTitle("Сохранить", for: .normal)
        
        let safeArea = view.safeAreaLayoutGuide
        
        newWordLabel.leftAnchor.constraint(equalTo: safeArea.leftAnchor, constant: 18).isActive = true
        newWordLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 18).isActive = true
        newWordLabel.heightAnchor.constraint(equalToConstant: 22).isActive = true
        
        newWordTextField.leftAnchor.constraint(equalTo: safeArea.leftAnchor, constant: 18).isActive = true
        newWordTextField.rightAnchor.constraint(equalTo: safeArea.rightAnchor, constant: -18).isActive = true
        newWordTextField.topAnchor.constraint(equalTo: newWordLabel.bottomAnchor, constant: 5).isActive = true
        newWordTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        newWordSplitter.leftAnchor.constraint(equalTo: safeArea.leftAnchor, constant: 18).isActive = true
        newWordSplitter.rightAnchor.constraint(equalTo: safeArea.rightAnchor, constant: -18).isActive = true
        newWordSplitter.topAnchor.constraint(equalTo: newWordTextField.bottomAnchor).isActive = true
        newWordSplitter.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        fromToButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        fromToButton.topAnchor.constraint(equalTo: newWordSplitter.bottomAnchor, constant: 18).isActive = true
        fromToButton.heightAnchor.constraint(equalToConstant: 21).isActive = true
        
        createTranslationLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        createTranslationLabel.topAnchor.constraint(equalTo: fromToButton.bottomAnchor, constant: 8).isActive = true
        createTranslationLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        checkBox.rightAnchor.constraint(equalTo: createTranslationLabel.leftAnchor, constant: -10).isActive = true
        checkBox.centerYAnchor.constraint(equalTo: createTranslationLabel.centerYAnchor).isActive = true
        checkBox.heightAnchor.constraint(equalToConstant: 24).isActive = true
        checkBox.widthAnchor.constraint(equalToConstant: 24).isActive = true
        
        translationLabel.leftAnchor.constraint(equalTo: safeArea.leftAnchor, constant: 18).isActive = true
        translationLabel.topAnchor.constraint(equalTo: checkBox.bottomAnchor, constant: 18).isActive = true
        translationLabel.heightAnchor.constraint(equalToConstant: 22).isActive = true
        
        spinner.leftAnchor.constraint(equalTo: translationLabel.rightAnchor, constant: 7).isActive = true
        spinner.topAnchor.constraint(equalTo: checkBox.bottomAnchor, constant: 18).isActive = true
        spinner.heightAnchor.constraint(equalToConstant: 22).isActive = true
        
        translationTextField.leftAnchor.constraint(equalTo: safeArea.leftAnchor, constant: 18).isActive = true
        translationTextField.rightAnchor.constraint(equalTo: safeArea.rightAnchor, constant: -18).isActive = true
        translationTextField.topAnchor.constraint(equalTo: translationLabel.bottomAnchor, constant: 5).isActive = true
        translationTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        translationSplitter.leftAnchor.constraint(equalTo: safeArea.leftAnchor, constant: 18).isActive = true
        translationSplitter.rightAnchor.constraint(equalTo: safeArea.rightAnchor, constant: -18).isActive = true
        translationSplitter.topAnchor.constraint(equalTo: translationTextField.bottomAnchor).isActive = true
        translationSplitter.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        saveButton.leftAnchor.constraint(equalTo: safeArea.leftAnchor, constant: 18).isActive = true
        saveButton.rightAnchor.constraint(equalTo: safeArea.rightAnchor, constant: -18).isActive = true
        saveButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -18).isActive = true
        
        imageView.leftAnchor.constraint(equalTo: safeArea.leftAnchor, constant: 18).isActive = true
        imageView.rightAnchor.constraint(equalTo: safeArea.rightAnchor, constant: -18).isActive = true
        imageView.topAnchor.constraint(equalTo: translationSplitter.bottomAnchor, constant: 18).isActive = true
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
