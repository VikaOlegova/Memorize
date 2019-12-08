//
//  MainMenuViewController.swift
//  Memorize
//
//  Created by Вика on 25/11/2019.
//  Copyright © 2019 Vika Olegova. All rights reserved.
//

import UIKit

protocol MainMenuViewInput: class {
    func show(repeatWordsCount: Int)
    func show(allWordsCount: Int)
    func showNoWordsAllert()
    func enableInteraction(_ enable: Bool)
}

protocol MainMenuViewOutput: class {
    func viewDidLoad()
    func viewWillAppear()
    func repeatWordsButtonTapped()
    func allWordsButtonTapped()
}

class MainMenuViewController: UIViewController {
    let repeatWordsButton = MainMenuButton()
    let allWordsButton = MainMenuButton()
    
    let presenter: MainMenuViewOutput
    
    init(presenter: MainMenuViewOutput) {
        self.presenter = presenter
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.viewWillAppear()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        navigationItem.title = "Меню"
        
        view.addSubview(repeatWordsButton)
        view.addSubview(allWordsButton)
        
        repeatWordsButton.doubleLabel.leftLabel.text = "Повторить"
        repeatWordsButton.addTarget(self, action: #selector(repeatWordsButtonTapped), for: .touchUpInside)
        
        allWordsButton.doubleLabel.leftLabel.text = "Все переводы"
        allWordsButton.addTarget(self, action: #selector(allWordsButtonTapped), for: .touchUpInside)
        
        repeatWordsButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15).isActive = true
        repeatWordsButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15).isActive = true
        repeatWordsButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15).isActive = true
        repeatWordsButton.heightAnchor.constraint(equalToConstant: 46).isActive = true
        
        allWordsButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15).isActive = true
        allWordsButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15).isActive = true
        allWordsButton.topAnchor.constraint(equalTo: repeatWordsButton.bottomAnchor, constant: 15).isActive = true
        allWordsButton.heightAnchor.constraint(equalToConstant: 46).isActive = true
        
        presenter.viewDidLoad()
    }
    
    @objc func repeatWordsButtonTapped() {
        presenter.repeatWordsButtonTapped()
    }
    
    @objc func allWordsButtonTapped() {
        presenter.allWordsButtonTapped()
    }
}

extension MainMenuViewController: MainMenuViewInput {
    func enableInteraction(_ enable: Bool) {
        view.isUserInteractionEnabled = enable
    }
    
    func show(repeatWordsCount: Int) {
        repeatWordsButton.doubleLabel.rightLabel.text = String(repeatWordsCount)
    }
    
    func show(allWordsCount: Int) {
        allWordsButton.doubleLabel.rightLabel.text = String(allWordsCount)
    }
    
    func showNoWordsAllert() {
        let alertController = UIAlertController(title: "На сегодня все!", message: nil, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "ОК", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
}

