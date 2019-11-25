//
//  DoubleLabel.swift
//  Memorize
//
//  Created by Вика on 26/11/2019.
//  Copyright © 2019 Vika Olegova. All rights reserved.
//

import UIKit

class DoubleLabel: UIStackView {
    let leftLabel = UILabel()
    let rightLabel = UILabel()
    
    convenience init(multiline: Bool = false) {
        self.init(frame: .zero)
        
        if multiline {
            leftLabel.numberOfLines = 0
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        translatesAutoresizingMaskIntoConstraints = false
        
        axis = .horizontal
        rightLabel.setContentHuggingPriority(.required, for: .horizontal)
        
        addArrangedSubview(leftLabel)
        addArrangedSubview(rightLabel)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
