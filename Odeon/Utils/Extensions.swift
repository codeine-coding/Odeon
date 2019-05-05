//
//  Extensions.swift
//  TVQuoteApp
//
//  Created by Allen Whearry on 12/17/18.
//  Copyright © 2018 Codeine Technologies LLC. All rights reserved.
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

extension UITextView {
    func numberOfLines() -> Int {
        let layoutManager = self.layoutManager
        let numberOfGlyphs = layoutManager.numberOfGlyphs
        var lineRange: NSRange = NSMakeRange(0, 1)
        var index = 0
        var numberOfLines = 0
        
        while index < numberOfGlyphs {
            layoutManager.lineFragmentRect(
                forGlyphAt: index, effectiveRange: &lineRange
            )
            index = NSMaxRange(lineRange)
            numberOfLines += 1
        }
        return numberOfLines
    }
    
}

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

extension UIColor {
    static let gold = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
//    static let gold = UIColor(red: 247 / 255, green: 199 / 255, blue: 88 / 255, alpha: 1.0)
    static let offBlack = #colorLiteral(red: 0.07803841595, green: 0.07803841595, blue: 0.07803841595, alpha: 1)
    static let primary = #colorLiteral(red: 0, green: 0.6784313725, blue: 0.7333333333, alpha: 1)
}
