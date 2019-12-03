//
//  TitleTextFieldView.swift
//  Memorize
//
//  Created by Вика on 26/11/2019.
//  Copyright © 2019 Vika Olegova. All rights reserved.
//

import UIKit

class TitleTextFieldView: UIView {
    let label = UILabel()
    let textField = UITextField()
    let spinner = UIActivityIndicatorView(style: .gray)
    
    private let splitter = UIView()
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        splitter.backgroundColor = UIColor(white: 210/255.0, alpha: 1)
        
        translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        textField.translatesAutoresizingMaskIntoConstraints = false
        splitter.translatesAutoresizingMaskIntoConstraints = false
        spinner.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(label)
        addSubview(textField)
        addSubview(splitter)
        addSubview(spinner)
        
        label.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        label.topAnchor.constraint(equalTo: topAnchor).isActive = true
        label.heightAnchor.constraint(equalToConstant: 22).isActive = true
        
        textField.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        textField.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        textField.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 5).isActive = true
        textField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        spinner.leftAnchor.constraint(equalTo: label.rightAnchor, constant: 7).isActive = true
        spinner.topAnchor.constraint(equalTo: topAnchor).isActive = true
        spinner.heightAnchor.constraint(equalToConstant: 22).isActive = true
        spinner.widthAnchor.constraint(equalToConstant: 22).isActive = true
        
        splitter.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        splitter.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        splitter.topAnchor.constraint(equalTo: textField.bottomAnchor).isActive = true
        splitter.heightAnchor.constraint(equalToConstant: 1).isActive = true
        splitter.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true   
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
