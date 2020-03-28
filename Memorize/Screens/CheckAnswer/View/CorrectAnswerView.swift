//
//  CorrectAnswerView.swift
//  Memorize
//
//  Created by Вика on 29/11/2019.
//  Copyright © 2019 Vika Olegova. All rights reserved.
//

import UIKit

/// Вьюха, содержащая корректный перевод и оценку правильности ответа
class CorrectAnswerView: UIView {
    let colorView = UIView()
    let titleLabel = UILabel()
    private let helpLabel = UILabel()
    let correctTranslation = AudioLabel()
    let nextButton = UIButton()
    
    private lazy var hideLabelConstraint = helpLabel.heightAnchor.constraint(equalToConstant: 0)
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        translatesAutoresizingMaskIntoConstraints = false
        colorView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        helpLabel.translatesAutoresizingMaskIntoConstraints = false
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        
        let blueColor = UIColor(red: 47/255.0, green: 135/255.0, blue: 158/255.0, alpha: 1)
        
        titleLabel.font = UIFont(name:"HelveticaNeue-Bold", size: 18)
        titleLabel.textColor = .white
        helpLabel.text = "Правильный ответ"
        helpLabel.textColor = .gray
        nextButton.setTitle("Далее", for: .normal)
        nextButton.titleLabel?.font = .systemFont(ofSize: 18)
        nextButton.setTitleColor(blueColor, for: .normal)
        nextButton.layer.cornerRadius = 8
        nextButton.layer.borderWidth = 1
        nextButton.layer.borderColor = blueColor.cgColor
        
        addSubview(colorView)
        addSubview(titleLabel)
        addSubview(helpLabel)
        addSubview(correctTranslation)
        addSubview(nextButton)
        
        colorView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        colorView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        colorView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        colorView.heightAnchor.constraint(equalToConstant: 51).isActive = true
        
        titleLabel.centerXAnchor.constraint(equalTo: colorView.centerXAnchor).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: colorView.centerYAnchor).isActive = true
        
        helpLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 18).isActive = true
        helpLabel.topAnchor.constraint(equalTo: colorView.bottomAnchor, constant: 10).isActive = true
        
        correctTranslation.leftAnchor.constraint(equalTo: leftAnchor, constant: 18).isActive = true
        correctTranslation.rightAnchor.constraint(equalTo: rightAnchor, constant: -18).isActive = true
        correctTranslation.topAnchor.constraint(equalTo: helpLabel.bottomAnchor, constant: 3).isActive = true
        
        nextButton.topAnchor.constraint(equalTo: correctTranslation.bottomAnchor, constant: 18).isActive = true
        nextButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: 41).isActive = true
        nextButton.widthAnchor.constraint(equalToConstant: 192).isActive = true
        nextButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -18).isActive = true
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Скрывает вспомогательный лейбл, не нужный при правильном ответе
    ///
    /// - Parameter hide: скрыть или нет
    func hideHelpLabel(_ hide: Bool = true) {
        hideLabelConstraint.isActive = hide
    }
}
