//
//  NetworkService.swift
//  Memorize
//
//  Created by Вика on 03/12/2019.
//  Copyright © 2019 Vika Olegova. All rights reserved.
//

import UIKit

/// Протокол для работы с сетью
protocol NetworkServiceProtocol {
    /// Получает по запросу данные в формате json, содержащие ссылки на изображения
    ///
    /// - Parameters:
    ///   - path: ссылка запроса
    ///   - completion: сообщает о конце выполнения функции
    /// - Returns: опциональные полученные данные
    func getData(at path: URL, completion: @escaping (Data?) -> ())
    
    /// Зыгружает по ссылке изображение
    ///
    /// - Parameters:
    ///   - path: ссылка на изображение
    ///   - completion: сообщает о конце выполнения функции
    /// - Returns: опциональное загруженное изображение
    func loadImage(at path: URL, completion: @escaping (UIImage?) -> ())
}

/// Класс для работы с сетью
class NetworkService: NetworkServiceProtocol {
    
    private let session: URLSession = {
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = 20
        sessionConfig.timeoutIntervalForResource = 60
        return URLSession(configuration: sessionConfig)
    }()
    
    func getData(at path: URL, completion: @escaping (Data?) -> ()) {
        let dataTask = session.dataTask(with: path) { data, response, error in
            if let err = error {
                print(err)
            }
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
