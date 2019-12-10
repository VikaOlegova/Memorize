//
//  FlickrAPI.swift
//  Memorize
//
//  Created by Вика on 09/12/2019.
//  Copyright © 2019 Vika Olegova. All rights reserved.
//

import Foundation

/// Класс, формирующий ссылку для запроса картинок к Flickr API
class FlickrAPI {
    
    private static let apiKey = "dab4052df3cc23ed39745a8cca163e0a"
    private static let baseUrl = "https://www.flickr.com/services/rest/"
    
    /// Формирует ссылку для запроса картинок к Flickr API
    ///
    /// - Parameter text: текст для поиска изображений
    /// - Returns: ссылка запроса
    static func searchPath(text: String) -> URL {
        guard var components = URLComponents(string: baseUrl) else {
            return URL(string: baseUrl)!
        }
        
        let params = [
            "method" : "flickr.photos.search",
            "api_key" : apiKey,
            "text" : text,
            "extras" : "url_m",
            "format" : "json",
            "nojsoncallback" : "1",
            "per_page" : String(15)
        ]
        
        components.queryItems = params.map{ URLQueryItem(name: $0.key, value: $0.value) }
        
        return components.url!
    }
}
