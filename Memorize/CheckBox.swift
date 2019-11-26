//
//  CheckBox.swift
//  Memorize
//
//  Created by Вика on 26/11/2019.
//  Copyright © 2019 Vika Olegova. All rights reserved.
//

import UIKit

class CheckBox: UIButton {
    let checkedImage = UIImage(named: "checked")
    let uncheckedImage = UIImage(named: "unchecked")
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        translatesAutoresizingMaskIntoConstraints = false
        
        setImage(uncheckedImage, for: .normal)
        setImage(checkedImage, for: .selected)
        addTarget(self, action:#selector(checkBoxClicked), for: .touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func checkBoxClicked() {
        isSelected = !isSelected
    }
}
