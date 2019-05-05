//
//  CategoryHeaderView.swift
//  TVQuoteApp
//
//  Created by Allen Whearry on 12/20/18.
//  Copyright © 2018 Codeine Technologies LLC. All rights reserved.
//

import UIKit

class CategoryHeaderView: UIView {
    
    var headerImage: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = UIImage(named: "default")
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    var headerTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.font = UIFont(name: Font.Animosa.Bold, size: 36)
        label.textAlignment = .center
        label.sizeToFit()
        label.numberOfLines = 0
        label.textColor = .white
        return label
    }()
    
    let overlayView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 0.4469941143)
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        clipsToBounds = true
        addSubview(headerImage)
        addSubview(overlayView)
        addSubview(headerTitle)
        displayConstraints()
    }
    
    func displayConstraints() {
        NSLayoutConstraint.activate([
            headerImage.topAnchor.constraint(equalTo: topAnchor, constant: -50),
            headerImage.bottomAnchor.constraint(equalTo: bottomAnchor),
            headerImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            headerImage.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            overlayView.topAnchor.constraint(equalTo: topAnchor),
            overlayView.bottomAnchor.constraint(equalTo: bottomAnchor),
            overlayView.leadingAnchor.constraint(equalTo: leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            headerTitle.topAnchor.constraint(equalTo: topAnchor),
            headerTitle.bottomAnchor.constraint(equalTo: bottomAnchor),
            headerTitle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            headerTitle.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
