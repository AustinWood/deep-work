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
    @IBOutlet weak var titleLabel: UILabel!
    
    let titleLabelArray = ["Today", "Week", "April", "2017", "All"]
    
    internal func configureCell(indexPath: Int, projects: [Project], moc: NSManagedObjectContext) {
        titleLabel.text = titleLabelArray[indexPath]
        updateCell(indexPath: indexPath, projects: projects, moc: moc)
    }
    
    func updateCell(indexPath: Int, projects: [Project], moc: NSManagedObjectContext) {
        updateTimeLabel(indexPath: indexPath, projects: projects, moc: moc)
        updateBackgroundColor(indexPath: indexPath)
    }
    
    func updateTimeLabel(indexPath: Int, projects: [Project], moc: NSManagedObjectContext) {
        let dateRange = MyDateRange(rawValue: indexPath)!
        let timeInterval = TimeLog.calculateTimeInterval(projects: projects, dateRange: dateRange, moc: moc)
        timeLabel.text = CustomDateFormatter.formattedHoursDecimal(timeInterval: timeInterval)
    }
    
    func updateBackgroundColor(indexPath: Int) {
        let defaults = UserDefaults.standard
        let savedDateRange = defaults.integer(forKey: "dateRange")
        if savedDateRange == indexPath {
            circleView.setBackgroundColor(color: CustomColor.purple2)
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
    
    func addBorder(indexPath: Int) {
        
        let calendar = Calendar.current
        var fillPercent: CGFloat = 0.0
        var secondsPassed: TimeInterval = 0
        var secondsInRange: TimeInterval = 0
        
        let dateRange = MyDateRange(rawValue: indexPath)!
        switch dateRange {
        case .today:
            let startOfDay = calendar.startOfDay(for: Date())
            secondsPassed = Date().timeIntervalSince(startOfDay)
            secondsInRange = 60.0 * 60.0 * 24.0
        case .week:
            let startOfWeek = Date().startOfWeek
            secondsPassed = Date().timeIntervalSince(startOfWeek)
            secondsInRange = 60.0 * 60.0 * 24.0 * 7.0
        case .month:
            let components = calendar.dateComponents([.year, .month], from: Date())
            let startOfMonth = calendar.date(from: components)
            secondsPassed = Date().timeIntervalSince(startOfMonth!)
            var oneMonth = DateComponents()
            oneMonth.month = 1
            let endOfMonth = calendar.date(byAdding: oneMonth, to: startOfMonth!)
            secondsInRange = endOfMonth!.timeIntervalSince(startOfMonth!)
        case .year:
            let components = calendar.dateComponents([.year], from: Date())
            let startOfYear = calendar.date(from: components)
            secondsPassed = Date().timeIntervalSince(startOfYear!)
            var oneYear = DateComponents()
            oneYear.year = 1
            let endOfYear = calendar.date(byAdding: oneYear, to: startOfYear!)
            secondsInRange = endOfYear!.timeIntervalSince(startOfYear!)
        case .allTime:
            
            print("draw mah circle!")
            secondsPassed = 1
            secondsInRange = 1
        }
        
        fillPercent = CGFloat(secondsPassed) / CGFloat(secondsInRange)
        circleView.drawBorder(fillPercent: fillPercent, color: CustomColor.pinkHot, animated: true)
    }
    
}
