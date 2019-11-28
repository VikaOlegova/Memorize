//
//  EditPairViewController.swift
//  Memorize
//
//  Created by Вика on 26/11/2019.
//  Copyright © 2019 Vika Olegova. All rights reserved.
//

import UIKit

protocol EditPairViewInput: class {
    func showWords(original: String, translation: String, reverseTranslationCheckBox: Bool)
    func show(image: UIImage?)
    func show(languageInfo: String)
    func show(reverseTranslationEnabled: Bool)
    func show(title: String)
}

protocol EditPairViewOutput: class {
    func saveTapped(originalWord: String?,
                    translationWord: String?,
                    reverseTranslationEnabled: Bool )
    func viewDidLoad()
}

class EditPairViewController: UIViewController {
    let stackView = UIStackView()
    let originalView = TitleTextFieldView()
    let fromToButton = UIButton()
    let checkBoxView = TitleCheckboxView()
    let translationView = TitleTextFieldView()
    let imageView = UIImageView()
    let saveButton = BigGreenButton()
    
    let presenter: EditPairViewOutput
    
    init(presenter: EditPairViewOutput) {
        self.presenter = presenter
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.axis = .vertical
        stackView.spacing = 18
        
        view.addSubview(stackView)
        stackView.addArrangedSubview(originalView)
        stackView.addArrangedSubview(fromToButton)
        stackView.addArrangedSubview(checkBoxView)
        stackView.addArrangedSubview(translationView)
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(saveButton)
        
        originalView.label.text = "Новое слово или фраза"
        originalView.textField.placeholder = "Введите слово"
        fromToButton.setTitleColor(.black, for: .normal)
        fromToButton.addTarget(self, action:#selector(fromToButtonTapped), for: .touchUpInside)
        checkBoxView.titleLabel.text = "Создать обратный перевод"
        translationView.label.text = "Перевод"
        translationView.textField.placeholder = "Введите перевод"
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .gray
        saveButton.setTitle("Сохранить", for: .normal)
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        
        let safeArea = view.safeAreaLayoutGuide
        
        stackView.leftAnchor.constraint(equalTo: safeArea.leftAnchor, constant: 18).isActive = true
        stackView.rightAnchor.constraint(equalTo: safeArea.rightAnchor, constant: -18).isActive = true
        stackView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 18).isActive = true
        stackView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -18).isActive = true
        
        fromToButton.centerXAnchor.constraint(equalTo: stackView.centerXAnchor).isActive = true
        fromToButton.heightAnchor.constraint(equalToConstant: 21).isActive = true
        imageView.bottomAnchor.constraint(equalTo: saveButton.topAnchor, constant: -32).isActive = true
        
        stackView.setCustomSpacing(8, after: fromToButton)
        
        presenter.viewDidLoad()
    }
    
    @objc func fromToButtonTapped() {
        
    }
    
    @objc func saveButtonTapped() {
        presenter.saveTapped(originalWord: originalView.textField.text,
                             translationWord: translationView.textField.text,
                             reverseTranslationEnabled: checkBoxView.checkBox.isSelected)
    }
}

extension EditPairViewController: EditPairViewInput {
    func showWords(original: String, translation: String, reverseTranslationCheckBox:  Bool) {
        originalView.textField.text = original
        translationView.textField.text = translation
        checkBoxView.isHidden = !reverseTranslationCheckBox
        
    }
    
    func show(image: UIImage?) {
        imageView.image = image
    }
    
    func show(languageInfo: String) {
        fromToButton.setTitle(languageInfo, for: .normal)
    }
    
    func show(reverseTranslationEnabled: Bool) {
        checkBoxView.checkBox.isSelected = reverseTranslationEnabled
    }
    
    func show(title: String) {
        navigationItem.title = title
    }
    
    
}
