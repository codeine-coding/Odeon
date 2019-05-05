//
//  SliderStackView.swift
//  TVQuoteApp
//
//  Created by Allen Whearry on 3/18/19.
//  Copyright © 2019 Codeine Technologies LLC. All rights reserved.
//

import UIKit

class SliderStackView: UIStackView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        axis = .vertical
        alignment = .fill
        distribution = .fillEqually
        spacing = 2
    }
}
