//
//  CheckBox.swift
//  Memorize
//
//  Created by Вика on 26/11/2019.
//  Copyright © 2019 Vika Olegova. All rights reserved.
//

import UIKit

class CheckBox: UIButton {
    var checkedImage = UIImage()
    var uncheckedImage = UIImage()
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        translatesAutoresizingMaskIntoConstraints = false
        
        checkedImage = resize(image: UIImage(named: "checked")!)
        uncheckedImage = resize(image: UIImage(named: "unchecked")!)
        setImage(uncheckedImage, for: .normal)
        setImage(checkedImage, for: .selected)
        addTarget(self, action:#selector(checkBoxClicked), for: .touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func resize(image: UIImage) -> UIImage {
        
        let rect = CGRect(x: 0, y: 0, width: 24, height: 24)
        
        UIGraphicsBeginImageContext(CGSize(width: 24, height: 24))
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    @objc func checkBoxClicked() {
        isSelected = !isSelected
    }
}
