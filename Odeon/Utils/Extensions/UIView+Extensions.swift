//
//  UIView+Extensions.swift
//  Odeon
//
//  Created by Allen Whearry on 7/25/19.
//  Copyright © 2019 Allen Whearry. All rights reserved.
//

import UIKit

extension UIView {
    func addEqualConstraints(toView: UIView, constant: CGFloat = 0) {
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: toView.topAnchor, constant: constant),
            self.bottomAnchor.constraint(equalTo: toView.bottomAnchor, constant: constant),
            self.leadingAnchor.constraint(equalTo: toView.leadingAnchor, constant: constant),
            self.trailingAnchor.constraint(equalTo: toView.trailingAnchor, constant: constant),
            ])
    }
}
