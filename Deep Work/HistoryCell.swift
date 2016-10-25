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
    
    var thisEntry: TimeLog?
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var intervalLabel: UILabel!
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var roundedBorderView: RoundedBorderView!
    
    internal func configureCell(entry: TimeLog, moc: NSManagedObjectContext) {
        
        thisEntry = entry
        timer.invalidate()
        
        let startTime = entry.startTime
        let starTimeStr = FormatTime.formattedTime(date: startTime!)
        var stopTime = Date()
        var stopTimeStr = ""
        
        // This entry is complete, set intervalLabel text
        if entry.stopTime != nil {
            configureColors(color: UIColor.white)
            stopTime = entry.stopTime!
            stopTimeStr = "  →  " +  FormatTime.formattedTime(date: stopTime)
            let entryLength = stopTime.timeIntervalSince(startTime!)
            let entryLengthStr = FormatTime.formattedHoursMinutes(timeInterval: entryLength)
            intervalLabel.text = entryLengthStr
        }
        
        // Timer is still running, update intervalLabel text each second
        else {
            configureColors(color: CustomColor.pinkHot)
            updateLabelEachSecond()
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.updateLabelEachSecond), userInfo: nil, repeats: true);
        }
        
        // Set timeLabel text
        timeLabel.text = starTimeStr + stopTimeStr
        
        // Configure noteLabel
        if entry.note == nil || entry.note == "" {
            noteLabel.isHidden = true
        } else {
            noteLabel.isHidden = false
            noteLabel.text = entry.note
        }
    }
    
    func configureColors(color: UIColor) {
        roundedBorderView.setBorderColor(color: color)
        timeLabel.textColor = color
        intervalLabel.textColor = color
    }
    
    var timer = Timer()
    
    func updateLabelEachSecond() {
        if thisEntry?.stopTime == nil {
            let entryLength = Date().timeIntervalSince((thisEntry?.startTime)!)
            let entryLengthStr = FormatTime.formattedHoursMinutesSeconds(timeInterval: entryLength)
            intervalLabel.text = entryLengthStr
        } else {
            timer.invalidate()
        }
    }

}
