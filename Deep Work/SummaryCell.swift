//
//  SummaryCell.swift
//  Deep Work
//
//  Created by Austin Wood on 2016-10-25.
//  Copyright © 2016 Austin Wood. All rights reserved.
//

import UIKit
import CoreData

class SummaryCell: UICollectionViewCell {
    
    @IBOutlet weak var circleView: CircleView!
    @IBOutlet weak var timeLabel: UILabel!
    
    let titleLabelArray = ["Today", "Week", "October", "2016"]
    @IBOutlet weak var titleLabel: UILabel!
    
    
    
    internal func configureCell(indexPath: Int, projects: [Project], moc: NSManagedObjectContext) {
        
        circleView.layer.cornerRadius = self.frame.size.width / 2
        circleView.clipsToBounds = true
        circleView.backgroundColor = CustomColor.blueGreen
        
        titleLabel.text = titleLabelArray[indexPath]
        
        switch indexPath {
        case 0:
            let todayTime = TimeLog.todayTime(projects: projects, moc: moc)
            timeLabel.text = FormatTime.formattedHoursMinutes(timeInterval: todayTime)
        case 1:
            let weekTime = TimeLog.weekTime(projects: projects, moc: moc)
            timeLabel.text = FormatTime.formattedHoursMinutes(timeInterval: weekTime)
        case 2:
            let monthTime = TimeLog.monthTime(projects: projects, moc: moc)
            timeLabel.text = FormatTime.formattedHoursMinutes(timeInterval: monthTime)
        case 3:
            let yearTime = TimeLog.yearTime(projects: projects, moc: moc)
            timeLabel.text = FormatTime.formattedHoursMinutes(timeInterval: yearTime)
        default:
            timeLabel.text = ""
        }
    }
    
}
