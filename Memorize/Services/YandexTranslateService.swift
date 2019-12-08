//
//  YandexTranslateService.swift
//  Memorize
//
//  Created by Вика on 30/11/2019.
//  Copyright © 2019 Vika Olegova. All rights reserved.
//

import Foundation

class YandexTranslateService {
    
    private struct ResponseData: Decodable {
        let code: Int
        let lang: String
        let text: [String]
    }
    
    private let session = URLSession.shared
    
    typealias translateCompletion = ([String])->()
    
    private let apiKey = "trnsl.1.1.20191130T020917Z.e3a891e4e5659e27.eda8c5361cad7dabffa21764b560de8fc38d89b5"
    private let baseURL = "https://translate.yandex.net/api/v1.5/tr.json/translate"
    
    func translate(text: String, from: Language, to: Language, completion: @escaping translateCompletion) {
        
        var components = URLComponents(string: baseURL)!
        components.queryItems = [
            "key" : apiKey,
            "text" : text,
            "lang" : to.rawValue.lowercased()
            ]
            .map { URLQueryItem(name: $0.key, value: $0.value) }
        
        guard let url = components.url else {
            DispatchQueue.main.async {
                completion([])
            }
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let task = session.dataTask(with: request, completionHandler: { data, _, _ in
            guard
                let data = data,
                let parsed = try? JSONDecoder().decode(ResponseData.self, from: data)
                else {
                    DispatchQueue.main.async {
                        completion([])
                    }
                    return
            }
            DispatchQueue.main.async {
                completion(parsed.text)
            }
        })
        task.resume()
    }
}
