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

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var intervalLabel: UILabel!
    @IBOutlet weak var noteLabel: UILabel!
    
    internal func configureCell(entry: TimeLog, moc: NSManagedObjectContext) {
        
        // Time Label
        let startTime = entry.startTime
        var stopTime = Date()
        if entry.stopTime != nil {
            stopTime = entry.stopTime!
        }
        let starTimeStr = FormatTime().formattedTime(date: startTime!)
        let stopTimeStr = FormatTime().formattedTime(date: stopTime)
        timeLabel.text = starTimeStr + "  →  " + stopTimeStr
        
        // Interval Label
        let entryLength = stopTime.timeIntervalSince(startTime!)
        let entryLengthStr = FormatTime().formattedHoursMinutes(timeInterval: entryLength)
        intervalLabel.text = entryLengthStr
        
        // Note Label
        noteLabel.text = entry.note
    }

}
