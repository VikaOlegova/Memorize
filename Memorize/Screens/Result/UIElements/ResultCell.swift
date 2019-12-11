//
//  ResultCell.swift
//  Memorize
//
//  Created by Вика on 01/12/2019.
//  Copyright © 2019 Vika Olegova. All rights reserved.
//

import UIKit

class ResultCell: UITableViewCell {
    private let roundedBackgroundView = RoundedBackgroundView()
    private let wordLabel = UILabel()
    private let rightImageView = UIImageView()
    
    var viewModel: ResultViewModel? {
        didSet {
            guard let model = viewModel else { return }
            wordLabel.text = model.word
            rightImageView.image = model.image
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        wordLabel.translatesAutoresizingMaskIntoConstraints = false
        rightImageView.translatesAutoresizingMaskIntoConstraints = false
        
        rightImageView.contentMode = .scaleAspectFit
        wordLabel.lineBreakMode = .byWordWrapping
        wordLabel.numberOfLines = 0
        
        contentView.addSubview(roundedBackgroundView)
        let container = roundedBackgroundView.containerView
        container.addSubview(wordLabel)
        container.addSubview(rightImageView)
        
        roundedBackgroundView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 15).isActive = true
        roundedBackgroundView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -15).isActive = true
        roundedBackgroundView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 7).isActive = true
        roundedBackgroundView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -7).isActive = true
        
        wordLabel.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 12).isActive = true
        wordLabel.rightAnchor.constraint(equalTo: rightImageView.leftAnchor, constant: -5).isActive = true
        wordLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 12).isActive = true
        wordLabel.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -12).isActive = true
        
        rightImageView.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -10).isActive = true
        rightImageView.centerYAnchor.constraint(equalTo: wordLabel.centerYAnchor).isActive = true
        rightImageView.heightAnchor.constraint(equalToConstant: 17).isActive = true
        rightImageView.widthAnchor.constraint(equalToConstant: 17).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
