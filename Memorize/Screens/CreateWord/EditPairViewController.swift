//
//  EditPairViewController.swift
//  Memorize
//
//  Created by Вика on 26/11/2019.
//  Copyright © 2019 Vika Olegova. All rights reserved.
//

import UIKit

/// Протокол входных данных для экрана создания\редактирования слова
protocol EditPairViewInput: class {
    /// Показывает слово и говорит, нужно ли отображать чекбокс для создания обратной пары
    ///
    /// - Parameters:
    ///   - originalWord: слово
    ///   - reverseTranslationCheckBox: нужно ли отображать чекбокс для создания обратной пары
    func show(originalWord: String, reverseTranslationCheckBox: Bool)
    
    /// Показывает перевод слова
    ///
    /// - Parameter translation: перевод
    func show(translation: String)
    
    /// Показывает изображения к слову
    ///
    /// - Parameter images: массив изображений, а точнее, массив объеков данных для ячейки
    func show(images: [ImageCollectionViewCellData])
    
    /// Удаляет изображение из коллекшн вью и локального массива со всеми изображениями
    ///
    /// - Parameter index: индекс удаляемого изображения
    func removeImage(at index: Int)
    
    /// Показывает информацию о языке слова и его перевода
    ///
    /// - Parameter languageInfo: информация о языке слова и его перевода
    func show(languageInfo: String)
    
    /// Показывает состояние чекбокса (отмечен или нет)
    ///
    /// - Parameter reverseTranslationEnabled: состояние чекбокса (отмечен или нет)
    func show(reverseTranslationEnabled: Bool)
    
    /// Показывает заголовок экрана
    ///
    /// - Parameter title: заголовок экрана
    func show(title: String)
    
    /// Показывает спиннер загрузки перевода слова
    ///
    /// - Parameter show: показать спиннер или нет
    func showLoadingIndicator(_ show: Bool)
    
    /// Делает доступной или недоступной зеленую кнопку
    ///
    /// - Parameter enable: доступна или нет
    func enableGreenButton(enable: Bool)
}

/// Протокол выходных данных с экрана создания\редактирования слова
protocol EditPairViewOutput: class {
    /// Событие на нажатие кнопки Сохранить
    ///
    /// - Parameters:
    ///   - originalWord: новое слово
    ///   - translatedWord: новый перевод
    ///   - reverseTranslationEnabled: создавать ли обратную пару
    ///   - image: новое изображение к слову
    func saveTapped(originalWord: String?,
                    translatedWord: String?,
                    reverseTranslationEnabled: Bool,
                    image: UIImage?)
    
    /// Событие на загрузку экрана
    func viewDidLoad()
    
    /// Событие на изменение слова
    ///
    /// - Parameter originalWord: измененное слово
    func didChange(originalWord: String)
    
    /// Событие на нажатие кнопки с информацией о языке слова и его перевода
    ///
    /// - Parameter originalWord: слово
    func didTapFromToButton(with originalWord: String)
}

/// Экран создания\редактирования слова
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
        originalView.textField.returnKeyType = .done
        originalView.textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        originalView.textField.delegate = self
        fromToButton.setTitleColor(.black, for: .normal)
        fromToButton.addTarget(self, action:#selector(fromToButtonTapped), for: .touchUpInside)
        checkBoxView.titleLabel.text = "Создать обратный перевод"
        translationView.label.text = "Перевод"
        translationView.textField.placeholder = "Введите перевод"
        translationView.textField.returnKeyType = .done
        translationView.textField.delegate = self
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

extension EditPairViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldLength = textField.text?.count ?? 0
        let replacementLength = string.count
        let rangeLength = range.length
        print(rangeLength)
        
        let newLength = oldLength - rangeLength + replacementLength
        
        return newLength <= 80
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
