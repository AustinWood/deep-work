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
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    internal func configureCell(project: Project, moc: NSManagedObjectContext) {
        
        titleLabel.text = project.title
        
        let timeLog = TimeLog(context: moc)
        let totalTime = timeLog.totalTime(project: project, moc: moc)
        let displayInterval = FormatTime().timeIntervalToString(timeInterval: totalTime)
        timeLabel.text = displayInterval
    }
    
}
