//
//  GoogleImage.swift
//  Memorize
//
//  Created by Вика on 03/12/2019.
//  Copyright © 2019 Vika Olegova. All rights reserved.
//

import UIKit

struct GoogleImage {
    let path: URL
    let uiImage: UIImage?
    
    func with(uiImage: UIImage) -> GoogleImage {
        return GoogleImage(path: path,
                           uiImage: uiImage)
    }
}
