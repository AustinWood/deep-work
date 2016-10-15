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
    
}
