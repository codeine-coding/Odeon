//
//  UnsplashImageCell.swift
//  TVQuoteApp
//
//  Created by Allen Whearry on 12/23/18.
//  Copyright © 2018 Codeine Technologies LLC. All rights reserved.
//

import UIKit

class UnsplashImageCell: BaseCollectionViewCell {
    let thumbnail: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = UIImage(named: "atlcarnival")
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    let userLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 11, weight: .semibold)
        label.text = "norest4awhearry"
        label.textColor = .white
        label.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 0.6024733744)
        label.textAlignment = .center
        return label
    }()
    
    override func setupView() {
        addSubview(thumbnail)
        addSubview(userLabel)
        
        super.setupView()
    }
    
    override func displayConstraints() {
        NSLayoutConstraint.activate([
            thumbnail.topAnchor.constraint(equalTo: topAnchor),
            thumbnail.bottomAnchor.constraint(equalTo: bottomAnchor),
            thumbnail.leadingAnchor.constraint(equalTo: leadingAnchor),
            thumbnail.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            userLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            userLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            userLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            userLabel.heightAnchor.constraint(equalToConstant: 30)
            ])
    }
}
