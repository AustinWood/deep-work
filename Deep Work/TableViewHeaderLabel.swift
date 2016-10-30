//
//  TableViewHeaderLabel.swift
//  Deep Work
//
//  Created by Austin Wood on 2016-10-23.
//  Copyright © 2016 Austin Wood. All rights reserved.
//

import UIKit

class TableViewHeaderLabel: UILabel {
    
    var topInset:       CGFloat = 0
    var rightInset:     CGFloat = 12
    var bottomInset:    CGFloat = 0
    var leftInset:      CGFloat = 0
    
    override func drawText(in rect: CGRect) {
        
        let insets: UIEdgeInsets = UIEdgeInsets(top: self.topInset, left: self.leftInset, bottom: self.bottomInset, right: self.rightInset)
        self.setNeedsLayout()
        
        self.textColor = UIColor.white
        self.textAlignment = NSTextAlignment.right
        
        return super.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
    }
    
//    func addBlur() {
//        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
//        let blurEffectView = UIVisualEffectView(effect: blurEffect)
//        blurEffectView.frame = self.bounds
//        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        self.addSubview(blurEffectView)
//        self.sendSubview(toBack: blurEffectView)
//    }
    
}
