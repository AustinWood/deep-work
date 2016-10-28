//
//  FormatTime.swift
//  Deep Work
//
//  Created by Austin Wood on 2016-10-13.
//  Copyright © 2016 Austin Wood. All rights reserved.
//

import Foundation

struct FormatTime {
    
    internal static func formattedHoursDecimal(timeInterval: TimeInterval) -> String {
        let hours = Double(timeInterval) / 3600.0 as NSNumber
        let numberFormatter = NumberFormatter()
        numberFormatter.minimumIntegerDigits = 1
        if Double(hours) < 100.0 {
            numberFormatter.maximumFractionDigits = 1
            numberFormatter.minimumFractionDigits = 1
        } else {
            numberFormatter.maximumFractionDigits = 0
        }
        numberFormatter.decimalSeparator = "."
        if let stringFromNumber = numberFormatter.string(from: hours) {
            return(stringFromNumber + "h")
        } else {
            return "Error"
        }
    }
    
    internal static func formattedHoursMinutesSeconds(timeInterval: TimeInterval) -> String {
        let time = NSInteger(timeInterval)
        let seconds = time % 60
        let minutes = (time / 60) % 60
        let hours = (time / 3600)
        return NSString(format: "%0.1dh %0.1dm %0.1ds",hours,minutes,seconds) as String
    }
    
    internal static func formattedHoursMinutes(timeInterval: TimeInterval) -> String {
        let time = NSInteger(timeInterval)
        //let seconds = time % 60
        let minutes = (time / 60) % 60
        let hours = (time / 3600)
        return NSString(format: "%0.1dh %0.1dm",hours,minutes) as String
    }
    
    internal static func formattedTime(date: Date) -> String {
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
    
    internal static func formattedDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        dateFormatter.timeStyle = .none
        return dateFormatter.string(from: date)
    }
    
    internal static func dateISO(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: date)
    }
    
    internal static func dateISOtoFull(isoStr: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: isoStr)
        let fullDateStr = FormatTime.formattedDate(date: date!)
        return fullDateStr
    }
    
}
