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
        //circleView.layer.cornerRadius = self.frame.size.width / 2
        circleView.clipsToBounds = true
        titleLabel.text = project.title
        
        let timeLog = TimeLog(context: moc)
        //let (totalTime, inProgress) = timeLog.totalTime(project: project, moc: moc)
        let totalTime = timeLog.todayTime(projects: [project], moc: moc)
        
        let displayInterval = FormatTime().formattedHoursMinutes(timeInterval: totalTime)
        timeLabel.text = displayInterval
        
        let currentSessionLength = timeLog.currentSessionLength(project: project, moc: moc)
        if currentSessionLength == 0 {
            circleView.backgroundColor = UIColor.black
            currentSessionLabel.isHidden = true
        } else {
            circleView.backgroundColor = CustomColor.red
            let currentSessionFormatted = FormatTime().formattedHoursMinutesSeconds(timeInterval: currentSessionLength)
            currentSessionLabel.text = currentSessionFormatted
            currentSessionLabel.isHidden = false
            print("Current session: \(currentSessionLength)")
        }
        
    }
    
}
