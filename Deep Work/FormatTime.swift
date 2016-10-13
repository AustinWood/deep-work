//
//  FormatTime.swift
//  Deep Work
//
//  Created by Austin Wood on 2016-10-13.
//  Copyright © 2016 Austin Wood. All rights reserved.
//

import Foundation

struct FormatTime {
    
    var timeInterval: TimeInterval
    
    func timeIntervalToString() -> String {
        let time = NSInteger(timeInterval)
        let seconds = time % 60
        let minutes = (time / 60) % 60
        let hours = (time / 3600)
        return NSString(format: "%0.1dh %0.2dm %0.2ds",hours,minutes,seconds) as String
    }
    
}
