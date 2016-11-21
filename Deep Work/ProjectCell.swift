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
        layoutCell()
        titleLabel.text = project.title
        updateTimeLabels(project: project, moc: moc)
    }
    
    func layoutCell() {
        //circleView.layer.cornerRadius = self.frame.size.width / 2
        
        for layer in circleView.layer.sublayers! {
            if layer.name == "staticBorder" {
                layer.removeFromSuperlayer()
            }
        }
        circleView.drawGrayBorder()
    }
    
    func updateTimeLabels(project: Project, moc: NSManagedObjectContext) {
        let defaults = UserDefaults.standard
        let savedDateRange = defaults.integer(forKey: "dateRange")
        let dateRange = MyDateRange(rawValue: savedDateRange)!
        let timeInterval = TimeLog.calculateTimeInterval(projects: [project], dateRange: dateRange, moc: moc)
        timeLabel.text = CustomDateFormatter.formattedHoursMinutes(timeInterval: timeInterval)
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
