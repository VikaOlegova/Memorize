//
//  AllWordsViewController.swift
//  Memorize
//
//  Created by Вика on 26/11/2019.
//  Copyright © 2019 Vika Olegova. All rights reserved.
//

import UIKit

class AllWordsViewController: UIViewController {
    let tableView = UITableView(frame: .zero, style: .plain)
    var data = [TranslationPairViewModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        navigationItem.title = "Переводы"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonClicked))
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(tableView)
        
        tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        tableView.register(TranslationPairCell.self, forCellReuseIdentifier: "TranslationPairCell")
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
        data = [TranslationPairViewModel(firstWord: "Яблоко ЯблокоЯблоко ЯблокоЯблоко Яблоко ЯблокоЯблоко", secondWord: "Apple  ЯблокоЯблоко ЯблокоЯблоко Яблоко ЯблокоЯблоко"),
                TranslationPairViewModel(firstWord: "Ручка", secondWord: "Pen")]
        
        tableView.reloadData()
    }
    
    @objc func addButtonClicked() {
        
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
