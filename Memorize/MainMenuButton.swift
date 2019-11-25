//
//  MainMenuButton.swift
//  Memorize
//
//  Created by Вика on 26/11/2019.
//  Copyright © 2019 Vika Olegova. All rights reserved.
//

import UIKit

class MainMenuButton: UIButton {
    let roundedBackgroundView = RoundedBackgroundView()
    let leftLabel = UILabel()
    let rightLabel = UILabel()
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        translatesAutoresizingMaskIntoConstraints = false
        leftLabel.translatesAutoresizingMaskIntoConstraints = false
        rightLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(roundedBackgroundView)
        sendSubviewToBack(roundedBackgroundView)
        addSubview(leftLabel)
        addSubview(rightLabel)
        
        roundedBackgroundView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        roundedBackgroundView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        roundedBackgroundView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        roundedBackgroundView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        leftLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 11).isActive = true
        leftLabel.topAnchor.constraint(equalTo: topAnchor, constant: 11).isActive = true
        leftLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -11).isActive = true
        
        rightLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -11).isActive = true
        rightLabel.topAnchor.constraint(equalTo: topAnchor, constant: 11).isActive = true
        rightLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -11).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
