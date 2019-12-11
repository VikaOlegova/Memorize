//
//  AllWordsViewController.swift
//  Memorize
//
//  Created by Вика on 26/11/2019.
//  Copyright © 2019 Vika Olegova. All rights reserved.
//

import UIKit

protocol AllWordsViewInput: class {
    func show(allWords: [TranslationPairViewModel])
}

protocol AllWordsViewOutput: class {
    func viewDidLoad()
    func viewWillAppear()
    func addButtonTapped()
    func cellTapped(with pair: TranslationPairViewModel)
    func didDelete(pair: TranslationPairViewModel)
}

class AllWordsViewController: UIViewController {
    let tableView = UITableView(frame: .zero, style: .plain)
    var data = [TranslationPairViewModel]()
    
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
        navigationItem.title = "Переводы"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        
        tableView.contentInset.top = 7
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(tableView)
        
        tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
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
        presenter.didDelete(pair: data[indexPath.row])
        data.remove(at: indexPath.row)
    }
}

extension AllWordsViewController: AllWordsViewInput {
    func show(allWords: [TranslationPairViewModel]) {
        data = allWords
        tableView.reloadData()
    }
}
