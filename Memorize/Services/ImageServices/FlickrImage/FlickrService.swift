//
//  FlickrService.swift
//  Memorize
//
//  Created by Вика on 09/12/2019.
//  Copyright © 2019 Vika Olegova. All rights reserved.
//

import Foundation

/// Класс для получения изображений и ссылок на них c фликра
class FlickrService: ImageServiceProtocol {
    private struct ResponseData: Decodable {
        let photos: ResponsePhoto
    }
    
    private struct ResponsePhoto: Decodable {
        let photo: [ResponseURL]
    }
    
    private struct ResponseURL: Decodable {
        let url_m: String?
    }
    
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    func loadImageList(searchString: String, completion: @escaping ([ImageWithPath]) -> ()) {
        let url = FlickrAPI.searchPath(text: searchString)
        networkService.getData(at: url) { data in
            guard let data = data,
                let parsed = try? JSONDecoder().decode(ResponseData.self, from: data)
                else {
                    DispatchQueue.main.async { completion([]) }
                    return
            }

            let flickrImages = parsed.photos.photo.compactMap{ (object) -> ImageWithPath? in
                guard
                    let urlString = object.url_m,
                    let url = URL(string: urlString)
                    else { return nil }
                
                return ImageWithPath(path: url, uiImage: nil)
            }
            DispatchQueue.main.async { completion(flickrImages) }
        }
    }
    
    func loadImage(for image: ImageWithPath, completion: @escaping (ImageWithPath) -> ()) {
        networkService.loadImage(at: image.path) { loadedImage in
            guard let loadedImage = loadedImage else {
                DispatchQueue.main.async { completion(image) }
                return
            }
            DispatchQueue.main.async { completion(image.with(uiImage: loadedImage)) }
        }
    }
}
