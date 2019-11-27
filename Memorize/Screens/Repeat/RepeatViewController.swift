//
//  RepeatViewController.swift
//  Memorize
//
//  Created by Вика on 27/11/2019.
//  Copyright © 2019 Vika Olegova. All rights reserved.
//

import UIKit

class RepeatViewController: UIViewController {
    let stack = UIStackView()
    let translationsAndMistakesCount = TranslationsAndMistakesCount()
    let askingWordAndButton = AskingWordAndButton()
    let translation = TitleTextFieldView()
    let imageView = UIImageView()
    let greenButton = BigGreenButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        translation.label.text = "Перевод"
        translation.label.textColor = .gray
        translation.textField.placeholder = "Введите перевод"
        imageView.backgroundColor = .gray
        greenButton.setTitle("Показать перевод", for: .normal)
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stack)
        view.addSubview(imageView)
        view.addSubview(greenButton)
        
        stack.axis = .vertical
        stack.spacing = 15
        
        stack.addArrangedSubview(translationsAndMistakesCount)
        stack.addArrangedSubview(askingWordAndButton)
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
    }
}

class TranslationsAndMistakesCount: UIView {
    private let translationLabel = UILabel()
    let translationCounter = UILabel()
    private let mistakeLabel = UILabel()
    let mistakeCounter = UILabel()
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        translatesAutoresizingMaskIntoConstraints = false
        translationLabel.translatesAutoresizingMaskIntoConstraints = false
        translationCounter.translatesAutoresizingMaskIntoConstraints = false
        mistakeLabel.translatesAutoresizingMaskIntoConstraints = false
        mistakeCounter.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(translationCounter)
        addSubview(translationLabel)
        addSubview(mistakeCounter)
        addSubview(mistakeLabel)
        
        translationLabel.text = "Перевод:"
        mistakeLabel.text = "Ошибок:"
        translationCounter.text = "1/10"
        mistakeCounter.text = "0"
        
        translationCounter.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        translationCounter.topAnchor.constraint(equalTo: topAnchor).isActive = true
        translationCounter.heightAnchor.constraint(equalToConstant: 19).isActive = true
        
        translationLabel.rightAnchor.constraint(equalTo: translationCounter.leftAnchor, constant: -4).isActive = true
        translationLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        translationLabel.heightAnchor.constraint(equalToConstant: 19).isActive = true
        
        mistakeCounter.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        mistakeCounter.topAnchor.constraint(equalTo: translationLabel.bottomAnchor, constant: 1).isActive = true
        mistakeCounter.heightAnchor.constraint(equalToConstant: 19).isActive = true
        
        mistakeLabel.rightAnchor.constraint(equalTo: mistakeCounter.leftAnchor, constant: -4).isActive = true
        mistakeLabel.topAnchor.constraint(equalTo: translationLabel.bottomAnchor, constant: 1).isActive = true
        mistakeLabel.heightAnchor.constraint(equalToConstant: 19).isActive = true
        mistakeLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class AskingWordAndButton: UIView {
    let wordLabel = UILabel()
    let audioButton = UIButton()
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        translatesAutoresizingMaskIntoConstraints = false
        wordLabel.translatesAutoresizingMaskIntoConstraints = false
        audioButton.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(wordLabel)
        addSubview(audioButton)
        
        wordLabel.text = "Я пришел к тебе с приветом, рассказать, что солнце встало и все в таком духе, только"
        wordLabel.font = .systemFont(ofSize: 22)
        wordLabel.lineBreakMode = .byWordWrapping
        wordLabel.numberOfLines = 0
        
        audioButton.setImage(UIImage(named: "audio"), for: .normal)
        audioButton.addTarget(self, action: #selector(audioButtonTapped), for: .touchUpInside)
        
        wordLabel.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        wordLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -23).isActive = true
        wordLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        
        audioButton.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        audioButton.heightAnchor.constraint(equalToConstant: 22).isActive = true
        audioButton.widthAnchor.constraint(equalToConstant: 22).isActive = true
        audioButton.bottomAnchor.constraint(equalTo: wordLabel.bottomAnchor).isActive = true
        audioButton.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func audioButtonTapped() {
        print("audio button tapped")
    }
}
