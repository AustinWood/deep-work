//
//  SummaryCell.swift
//  Deep Work
//
//  Created by Austin Wood on 2016-10-25.
//  Copyright © 2016 Austin Wood. All rights reserved.
//

import UIKit
import CoreData

class SummaryCell: UICollectionViewCell {
    
    @IBOutlet weak var circleView: CircleView!
    @IBOutlet weak var timeLabel: UILabel!
    
    let titleLabelArray = ["Today", "Week", "October", "2016"]
    @IBOutlet weak var titleLabel: UILabel!
    
    func updateTimeLabel(indexPath: Int, projects: [Project], moc: NSManagedObjectContext) {
        
        let dateRange = MyDateRange(rawValue: indexPath)!
        
        switch dateRange {
        case .today:
            let todayTime = TimeLog.todayTime(projects: projects, moc: moc)
            timeLabel.text = FormatTime.formattedHoursMinutes(timeInterval: todayTime)
        case .week:
            let weekTime = TimeLog.weekTime(projects: projects, moc: moc)
            timeLabel.text = FormatTime.formattedHoursMinutes(timeInterval: weekTime)
        case .month:
            let monthTime = TimeLog.monthTime(projects: projects, moc: moc)
            timeLabel.text = FormatTime.formattedHoursMinutes(timeInterval: monthTime)
        case .year:
            let yearTime = TimeLog.yearTime(projects: projects, moc: moc)
            timeLabel.text = FormatTime.formattedHoursMinutes(timeInterval: yearTime)
        case .allTime:
            timeLabel.text = ""
        }
    }
    
    func updateBackgroundColor(indexPath: Int) {
        let defaults = UserDefaults.standard
        let savedDateRange = defaults.integer(forKey: "dateRange")
        if savedDateRange == indexPath {
            circleView.setBackgroundColor(color: CustomColor.blueLight)
//            switch indexPath {
//            case 0:
//                circleView.setBackgroundColor(color: CustomColor.blueLight)
//            case 1:
//                circleView.setBackgroundColor(color: CustomColor.pinkPale)
//            case 2:
//                circleView.setBackgroundColor(color: CustomColor.purple1)
//            case 3:
//                circleView.setBackgroundColor(color: CustomColor.purple2)
//            default:
//                circleView.setBackgroundColor(color: CustomColor.purple2)
//            }
        } else {
            circleView.setBackgroundColor(color: CustomColor.dark2)
        }
    }
    
    internal func configureCell(indexPath: Int, projects: [Project], moc: NSManagedObjectContext) {
        
        titleLabel.text = titleLabelArray[indexPath]
        updateTimeLabel(indexPath: indexPath, projects: projects, moc: moc)
        updateBackgroundColor(indexPath: indexPath)
    }
    
    func addBorder(indexPath: Int) {
        
        let dateRange = MyDateRange(rawValue: indexPath)!
        
        var fillPercent: CGFloat = 0.0
        
        switch dateRange {
        case .today:
            let calendar = Calendar.current
            let midnight = calendar.startOfDay(for: Date())
            let secondsPassed = Date().timeIntervalSince(midnight)
            let doubleVal: CGFloat = CGFloat(secondsPassed)
            let secondsInDay: CGFloat = 60.0 * 60.0 * 24.0
            let percentPassed = doubleVal / secondsInDay
            fillPercent = percentPassed
        case .week:
            let startOfThisWeek = Date().startOfWeek
            let calendar = Calendar.current
            let midnight = calendar.startOfDay(for: startOfThisWeek)
            let secondsPassed = Date().timeIntervalSince(midnight)
            let doubleVal: CGFloat = CGFloat(secondsPassed)
            let secondsInWeek: CGFloat = 60 * 60 * 24 * 7
            let percentPassed = doubleVal / secondsInWeek
            fillPercent = percentPassed
            
        case .month:
            let calendar = Calendar.current
            let components = calendar.dateComponents([.year, .month], from: Date())
            let startOfMonth = calendar.date(from: components)
            let midnight = calendar.startOfDay(for: startOfMonth!)
            let secondsPassed = Date().timeIntervalSince(midnight)
            let doubleVal: CGFloat = CGFloat(secondsPassed)
            
            
            var comps2 = DateComponents()
            comps2.month = 1
            let endOfMonth = calendar.date(byAdding: comps2, to: midnight)
            
            let secondsInMonth: CGFloat = CGFloat(endOfMonth!.timeIntervalSince(midnight))
            
            
            let percentPassed = doubleVal / secondsInMonth
            fillPercent = percentPassed
        case .year:
            
            
            let calendar = Calendar.current
            let components = calendar.dateComponents([.year], from: Date())
            let startOfYear = calendar.date(from: components)
            let midnight = calendar.startOfDay(for: startOfYear!)
            let secondsPassed = Date().timeIntervalSince(midnight)
            let doubleVal: CGFloat = CGFloat(secondsPassed)
            
            
            var comps2 = DateComponents()
            comps2.year = 1
            let endOfYear = calendar.date(byAdding: comps2, to: midnight)
            
            let secondsInMonth: CGFloat = CGFloat(endOfYear!.timeIntervalSince(midnight))
            
            
            let percentPassed = doubleVal / secondsInMonth
            fillPercent = percentPassed
            
            
        case .allTime:
            break
        }
        
        circleView.drawBorder(fillPercent: fillPercent)
        
    }
    
    
}
