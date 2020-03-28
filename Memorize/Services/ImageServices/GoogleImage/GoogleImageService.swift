//
//  GoogleImageService.swift
//  Memorize
//
//  Created by Вика on 03/12/2019.
//  Copyright © 2019 Vika Olegova. All rights reserved.
//

import Foundation

/// Класс для получения изображений и ссылок на них c гугла
class GoogleImageService: ImageWithOnlyPathServiceProtocol {
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
    
    func loadImageList(searchString: String, completion: @escaping ([ImageWithPath]) -> ()) {
        guard let url = GoogleImageAPI.searchPath(text: searchString) else {
            DispatchQueue.main.async { completion([]) }
            return
        }
        networkService.getData(at: url) { data in
            guard
                let data = data,
                let parsed = try? JSONDecoder().decode(ResponseData.self, from: data)
                else {
                    DispatchQueue.main.async { completion([]) }
                    return
            }
            
            let googleImages = parsed.items.compactMap { object -> ImageWithPath? in
                guard let url = URL(string: object.link) else { return nil }
                return ImageWithPath(path: url, uiImage: nil)
            }
            DispatchQueue.main.async { completion(googleImages) }
        }
    }
}
