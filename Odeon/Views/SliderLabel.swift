//
//  SliderLabel.swift
//  TVQuoteApp
//
//  Created by Allen Whearry on 3/18/19.
//  Copyright © 2019 Codeine Technologies LLC. All rights reserved.
//

import UIKit

class SliderLabel: UILabel {

    init(_ labelText: String?, frame: CGRect) {
        super.init(frame: frame)
        text = labelText
        textColor = .lightGray
        font = UIFont(name: Font.Animosa.Regular, size: 18)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
