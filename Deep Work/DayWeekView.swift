//
//  DayWeekButton.swift
//  Deep Work
//
//  Created by Austin Wood on 2016-10-18.
//  Copyright © 2016 Austin Wood. All rights reserved.
//

import UIKit

class DayWeekView: UIView {
    
    override func awakeFromNib() {
        //print(self.frame.size.width)
        layer.cornerRadius = 10
        self.backgroundColor = UIColor.black
        layer.borderWidth = 2
        layer.borderColor = UIColor.white.cgColor
        //layer.masksToBounds = true
        //self.clipsToBounds = true
    }
    
}
