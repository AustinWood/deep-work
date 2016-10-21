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
    
//    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
//        let center = CGPoint(x: bounds.size.width / 2, y: bounds.size.height / 2)
//        return !(pow(center.x-point.x, 2) + pow(center.y - point.y, 2) < pow(bounds.size.width/2, 2))
//    }
    
}
