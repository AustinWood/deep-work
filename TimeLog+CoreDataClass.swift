//
//  TimeLog+CoreDataClass.swift
//  Deep Work
//
//  Created by Austin Wood on 2016-10-12.
//  Copyright © 2016 Austin Wood. All rights reserved.
//

import Foundation
import CoreData


public class TimeLog: NSManagedObject {
    
    func getTimeLog(project: Project, moc: NSManagedObjectContext) -> [TimeLog] {
        let timeLogRequest: NSFetchRequest<TimeLog> = TimeLog.fetchRequest()
        timeLogRequest.predicate = NSPredicate(format: "project = %@", project)
        
        do {
            let timeLog = try moc.fetch(timeLogRequest)
            return timeLog
        }
        catch {
            fatalError("Error getting time log")
        }
    }
    
    func totalTime(project: Project, moc: NSManagedObjectContext) -> (TimeInterval, Bool) {
        var inProgress = false
        let timeLog = TimeLog(context: managedObjectContext!)
        let timeLogArray = timeLog.getTimeLog(project: project, moc: managedObjectContext!)
        var totalTime = TimeInterval()
        for entry in timeLogArray {
            if entry.stopTime != nil {
                if Calendar.current.isDateInToday(entry.startTime!) {
                    totalTime += (entry.stopTime?.timeIntervalSince(entry.startTime!))!
                }
            } else {
                inProgress = true
            }
        }
        return (totalTime, inProgress)
    }
    
    func todayTime(projects: [Project], moc: NSManagedObjectContext) -> TimeInterval {
        var totalTime = TimeInterval()
        for project in projects {
            let timeLog = TimeLog(context: managedObjectContext!)
            let timeLogArray = timeLog.getTimeLog(project: project, moc: managedObjectContext!)
            for entry in timeLogArray {
                let isToday = Calendar.current.isDateInToday(entry.startTime!)
                if isToday && entry.stopTime != nil {
                    totalTime += (entry.stopTime?.timeIntervalSince(entry.startTime!))!
                }
            }
        }
        return totalTime
    }
    
    func weekTime(projects: [Project], moc: NSManagedObjectContext) -> TimeInterval {
        
        let startOfThisWeek = Date().startOfWeek
        let calendar = NSCalendar.current
        var dateComponents = DateComponents()
        dateComponents.day = 7
        let startOfNextWeek = calendar.date(byAdding: dateComponents, to: startOfThisWeek)
        
        var totalTime = TimeInterval()
        for project in projects {
            let timeLog = TimeLog(context: managedObjectContext!)
            let timeLogArray = timeLog.getTimeLog(project: project, moc: managedObjectContext!)
            for entry in timeLogArray {
                if entry.stopTime != nil {
                    if entry.startTime! >= startOfThisWeek && entry.startTime! < startOfNextWeek! {
                        totalTime += (entry.stopTime?.timeIntervalSince(entry.startTime!))!
                    }
                }
            }
        }
        return totalTime
    }
    
    func inProgress(project: Project, moc: NSManagedObjectContext) -> Bool {
        var inProgress = false
        let timeLog = TimeLog(context: managedObjectContext!)
        let timeLogArray = timeLog.getTimeLog(project: project, moc: managedObjectContext!)
        for entry in timeLogArray {
            if entry.stopTime == nil {
                inProgress = true
            }
        }
        return inProgress
    }
    
    func getCurrentEntry(project: Project, moc: NSManagedObjectContext) -> TimeLog {
        let timeLog = TimeLog(context: managedObjectContext!)
        let timeLogArray = timeLog.getTimeLog(project: project, moc: managedObjectContext!)
        for entry in timeLogArray {
            if entry.stopTime == nil {
                return entry
            }
        }
        return TimeLog()
    }
    

}


extension Date {
    struct Calendar {
        static let iso8601 = NSCalendar(calendarIdentifier: NSCalendar.Identifier.ISO8601)!
    }
    var startOfWeek: Date {
        return Calendar.iso8601.date(from: Calendar.iso8601.components([.yearForWeekOfYear, .weekOfYear], from: self as Date))!
    }
}
