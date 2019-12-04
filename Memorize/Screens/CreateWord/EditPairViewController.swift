//
//  EditPairViewController.swift
//  Memorize
//
//  Created by Вика on 26/11/2019.
//  Copyright © 2019 Vika Olegova. All rights reserved.
//

import UIKit

protocol EditPairViewInput: class {
    func show(originalWord: String, reverseTranslationCheckBox: Bool)
    func show(translation: String)
    func show(images: [UIImage])
    func show(languageInfo: String)
    func show(reverseTranslationEnabled: Bool)
    func show(title: String)
    func showLoadingIndicator(_ show: Bool)
}

protocol EditPairViewOutput: class {
    func saveTapped(originalWord: String?,
                    translationWord: String?,
                    reverseTranslationEnabled: Bool)
    func viewDidLoad()
    func didChange(originalWord: String)
    func didTapFromToButton(with originalWord: String)
}

class EditPairViewController: UIViewController {
    let stackView = UIStackView()
    let originalView = TitleTextFieldView()
    let fromToButton = UIButton()
    let checkBoxView = TitleCheckboxView()
    let translationView = TitleTextFieldView()
    let collectionView: UICollectionView
    let flowLayout: UICollectionViewFlowLayout
    
    let saveButton = BigGreenButton()
    var images = [CollectionVIewCellData]()
    
    var fromLanguage: Language = .EN
    var toLanguage: Language = .RU
    
    var searchWorkItem = DispatchWorkItem(block: { })
    let presenter: EditPairViewOutput
    
    init(presenter: EditPairViewOutput) {
        self.presenter = presenter
        
        flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 18, bottom: 0, right: 18)
        flowLayout.minimumLineSpacing = 18 * 2
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.axis = .vertical
        stackView.spacing = 18
        
        view.addSubview(stackView)
        stackView.addArrangedSubview(originalView)
        stackView.addArrangedSubview(fromToButton)
        stackView.addArrangedSubview(checkBoxView)
        stackView.addArrangedSubview(translationView)
        
        let collectionViewContainer = UIView()
        collectionViewContainer.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionViewContainer.addSubview(collectionView)
        stackView.addArrangedSubview(collectionViewContainer)
        
        stackView.addArrangedSubview(saveButton)
        
        collectionView.dataSource = self
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: "CollectionViewCell")
        collectionView.alwaysBounceHorizontal = true
        collectionView.backgroundColor = .clear
        collectionView.isPagingEnabled = true
        
        originalView.label.text = "Новое слово или фраза"
        originalView.textField.placeholder = "Введите слово"
        originalView.textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        fromToButton.setTitleColor(.black, for: .normal)
        fromToButton.addTarget(self, action:#selector(fromToButtonTapped), for: .touchUpInside)
        checkBoxView.titleLabel.text = "Создать обратный перевод"
        translationView.label.text = "Перевод"
        translationView.textField.placeholder = "Введите перевод"
        saveButton.setTitle("Сохранить", for: .normal)
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        
        let safeArea = view.safeAreaLayoutGuide
        
        stackView.leftAnchor.constraint(equalTo: safeArea.leftAnchor, constant: 18).isActive = true
        stackView.rightAnchor.constraint(equalTo: safeArea.rightAnchor, constant: -18).isActive = true
        stackView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 18).isActive = true
        stackView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -18).isActive = true
        
        fromToButton.centerXAnchor.constraint(equalTo: stackView.centerXAnchor).isActive = true
        fromToButton.heightAnchor.constraint(equalToConstant: 21).isActive = true
        
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: collectionViewContainer.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: collectionViewContainer.bottomAnchor).isActive = true
        
        stackView.setCustomSpacing(8, after: fromToButton)
        
        presenter.viewDidLoad()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        flowLayout.itemSize = collectionView.frame.size
        flowLayout.itemSize.width -= 18 * 2
        collectionView.reloadData()
    }
    
    func createCollectionView() {
//
    }
    
    @objc func fromToButtonTapped() {
        guard let text = originalView.textField.text, !text.isEmpty else { return }
        presenter.didTapFromToButton(with: text)
    }
    
    @objc func saveButtonTapped() {
        presenter.saveTapped(originalWord: originalView.textField.text,
                             translationWord: translationView.textField.text,
                             reverseTranslationEnabled: checkBoxView.checkBox.isSelected)
    }
    
    @objc func textFieldDidChange() {
        let currentText = originalView.textField.text ?? ""
        searchWorkItem.cancel()
        if currentText.isEmpty {
            translationView.textField.text = ""
            return
        }
        searchWorkItem = DispatchWorkItem(block: { [weak self] in
            self?.presenter.didChange(originalWord: currentText)
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: searchWorkItem)
    }
}

extension EditPairViewController: EditPairViewInput {
    func show(originalWord: String, reverseTranslationCheckBox: Bool) {
        originalView.textField.text = originalWord
        checkBoxView.isHidden = !reverseTranslationCheckBox
        
    }
    
    func show(translation: String) {
        DispatchQueue.main.async { [weak self] in
            self?.translationView.textField.text = translation
        }
    }
    
    func show(images: [UIImage]) {
        self.images = images.map { return CollectionVIewCellData(image: $0)}
    }
    
    func show(languageInfo: String) {
        fromToButton.setTitle(languageInfo, for: .normal)
    }
    
    func show(reverseTranslationEnabled: Bool) {
        checkBoxView.checkBox.isSelected = reverseTranslationEnabled
    }
    
    func show(title: String) {
        navigationItem.title = title
    }
    
    func showLoadingIndicator(_ show: Bool) {
        DispatchQueue.main.async { [weak self] in
            show ? self?.translationView.spinner.startAnimating() : self?.translationView.spinner.stopAnimating()
        }
    } 
}

extension EditPairViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        let data = images[indexPath.row]
        
        cell.displayData(data: data)
        
        return cell
    }
}
