//
//  ResultViewController.swift
//  Memorize
//
//  Created by Вика on 01/12/2019.
//  Copyright © 2019 Vika Olegova. All rights reserved.
//

import UIKit

/// Протокол входных данных для экрана результата
protocol ResultViewInput: class {
    /// Показывает заголовок экрана
    ///
    /// - Parameter title: заголовок
    func show(title: String)
    
    /// Показывает текст зеленой кнопки
    ///
    /// - Parameter textButton: текст кнопки
    func show(textButton: String)
    
    /// Отдает массив всех существующих слов в кордате в формате вью модели
    ///
    /// - Parameter allWords:
    func show(allWords: [ResultViewModel])
}

/// Протокол выходных данных с экрана результата
protocol ResultViewOutput: class {
    /// Событие нажатия на кнопку
    func didTapGreenButton()
    
    /// Вьюха загрузилась
    func viewDidLoad()
}

/// Экран результата повторения\исправления ошибок
class ResultViewController: UIViewController {
    private let tableView = UITableView(frame: .zero, style: .plain)
    private let greenButton = BigGreenButton()
    private var data = [ResultViewModel]()
    
    private let presenter: ResultViewOutput
    
    init(presenter: ResultViewOutput) {
        self.presenter = presenter
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        tableView.contentInset.top = 7
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        greenButton.addTarget(self, action: #selector(greenButtonTapped), for: .touchUpInside)
        
        view.addSubview(tableView)
        view.addSubview(greenButton)
        
        greenButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 18).isActive = true
        greenButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -18).isActive = true
        greenButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -18).isActive = true
        
        tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: greenButton.topAnchor, constant: -18).isActive = true
        
        tableView.register(ResultCell.self, forCellReuseIdentifier: "ResultCell")
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
        presenter.viewDidLoad()
        
        tableView.reloadData()
    }
    
    @objc func greenButtonTapped() {
        presenter.didTapGreenButton()
    }
}

extension ResultViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResultCell", for: indexPath) as! ResultCell
        cell.viewModel = data[indexPath.row]
        
        return cell
    }
}

extension ResultViewController: ResultViewInput {
    func show(title: String) {
        navigationItem.title = title
    }
    
    func show(textButton: String) {
        greenButton.setTitle(textButton, for: .normal)
    }
    
    func show(allWords: [ResultViewModel]) {
        data = allWords
    }
}
