//
//  GoogleImageService.swift
//  Memorize
//
//  Created by Вика on 03/12/2019.
//  Copyright © 2019 Vika Olegova. All rights reserved.
//

import Foundation

protocol ImageServiceProtocol {
    func loadImageList(searchString: String,
                       completion: @escaping ([GoogleImage]) -> ())
    func loadImage(for image: GoogleImage,
                   completion: @escaping (GoogleImage) -> ())
}

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
