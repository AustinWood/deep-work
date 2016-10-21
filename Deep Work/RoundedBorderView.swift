//
//  RoundedBorderView.swift
//  Deep Work
//
//  Created by Austin Wood on 2016-10-21.
//  Copyright © 2016 Austin Wood. All rights reserved.
//

import UIKit

class RoundedBorderView: UIView {
    
    override func awakeFromNib() {
        self.backgroundColor = UIColor.black
        self.layer.cornerRadius = 10
        layer.borderWidth = 1
        layer.borderColor = UIColor.white.cgColor
    }
    
}