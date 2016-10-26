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
        circleView.backgroundColor = CustomColor.blueDark
        
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
        
        let defaults = UserDefaults.standard
        let savedDateRange = defaults.integer(forKey: "dateRange")
        if savedDateRange == indexPath {
            switch indexPath {
            case 0:
                circleView.backgroundColor = CustomColor.blueLight
            case 1:
                circleView.backgroundColor = CustomColor.pinkPale
            case 2:
                circleView.backgroundColor = CustomColor.purple1
            case 3:
                circleView.backgroundColor = CustomColor.purple2
            default:
                circleView.backgroundColor = CustomColor.purple2
            }
            
        } else {
            circleView.backgroundColor = CustomColor.dark2
        }
        
    }
    
    
    func addCircleView() {
//        print("addCircleView()")
//        let circleDiameter = circleView.frame.width
//        
//        let animatedBorderView = AnimatedCircleView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: circleDiameter, height: circleDiameter)))
//        
//        self.addSubview(animatedBorderView)
//        animatedBorderView.animateCircle(fillPercent: 0.8)
    }
    
    
}
