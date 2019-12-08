//
//  GoogleImageService.swift
//  Memorize
//
//  Created by Вика on 03/12/2019.
//  Copyright © 2019 Vika Olegova. All rights reserved.
//

import Foundation

/// Интерфейс для получения изображений и ссылок на них
protocol ImageServiceProtocol {
    /// Загружает все найденные ссылки на изображения по заданному слову и создает объекты GoogleImage со ссылкой на изображение
    ///
    /// - Parameters:
    ///   - searchString: заданное слово для поиска изображений
    ///   - completion: сообщает о конце выполнения функции
    /// - Returns: массив объектов GoogleImage, в которых заполнено только полем path
    func loadImageList(searchString: String,
                       completion: @escaping ([GoogleImage]) -> ())
    
    /// Загружает изображение по ссылке, хранимой в поле path объекта GoogleImage, и заполняет поле uiImage этого объекта
    ///
    /// - Parameters:
    ///   - image: объект GoogleImage с заполненным полем path
    ///   - completion: сообщает о конце выполнения функции
    /// - Returns: массив объектов GoogleImage, в которых заполнено полем uiImage
    func loadImage(for image: GoogleImage,
                   completion: @escaping (GoogleImage) -> ())
}

/// Класс для получения изображений и ссылок на них
class GoogleImageService: ImageServiceProtocol {
    private struct ResponseData: Decodable {
        let items: [ResponseItem]
    }
    
    private struct ResponseItem: Decodable {
        let link: String
    }
    
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    func loadImageList(searchString: String,
                       completion: @escaping ([GoogleImage]) -> ()) {
//        completion([])
//        return
        
        let url = GoogleImageAPI.searchPath(text: searchString)
        networkService.getData(at: url) { data in
            guard let data = data,
                let parsed = try? JSONDecoder().decode(ResponseData.self, from: data)
                else {
                    DispatchQueue.main.async { completion([]) }
                    return
            }
            
            let googleImages = parsed.items.compactMap { (object) -> GoogleImage? in
                guard let url = URL(string: object.link) else { return nil }
                return GoogleImage(path: url, uiImage: nil)
            }
            DispatchQueue.main.async { completion(googleImages) }
        }
    }
    
    func loadImage(for image: GoogleImage,
                           completion: @escaping (GoogleImage) -> ()) {
        networkService.loadImage(at: image.path) { loadedImage in
            guard let loadedImage = loadedImage else {
                DispatchQueue.main.async { completion(image) }
                return
            }
            DispatchQueue.main.async { completion(image.with(uiImage: loadedImage)) }
        }
    }
}
