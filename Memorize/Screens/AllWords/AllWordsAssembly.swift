//
//  AllWordsAssembly.swift
//  Memorize
//
//  Created by Вика on 27/11/2019.
//  Copyright © 2019 Vika Olegova. All rights reserved.
//

import UIKit

class AllWordsAssembly {
    func create() -> UIViewController {
        let coreData = CoreDataService()
        let presenter = AllWordsPresenter(coreData: coreData)
        let viewController = AllWordsViewController(presenter: presenter)
        
        presenter.view = viewController
        
        return viewController
    }
}
