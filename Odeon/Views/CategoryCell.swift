//
//  CategoryCell.swift
//  TVQuoteApp
//
//  Created by Allen Whearry on 12/20/18.
//  Copyright © 2018 Codeine Technologies LLC. All rights reserved.
//

import UIKit

class CategoryCell: BaseCollectionViewCell {
    
    var category: Category? {
        didSet {
            guard let categoryName = category?.name  else { return }
            categoryNameLabel.text = categoryName
            guard let quoteCount = category?.quotes?.count else { return }
            categoryQuoteCount.text = "(\(quoteCount))"
            guard let imageURl = category?.image_url else { return }
            categoryBackgroundImage.downloadImage(from: imageURl, completion: nil)
            
        }
    }
    
    let categoryBackgroundImage: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.image = UIImage(named: "default")
        iv.clipsToBounds = true
        return iv
    }()
    
    let categoryNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.font = UIFont(name: Font.Animosa.ExtraBold, size: 26)
        label.textAlignment = .center
        label.sizeToFit()
        label.numberOfLines = 0
        label.textColor = .white
        label.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 0.3495305493)
        return label
    }()
    
    let categoryQuoteCount: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "0"
        label.font = UIFont(name: Font.Animosa.Bold, size: 22)
        label.textAlignment = .center
        label.sizeToFit()
        label.numberOfLines = 0
        label.textColor = .white
        return label
    }()
    
    override func setupView() {
        layer.cornerRadius = 20
        clipsToBounds = true
        addSubview(categoryBackgroundImage)
        addSubview(categoryNameLabel)
        addSubview(categoryQuoteCount)
        super.setupView()
    }
    
    override func displayConstraints() {
        NSLayoutConstraint.activate([
            categoryBackgroundImage.topAnchor.constraint(equalTo: topAnchor),
            categoryBackgroundImage.bottomAnchor.constraint(equalTo: bottomAnchor),
            categoryBackgroundImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            categoryBackgroundImage.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            categoryNameLabel.topAnchor.constraint(equalTo: topAnchor),
            categoryNameLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            categoryNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            categoryNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            categoryQuoteCount.centerYAnchor.constraint(equalTo: categoryNameLabel.centerYAnchor, constant: 32),
            categoryQuoteCount.centerXAnchor.constraint(equalTo: categoryNameLabel.centerXAnchor),
        ])
        
    }
    
}
