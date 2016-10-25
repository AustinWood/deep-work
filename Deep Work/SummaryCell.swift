//
//  SummaryCell.swift
//  Deep Work
//
//  Created by Austin Wood on 2016-10-25.
//  Copyright © 2016 Austin Wood. All rights reserved.
//

import UIKit

class SummaryCell: UICollectionViewCell {
    
    @IBOutlet weak var circleView: CircleView!
    @IBOutlet weak var timeLabel: UILabel!
    
    let titleLabelArray = ["Today", "Week", "October", "2016"]
    @IBOutlet weak var titleLabel: UILabel!
    
    
    
    internal func configureCell(indexPath: Int, projects: [Project]) {
        
        circleView.layer.cornerRadius = self.frame.size.width / 2
        circleView.clipsToBounds = true
        circleView.backgroundColor = CustomColor.blueGreen
        
        titleLabel.text = titleLabelArray[indexPath]
    }
    
}
