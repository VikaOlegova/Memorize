//
//  TranslationsAndMistakesCount.swift
//  Memorize
//
//  Created by Вика on 27/11/2019.
//  Copyright © 2019 Vika Olegova. All rights reserved.
//

import UIKit

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
