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
            guard let data = data,
            let parsed = try? JSONDecoder().decode(ResponseData.self, from: data)
            else {
                completion([])
                return
            }
            
            let googleImages = parsed.items.compactMap { (object) -> GoogleImage? in
                guard let url = URL(string: object.link) else { return nil }
                return GoogleImage(path: url, uiImage: nil)
            }
            completion(googleImages)
        }
    }
    
    func loadUIImages(for images: [GoogleImage],
                      completion: @escaping ([GoogleImage]) -> ()) {
        let group = DispatchGroup()
        var newImages: [GoogleImage] = []
        for model in images {
            group.enter()
            networkService.loadImage(at: model.path) { [weak self] image in
                defer { group.leave() }
                guard let image = image else { return }
                
                newImages.append(model.with(uiImage: image))
            }
        }
        
        group.notify(queue: DispatchQueue.main) {
            completion(newImages)
        }
    }
}
