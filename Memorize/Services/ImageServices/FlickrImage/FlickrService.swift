//
//  FlickrService.swift
//  Memorize
//
//  Created by Вика on 09/12/2019.
//  Copyright © 2019 Vika Olegova. All rights reserved.
//

import Foundation

/// Класс для получения изображений и ссылок на них c фликра
class FlickrService: ImageWithOnlyPathServiceProtocol {
    private struct ResponseData: Decodable {
        let urlsForPhotos: URLsForPhotos
        
        struct URLsForPhotos: Decodable {
            let urls: [StringURL]
            
            struct StringURL: Decodable {
                let url_m: String?
            }
        }
    }
    
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    func loadImageList(searchString: String, completion: @escaping ([ImageWithPath]) -> ()) {
        guard let url = FlickrAPI.searchPath(text: searchString) else {
            DispatchQueue.main.async { completion([]) }
            return
        }
        networkService.getData(at: url) { data in
            guard let data = data,
                let parsed = try? JSONDecoder().decode(ResponseData.self, from: data)
                else {
                    DispatchQueue.main.async { completion([]) }
                    return
            }

            let flickrImages = parsed.urlsForPhotos.urls.compactMap{ object -> ImageWithPath? in
                guard
                    let urlString = object.url_m,
                    let url = URL(string: urlString)
                    else { return nil }

                return ImageWithPath(path: url, uiImage: nil)
            }
            DispatchQueue.main.async { completion(flickrImages) }
        }
    }
}
