//
//  MainMenuViewController.swift
//  Memorize
//
//  Created by Вика on 25/11/2019.
//  Copyright © 2019 Vika Olegova. All rights reserved.
//

import UIKit

/// Протокол входных данных для экрана главного меню
protocol MainMenuViewInput: class {
    /// Показывает кол-во слов для повторения
    ///
    /// - Parameter repeatWordsCount: кол-во слов для повторения
    func show(repeatWordsCount: Int)
    
    /// Показывает кол-во всех слов
    ///
    /// - Parameter allWordsCount: кол-во всех слов
    func show(allWordsCount: Int)
    
    /// Делает доступными\недоступными элементы на вью
    ///
    /// - Parameter enable: доступны или нет
    func enableInteraction(_ enable: Bool)
}

/// Протокол выходных данных для экрана главного меню
protocol MainMenuViewOutput: class {
    /// Событие на загрузку экрана главного меню
    func viewDidLoad()
    
    /// Событие на предпоявление экрана
    func viewWillAppear()
    
    /// Событие на нажатие кнопки Повторить
    func repeatWordsButtonTapped()
    
    /// Событие на нажатие кнопки Все переводы
    func allWordsButtonTapped()
}

/// Экран главного меню
class MainMenuViewController: UIViewController {
    private let repeatWordsButton = MainMenuButton()
    private let allWordsButton = MainMenuButton()
    
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
}

