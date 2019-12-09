//
//  RoundedBackgroundView.swift
//  Memorize
//
//  Created by Вика on 25/11/2019.
//  Copyright © 2019 Vika Olegova. All rights reserved.
//

import UIKit

/// Вьюха с бледно-серым фоном
class RoundedBackgroundView: UIView {
    /// контейнер для расположения других ui элементов на бледно-сером фоне
    let containerView = UIView()
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        translatesAutoresizingMaskIntoConstraints = false
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 1.0)
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 4.0
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = UIColor(white: 249/255.0, alpha: 1)
        containerView.layer.cornerRadius = 12.0
        containerView.layer.masksToBounds = true
        
        addSubview(containerView)
        
        containerView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        containerView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        containerView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
