//
//  AlignmentButton.swift
//  TVQuoteApp
//
//  Created by Allen Whearry on 2/6/19.
//  Copyright © 2019 Codeine Technologies LLC. All rights reserved.
//

import UIKit

class AlignmentButton: UIButton {
    var textAlignment: NSTextAlignment
    
    override init(frame: CGRect) {
        textAlignment = .center
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
