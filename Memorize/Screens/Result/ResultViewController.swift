//
//  ResultViewController.swift
//  Memorize
//
//  Created by Вика on 01/12/2019.
//  Copyright © 2019 Vika Olegova. All rights reserved.
//

import UIKit

protocol ResultViewInput: class {
    func show(title: String)
    func show(textButton: String)
    func show(allWords: [ResultViewModel])
}

protocol ResultViewOutput: class {
    func didTapGreenButton()
    func viewDidLoad()
}

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
