//
//  GoogleImageAPI.swift
//  Memorize
//
//  Created by Вика on 03/12/2019.
//  Copyright © 2019 Vika Olegova. All rights reserved.
//

import Foundation

/// Класс, формирующий ссылку для запроса картинок к Google API
class GoogleImageAPI {
    private static let baseURL = "https://www.googleapis.com/customsearch/v1"
    
    /// Формирует ссылку для запроса картинок к Google API
    ///
    /// - Parameter text: текст для поиска изображений
    /// - Returns: ссылка запроса
    static func searchPath(text: String) -> URL? {
        guard var components = URLComponents(string: baseURL) else {
            return nil
        }
        
        let params = [
            "key" : "AIzaSyC9qHhYm3l9vkroTGqAEOCutcQyJTSmlsQ",
            "cx" : "017129964574325989326:zz71k61obkn",
            "q" : text,
            "searchType" : "image",
        ]
        
        components.queryItems = params.map{ URLQueryItem(name: $0.key, value: $0.value) }
        
        return components.url
    }
}
