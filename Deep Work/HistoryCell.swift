//
//  HistoryCell.swift
//  Deep Work
//
//  Created by Austin Wood on 2016-10-20.
//  Copyright © 2016 Austin Wood. All rights reserved.
//

import UIKit
import CoreData

class HistoryCell: UITableViewCell {
    
    var entryComplete = true
    var thisEntry: TimeLog?
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var intervalLabel: UILabel!
    @IBOutlet weak var noteLabel: UILabel!
    
    internal func configureCell(entry: TimeLog, moc: NSManagedObjectContext) {
        thisEntry = entry
        entryComplete = true
        timer.invalidate()
        
        // Time Label
        let startTime = entry.startTime
        let starTimeStr = FormatTime().formattedTime(date: startTime!)
        var stopTime = Date()
        var stopTimeStr = ""
        // This entry is complete
        if entry.stopTime != nil {
            stopTime = entry.stopTime!
            stopTimeStr = "  →  " +  FormatTime().formattedTime(date: stopTime)
        }
        
        // Timer is still running
        else {
            entryComplete = false
        }
        
        timeLabel.text = starTimeStr + stopTimeStr
        
        // Interval Label ///  REFACTOR _ --=- =- - - --0923- COMBINE WITH ABOVE
        let entryLength = stopTime.timeIntervalSince(startTime!)
        if entryComplete {
            let entryLengthStr = FormatTime().formattedHoursMinutes(timeInterval: entryLength)
            intervalLabel.text = entryLengthStr
        } else {
            updateLabelEachSecond()
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.updateLabelEachSecond), userInfo: nil, repeats: true);
        }
        
        // Note Label
        if entry.note == nil || entry.note == "" {
            noteLabel.isHidden = true
        } else {
            noteLabel.isHidden = false
            noteLabel.text = entry.note
        }
    }
    
    var timer = Timer()
    
    func updateLabelEachSecond() {
        let entryLength = Date().timeIntervalSince((thisEntry?.startTime)!)
        let entryLengthStr = FormatTime().formattedHoursMinutesSeconds(timeInterval: entryLength)
        intervalLabel.text = entryLengthStr
    }

}
