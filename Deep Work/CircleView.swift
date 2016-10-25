//
//  CircleView.swift
//  Deep Work
//
//  Created by Austin Wood on 2016-10-11.
//  Copyright © 2016 Austin Wood. All rights reserved.
//

import UIKit

class CircleView: UIView {
    
    override func awakeFromNib() {
        self.backgroundColor = UIColor.black
        layer.borderWidth = 2
        layer.borderColor = UIColor.white.cgColor
    }
    
}
