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
        //print(self.frame.size.width)
        //layer.cornerRadius = self.bounds.size.width/2
        self.backgroundColor = CustomColor.ashGrey
        layer.borderWidth = 4
        layer.borderColor = UIColor.black.cgColor
        //layer.masksToBounds = true
        //self.clipsToBounds = true
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let center = CGPoint(x: bounds.size.width, y: bounds.size.height)
        return pow(center.x-point.x, 2) + pow(center.y - point.y, 2) < pow(bounds.size.width/2, 2)
    }
    
}
