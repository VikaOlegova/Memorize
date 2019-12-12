//
//  CollectionVIewCellData.swift
//  Memorize
//
//  Created by Вика on 04/12/2019.
//  Copyright © 2019 Vika Olegova. All rights reserved.
//

import UIKit

class ImageCollectionViewCellData {
    var image: UIImage?
    
    var isLoaded: Bool { return image != nil }
    
    static var loading: ImageCollectionViewCellData {
        return ImageCollectionViewCellData()
    }
    
    private init() { }
    
    init(image: UIImage) {
        self.image = image
    }
}
