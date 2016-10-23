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
    
    var displayWeekTotals = false
    
    internal func configureCell(project: Project, moc: NSManagedObjectContext) {
        circleView.layer.cornerRadius = self.frame.size.width / 2
        circleView.clipsToBounds = true
        titleLabel.text = project.title
        
        displayWeekTotals = UserDefaults.standard.bool(forKey: "displayWeekTotals")
        if displayWeekTotals {
            let weekTime = TimeLog.weekTime(projects: [project], moc: moc)
            let weekFormatted = FormatTime.formattedHoursMinutes(timeInterval: weekTime)
            timeLabel.text = weekFormatted
        } else {
            let todayTime = TimeLog.todayTime(projects: [project], moc: moc)
            let todayFormatted = FormatTime.formattedHoursMinutes(timeInterval: todayTime)
            timeLabel.text = todayFormatted
        }
        
        let currentSessionLength = TimeLog.currentSessionLength(project: project, moc: moc)
        if currentSessionLength == 0 {
            circleView.backgroundColor = UIColor.black
            currentSessionLabel.isHidden = true
        } else {
            circleView.backgroundColor = CustomColor.red
            let currentSessionFormatted = FormatTime.formattedHoursMinutesSeconds(timeInterval: currentSessionLength)
            currentSessionLabel.text = currentSessionFormatted
            currentSessionLabel.isHidden = false
        }
    }
}
