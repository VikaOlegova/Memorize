//
//  ImageCollectionViewCell.swift
//  Memorize
//
//  Created by Вика on 04/12/2019.
//  Copyright © 2019 Vika Olegova. All rights reserved.
//

import UIKit

/// Ячейка коллекшн вью с экрана создания\редактирования слова
class ImageCollectionViewCell: UICollectionViewCell {
    private let imageView: UIImageView
    private let spinner: UIActivityIndicatorView
    
    override init(frame: CGRect) {
        imageView = UIImageView(frame: frame)
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleAspectFit
        
        spinner = UIActivityIndicatorView(style: .gray)
        spinner.hidesWhenStopped = true
        
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if imageView.superview == nil {
            contentView.addSubview(imageView)
            contentView.addSubview(spinner)
        }
        
        spinner.frame = bounds;
        imageView.frame = bounds;
    }
    
    /// Отображает либо картинку, либо спиннер
    ///
    /// - Parameter data: объект даты ячейки
    func displayData(data: ImageCollectionViewCellData)
    {
        imageView.image = data.isLoaded ? data.image : nil
        if data.isLoaded {
            spinner.stopAnimating()
        } else {
            spinner.startAnimating()
        }
    }
}
