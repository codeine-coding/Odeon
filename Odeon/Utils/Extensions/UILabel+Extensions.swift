//
//  UILabel+Extensions.swift
//  Odeon
//
//  Created by Allen Whearry on 7/25/19.
//  Copyright © 2019 Allen Whearry. All rights reserved.
//

import UIKit

extension UILabel {
    func updateTextFont() {
        if ((self.text?.isEmpty)! || self.bounds.size.equalTo(CGSize.zero)) {
            return
        }
        
        let textViewSize = self.frame.size
        let fixedWidth = textViewSize.width
        let expectSize = self.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat(MAXFLOAT)))
        
        var expectFont = self.font
        if (expectSize.height > textViewSize.height) {
            while (self.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat(MAXFLOAT))).height > textViewSize.height) {
                expectFont = self.font!.withSize(self.font!.pointSize - 1)
                self.font = expectFont
            }
        }
        else {
            while (self.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat(MAXFLOAT))).height < textViewSize.height) {
                expectFont = self.font
                self.font = self.font!.withSize(self.font!.pointSize + 1)
            }
            self.font = expectFont
        }
        if self.font.pointSize > 48 {
            let currentPointSize = self.font.pointSize
            var expectedFont = self.font
            expectedFont = self.font!.withSize(self.font!.pointSize - currentPointSize + 48)
            self.font = expectedFont
        }
    }
}
