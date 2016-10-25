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
        layer.borderWidth = 1
        layer.borderColor = CustomColor.gray.cgColor
    }
    
}
