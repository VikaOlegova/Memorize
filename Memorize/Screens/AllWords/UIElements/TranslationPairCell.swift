//
//  TranslationPairCell.swift
//  Memorize
//
//  Created by Вика on 26/11/2019.
//  Copyright © 2019 Vika Olegova. All rights reserved.
//

import UIKit

class TranslationPairCell: UITableViewCell {
    let roundedBackgroundView = RoundedBackgroundView()
    let topLabels = DoubleLabel(multiline: true)
    let bottomLabels = DoubleLabel(multiline: true)
    
    var viewModel: TranslationPairViewModel? {
        didSet {
            guard let model = viewModel else { return }
            topLabels.leftLabel.text = model.firstWord
            bottomLabels.leftLabel.text = model.secondWord
            topLabels.rightLabel.text = "RU"
            bottomLabels.rightLabel.text = "EN"
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let stackView = UIStackView(arrangedSubviews: [topLabels, bottomLabels])
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 5
        
        contentView.addSubview(roundedBackgroundView)
        let container = roundedBackgroundView.containerView
        container.addSubview(stackView)
        
        roundedBackgroundView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 15).isActive = true
        roundedBackgroundView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -15).isActive = true
        roundedBackgroundView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 7).isActive = true
        roundedBackgroundView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -7).isActive = true
        
        stackView.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 11).isActive = true
        stackView.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -11).isActive = true
        stackView.topAnchor.constraint(equalTo: container.topAnchor, constant: 11).isActive = true
        stackView.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -11).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
