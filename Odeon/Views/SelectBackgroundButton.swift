//
//  SelectBackgroundButton.swift
//  Odeon
//
//  Created by Allen Whearry on 5/16/19.
//  Copyright © 2019 Allen Whearry. All rights reserved.
//

import UIKit

class SelectBackgroundButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupView() {
        backgroundColor = .primary
        setTitleColor(.white, for: .normal)
        tintColor = .white
        titleLabel?.font = UIFont(name: Font.Animosa.Bold, size: 18)
        titleLabel?.numberOfLines = 0
        titleEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        layer.cornerRadius = 16
        layer.masksToBounds = true
    }
}
