//
//  AllWordsViewController.swift
//  Memorize
//
//  Created by Вика on 26/11/2019.
//  Copyright © 2019 Vika Olegova. All rights reserved.
//

import UIKit

/// Протокол входных данных для экрана всех слов
protocol AllWordsViewInput: AnyObject {
    /// Показывает все слова
    ///
    /// - Parameter allWords: массив всех слов, а точнее, массив моделей данных всех слов
    func show(allWords: [TranslationPairViewModel])
    
    /// Показать оповещение, что нет ни одного слова
    ///
    /// - Parameter isHidden: скрыть оповещение или нет
    func showPlaceholder(isHidden: Bool)
}

/// Протокол выходных данных с экрана всех слов
protocol AllWordsViewOutput: AnyObject {
    /// Событие на загрузку экрана всех слов
    func viewDidLoad()
    
    /// Событие на предпоявляение экрана всех слов
    func viewWillAppear()
    
    /// Событие на нажатие кнопки в правой части навигейшн бара
    func addButtonTapped()
    
    /// Событие на нажатие по ячейке таблицы
    ///
    /// - Parameter pair: слово, содержащееся в ячейке
    func cellTapped(with pair: TranslationPairViewModel)
    
    /// Событие на удаление ячейки
    ///
    /// - Parameters:
    ///   - pair: удаляемое слово
    ///   - allPairsCount: количество всех слов после удаления
    func didDelete(pair: TranslationPairViewModel, allPairsCount: Int)
    
    /// Событие на нажатие кнопки Создать, когда в таблице нет слов
    func createButtonTapped()
}

class AllWordsViewController: UIViewController {
    private let noWordsLabel = UILabel()
    private let createButton = UIButton()
    private let tableView = UITableView(frame: .zero, style: .plain)
    private var data = [TranslationPairViewModel]()
    
    let presenter: AllWordsViewOutput
    
    init(presenter: AllWordsViewOutput) {
        self.presenter = presenter
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        navigationItem.title = "Карточки"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        noWordsLabel.translatesAutoresizingMaskIntoConstraints = false
        createButton.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.contentInset.top = 7
        noWordsLabel.text = "У Вас пока нет карточек:("
        noWordsLabel.textColor = .gray
        createButton.setTitle("Создать", for: .normal)
        createButton.setTitleColor(UIColor(red: 102/255.0, green: 172/255.0, blue: 15/255.0, alpha: 1), for: .normal)
        createButton.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
        
        view.addSubview(tableView)
        view.addSubview(noWordsLabel)
        view.addSubview(createButton)
        
        tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        noWordsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        noWordsLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        createButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        createButton.topAnchor.constraint(equalTo: noWordsLabel.bottomAnchor, constant: 5).isActive = true
        
        tableView.register(TranslationPairCell.self, forCellReuseIdentifier: "TranslationPairCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        
        presenter.viewDidLoad()
        
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.viewWillAppear()
    }
    
    @objc func addButtonTapped() {
        presenter.addButtonTapped()
    }
    
    @objc func createButtonTapped() {
        presenter.createButtonTapped()
    }
}

extension AllWordsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TranslationPairCell", for: indexPath) as! TranslationPairCell
        cell.viewModel = data[indexPath.row]
        
        return cell
    }
}

extension AllWordsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.cellTapped(with: data[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        presenter.didDelete(pair: data[indexPath.row], allPairsCount: data.count - 1)
        data.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
}

extension AllWordsViewController: AllWordsViewInput {
    func show(allWords: [TranslationPairViewModel]) {
        data = allWords
        tableView.reloadData()
    }
    
    func showPlaceholder(isHidden: Bool) {
        noWordsLabel.isHidden = isHidden
        createButton.isHidden = isHidden
    }
}
