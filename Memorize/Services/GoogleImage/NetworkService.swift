//
//  NetworkService.swift
//  Memorize
//
//  Created by Вика on 03/12/2019.
//  Copyright © 2019 Vika Olegova. All rights reserved.
//

import UIKit

class NetworkService {
    
    private let session: URLSession = {
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = 20
        sessionConfig.timeoutIntervalForResource = 60
        return URLSession(configuration: sessionConfig)
    }()
    
    func getData(at path: URL, completion: @escaping (Data?) -> ()) {
        let dataTask = session.dataTask(with: path) { data, _, _ in
            completion(data)
        }
        dataTask.resume()
    }
    
    func loadImage(at path: URL, completion: @escaping (UIImage?) -> ()) {
        getData(at: path) { data in
            guard let data = data else {
                completion(nil)
                return
            }
            completion(UIImage(data: data))
        }
    }
}
