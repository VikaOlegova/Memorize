//
//  AudioLabel.swift
//  Memorize
//
//  Created by Вика on 27/11/2019.
//  Copyright © 2019 Vika Olegova. All rights reserved.
//

import UIKit

class AudioLabel: UIView {
    let wordLabel = UILabel()
    let audioButton = UIButton()
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        translatesAutoresizingMaskIntoConstraints = false
        wordLabel.translatesAutoresizingMaskIntoConstraints = false
        audioButton.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(wordLabel)
        addSubview(audioButton)
        
        wordLabel.text = "iOS разработка и горящие дедлайны - веселье на всю ночь"
        wordLabel.font = .systemFont(ofSize: 22)
        wordLabel.lineBreakMode = .byWordWrapping
        wordLabel.numberOfLines = 0
        
        audioButton.setImage(UIImage(named: "audio"), for: .normal)
        audioButton.addTarget(self, action: #selector(audioButtonTapped), for: .touchUpInside)
        
        wordLabel.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        wordLabel.rightAnchor.constraint(equalTo: audioButton.leftAnchor, constant: -1).isActive = true
        wordLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        
        audioButton.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        audioButton.heightAnchor.constraint(equalToConstant: 22).isActive = true
        audioButton.widthAnchor.constraint(equalToConstant: 22).isActive = true
        audioButton.bottomAnchor.constraint(equalTo: wordLabel.bottomAnchor).isActive = true
        audioButton.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func audioButtonTapped() {
        print("audio button tapped")
    }
}
