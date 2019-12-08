//
//  GoogleImage.swift
//  Memorize
//
//  Created by Вика on 03/12/2019.
//  Copyright © 2019 Vika Olegova. All rights reserved.
//

import UIKit

/// Структура, содержащая изображение и ссылку, по которой это изображение было получено
struct GoogleImage {
    /// Ссылка на изображение
    let path: URL
    /// Изображение, полученное по ссылке
    let uiImage: UIImage?
    
    /// Заполняет поле uiImage
    ///
    /// - Parameter uiImage: изображение
    /// - Returns: объект GoogleImage с заполненным полем uiImage
    func with(uiImage: UIImage) -> GoogleImage {
        return GoogleImage(path: path,
                           uiImage: uiImage)
    }
}
