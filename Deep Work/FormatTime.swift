//
//  FormatTime.swift
//  Deep Work
//
//  Created by Austin Wood on 2016-10-13.
//  Copyright © 2016 Austin Wood. All rights reserved.
//

import Foundation

struct FormatTime {
    
    func formattedHoursMinutesSeconds(timeInterval: TimeInterval) -> String {
        let time = NSInteger(timeInterval)
        let seconds = time % 60
        let minutes = (time / 60) % 60
        let hours = (time / 3600)
        return NSString(format: "%0.1dh %0.1dm %0.1ds",hours,minutes,seconds) as String
    }
    
    func formattedHoursMinutes(timeInterval: TimeInterval) -> String {
        let time = NSInteger(timeInterval)
        //let seconds = time % 60
        let minutes = (time / 60) % 60
        let hours = (time / 3600)
        return NSString(format: "%0.1dh %0.1dm",hours,minutes) as String
    }
    
    func formattedTime(date: Date) -> String {
        let calendar = NSCalendar.current
        let hour = calendar.component(.hour, from: date)
        var hourStr = String(hour)
        if hour < 10 {
            hourStr = "0" + hourStr
        }
        let minute = calendar.component(.minute, from: date)
        var minuteStr = String(minute)
        if minute < 10 {
            minuteStr = "0" + minuteStr
        }
        return hourStr + ":" + minuteStr
    }
    
    func formattedDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        dateFormatter.timeStyle = .none
        return dateFormatter.string(from: date)
    }
    
}
