//
//  CollectionVIewCellData.swift
//  Memorize
//
//  Created by Вика on 04/12/2019.
//  Copyright © 2019 Vika Olegova. All rights reserved.
//

import UIKit

/// Класс данных ячейки коллекшн вью с экрана создания\редактирования слова
class ImageCollectionViewCellData {
    var image: UIImage?
    
    /// загрузилось изображение или нет
    var isLoaded: Bool { return image != nil }
    
    /// хитрая(нет) замена конструктора без параметров
    static var loading: ImageCollectionViewCellData {
        return ImageCollectionViewCellData()
    }
    
    private init() { }
    
    init(image: UIImage) {
        self.image = image
    }
}
