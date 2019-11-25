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
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(roundedBackgroundView)
        sendSubviewToBack(roundedBackgroundView)
        
        roundedBackgroundView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        roundedBackgroundView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        roundedBackgroundView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        roundedBackgroundView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
