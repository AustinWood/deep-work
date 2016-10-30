//
//  ProjectCell.swift
//  Deep Work
//
//  Created by Austin Wood on 2016-10-11.
//  Copyright © 2016 Austin Wood. All rights reserved.
//

import UIKit
import CoreData

class ProjectCell: UICollectionViewCell {
    
    @IBOutlet weak var circleView: CircleView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var currentSessionLabel: UILabel!
    
    internal func configureCell(project: Project, moc: NSManagedObjectContext) {
        
        titleLabel.text = project.title
        circleView.layer.cornerRadius = self.frame.size.width / 2
        
        for layer in circleView.layer.sublayers! {
            if layer.name == "staticBorder" {
                layer.removeFromSuperlayer()
            }
        }
        circleView.drawGrayBorder()
        
        updateTimeLabels(project: project, moc: moc)
    }
    
    func updateTimeLabels(project: Project, moc: NSManagedObjectContext) {
        let defaults = UserDefaults.standard
        let savedDateRange = defaults.integer(forKey: "dateRange")
        let dateRange = MyDateRange(rawValue: savedDateRange)!
        
        
        switch dateRange {
        case .today:
            let todayTime = TimeLog.todayTime(projects: [project], moc: moc)
            timeLabel.text = CustomDateFormatter.formattedHoursMinutes(timeInterval: todayTime)
        case .week:
            let weekTime = TimeLog.weekTime(projects: [project], moc: moc)
            timeLabel.text = CustomDateFormatter.formattedHoursMinutes(timeInterval: weekTime)
        case .month:
            let monthTime = TimeLog.monthTime(projects: [project], moc: moc)
            timeLabel.text = CustomDateFormatter.formattedHoursMinutes(timeInterval: monthTime)
        case .year:
            let yearTime = TimeLog.yearTime(projects: [project], moc: moc)
            timeLabel.text = CustomDateFormatter.formattedHoursMinutes(timeInterval: yearTime)
        case .allTime:
            timeLabel.text = ""
        }
        
        let currentSessionLength = TimeLog.currentSessionLength(project: project, moc: moc)
        if currentSessionLength == 0 {
            circleView.backgroundColor = CustomColor.dark1
            timeLabel.textColor = UIColor.white
            currentSessionLabel.isHidden = true
        } else {
            circleView.backgroundColor = CustomColor.blueDark
            timeLabel.textColor = UIColor.black
            let currentSessionFormatted = CustomDateFormatter.formattedHoursMinutesSeconds(timeInterval: currentSessionLength)
            currentSessionLabel.text = currentSessionFormatted
            currentSessionLabel.isHidden = false
        }
    }
    
}
