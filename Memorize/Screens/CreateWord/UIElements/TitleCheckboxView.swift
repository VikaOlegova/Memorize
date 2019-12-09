//
//  TitleCheckboxView.swift
//  Memorize
//
//  Created by Вика on 28/11/2019.
//  Copyright © 2019 Vika Olegova. All rights reserved.
//

import UIKit

/// Вьюха с чекбоксом и текстом к нему, которые находятся на одной строке и выравнены по центру
class TitleCheckboxView: UIView {
    let checkBox = CheckBox()
    let titleLabel = UILabel()
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(checkBox)
        addSubview(titleLabel)
        
        checkBox.heightAnchor.constraint(equalToConstant: 24).isActive = true
        checkBox.widthAnchor.constraint(equalToConstant: 24).isActive = true
        checkBox.rightAnchor.constraint(equalTo: titleLabel.leftAnchor, constant: -10).isActive = true
        checkBox.topAnchor.constraint(equalTo: topAnchor).isActive = true
        checkBox.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        titleLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
