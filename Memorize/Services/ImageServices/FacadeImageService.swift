//
//  FacadeImageService.swift
//  Memorize
//
//  Created by Вика on 09/12/2019.
//  Copyright © 2019 Vika Olegova. All rights reserved.
//

import Foundation

/// Интерфейс для получения изображений и ссылок на них
protocol ImageServiceProtocol {
    /// Загружает все найденные ссылки на изображения по заданному слову и создает объекты ImageWithPath со ссылкой на изображение
    ///
    /// - Parameters:
    ///   - searchString: заданное слово для поиска изображений
    ///   - completion: сообщает о конце выполнения функции
    /// - Returns: массив объектов ImageWithPath, в которых заполнено только полем path
    func loadImageList(searchString: String,
                       completion: @escaping ([ImageWithPath]) -> ())
    
    /// Загружает изображение по ссылке, хранимой в поле path объекта ImageWithPath, и заполняет поле uiImage этого объекта
    ///
    /// - Parameters:
    ///   - image: объект ImageWithPath с заполненным полем path
    ///   - completion: сообщает о конце выполнения функции
    /// - Returns: массив объектов ImageWithPath, в которых заполнено полем uiImage
    func loadImage(for image: ImageWithPath,
                   completion: @escaping (ImageWithPath) -> ())
}

class FacadeImageService: ImageServiceProtocol {
    let googleImageService: GoogleImageService
    let flickrService: FlickrService
    let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
        googleImageService = GoogleImageService(networkService: networkService)
        flickrService = FlickrService(networkService: networkService)
    }
    
    func loadImageList(searchString: String, completion: @escaping ([ImageWithPath]) -> ()) {
        googleImageService.loadImageList(searchString: searchString) { [weak self] (googleImages) in
            guard googleImages.isEmpty else {
                completion(googleImages)
                return
            }
            self?.flickrService.loadImageList(searchString: searchString, completion: { (flickrImages) in
                completion(flickrImages)
            })
        }
    }
    
    func loadImage(for image: ImageWithPath, completion: @escaping (ImageWithPath) -> ()) {
        googleImageService.loadImage(for: image) { completion($0) }
    }
}
