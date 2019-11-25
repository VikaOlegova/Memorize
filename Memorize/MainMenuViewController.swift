//
//  MainMenuViewController.swift
//  Memorize
//
//  Created by Вика on 25/11/2019.
//  Copyright © 2019 Vika Olegova. All rights reserved.
//

import UIKit

class MainMenuViewController: UIViewController {
    let repeatWordsButton = MainMenuButton()
    let allWordsButton = MainMenuButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        navigationItem.title = "Меню"
        
        view.addSubview(repeatWordsButton)
        view.addSubview(allWordsButton)
        
        repeatWordsButton.leftLabel.text = "Повторить"
        repeatWordsButton.rightLabel.text = "10"
        
        allWordsButton.leftLabel.text = "Все переводы"
        allWordsButton.rightLabel.text = "30"
        
        repeatWordsButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15).isActive = true
        repeatWordsButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15).isActive = true
        repeatWordsButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15).isActive = true
        repeatWordsButton.heightAnchor.constraint(equalToConstant: 46).isActive = true
        
        allWordsButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15).isActive = true
        allWordsButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15).isActive = true
        allWordsButton.topAnchor.constraint(equalTo: repeatWordsButton.bottomAnchor, constant: 15).isActive = true
        allWordsButton.heightAnchor.constraint(equalToConstant: 46).isActive = true
    }


}

