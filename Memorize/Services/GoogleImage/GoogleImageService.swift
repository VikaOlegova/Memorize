//
//  GoogleImageService.swift
//  Memorize
//
//  Created by Вика on 03/12/2019.
//  Copyright © 2019 Vika Olegova. All rights reserved.
//

import Foundation

class GoogleImageService {
    private struct ResponseData: Decodable {
        let items: [ResponseItem]
    }
    
    private struct ResponseItem: Decodable {
        let link: String
    }
    
    let networkService = NetworkService()
    
    func loadImageList(searchString: String,
                               completion: @escaping ([GoogleImage]) -> ()) {
        let url = GoogleImageAPI.searchPath(text: searchString)
        networkService.getData(at: url) { data in
            print(String(data: data!, encoding: .utf8))
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