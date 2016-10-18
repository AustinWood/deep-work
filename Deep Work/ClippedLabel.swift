//
//  ClippedLabel.swift
//  Deep Work
//
//  Created by Austin Wood on 2016-10-14.
//  Copyright © 2016 Austin Wood. All rights reserved.
//

import UIKit

class ClippedButton: UIButton {
    
    override func awakeFromNib() {
        layer.cornerRadius = 75 //self.frame.size.width/2
        self.clipsToBounds = true
        layer.masksToBounds = true
    }
    
}
