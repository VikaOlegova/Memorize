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
    func show(images: [ImageCollectionViewCellData])
    func removeImage(at index: Int)
    func show(languageInfo: String)
    func show(reverseTranslationEnabled: Bool)
    func show(title: String)
    func showLoadingIndicator(_ show: Bool)
    func showAlert(title: String)
    func enableGreenButton(enable: Bool)
}

protocol EditPairViewOutput: class {
    func saveTapped(originalWord: String?,
                    translatedWord: String?,
                    reverseTranslationEnabled: Bool,
                    image: UIImage?)
    func viewDidLoad()
    func didChange(originalWord: String)
    func didTapFromToButton(with originalWord: String)
}

class EditPairViewController: UIViewController {
    private let stackView = UIStackView()
    private let originalView = TitleTextFieldView()
    private let fromToButton = UIButton()
    private let checkBoxView = TitleCheckboxView()
    private let translationView = TitleTextFieldView()
    private let collectionView: UICollectionView
    private let flowLayout: UICollectionViewFlowLayout
    
    private let saveButton = BigGreenButton()
    private var images = [ImageCollectionViewCellData]()
    
    private var searchWorkItem = DispatchWorkItem(block: { })
    private let presenter: EditPairViewOutput
    
    private var currentImageCell: ImageCollectionViewCellData?
    
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
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: "ImageCollectionViewCell")
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
    
    @objc func fromToButtonTapped() {
        guard let text = originalView.textField.text else { return }
        presenter.didTapFromToButton(with: text)
    }
    
    @objc func saveButtonTapped() {
        presenter.saveTapped(originalWord: originalView.textField.text,
                             translatedWord: translationView.textField.text,
                             reverseTranslationEnabled: checkBoxView.checkBox.isSelected,
                             image: currentImageCell?.image)
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
        translationView.textField.text = translation
    }
    
    func show(images: [ImageCollectionViewCellData]) {
        self.images = images
        self.collectionView.reloadSections([0])
    }
    
    func removeImage(at index: Int) {
        images.remove(at: index)
        collectionView.deleteItems(at: [IndexPath(row: index, section: 0)])
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
        show ? translationView.spinner.startAnimating() : translationView.spinner.stopAnimating()
    }
    
    func showAlert(title: String) {
        let alertController = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "ОК", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func enableGreenButton(enable: Bool) {
        saveButton.isEnabled = enable
    }
}

extension EditPairViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath) as! ImageCollectionViewCell
        let data = images[indexPath.row]
        
        cell.displayData(data: data)
        
        return cell
    }
}

extension EditPairViewController: UICollectionViewDelegate {
    private func updateSelectedCell() {
        let indexPaths = collectionView.indexPathsForVisibleItems
        guard let index = indexPaths.first?.row else { return }
        currentImageCell = images[index]
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didEndDisplaying cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        updateSelectedCell()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        updateSelectedCell()
    }
}
