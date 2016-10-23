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
    
    internal static func getTimeLog(project: Project, moc: NSManagedObjectContext) -> [TimeLog] {
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
    
    internal static func getAllTimeLogs(moc: NSManagedObjectContext) -> [TimeLog] {
        let timeLogRequest: NSFetchRequest<TimeLog> = TimeLog.fetchRequest()
        //timeLogRequest.predicate = NSPredicate(format: "project = %@", project)
        
        do {
            let timeLog = try moc.fetch(timeLogRequest)
            return timeLog
        }
        catch {
            fatalError("Error getting time log")
        }
    }
    
//    func totalTime(project: Project, moc: NSManagedObjectContext) -> (TimeInterval, Bool) {
//        var inProgress = false
//        let timeLog = TimeLog(context: managedObjectContext!)
//        let timeLogArray = timeLog.getTimeLog(project: project, moc: managedObjectContext!)
//        var totalTime = TimeInterval()
//        for entry in timeLogArray {
//            if entry.stopTime != nil {
//                if Calendar.current.isDateInToday(entry.startTime!) {
//                    totalTime += (entry.stopTime?.timeIntervalSince(entry.startTime!))!
//                }
//            } else {
//                inProgress = true
//                totalTime += (Date().timeIntervalSince(entry.startTime!))
//            }
//        }
//        return (totalTime, inProgress)
//    }
    
    internal static func todayTime(projects: [Project], moc: NSManagedObjectContext) -> TimeInterval {
        var totalTime = TimeInterval()
        for project in projects {
            //let timeLog = TimeLog(context: managedObjectContext!)
            //let timeLogArray = timeLog.getTimeLog(project: project, moc: managedObjectContext!)
            let timeLogArray = TimeLog.getTimeLog(project: project, moc: moc)
            for entry in timeLogArray {
                if entry.stopTime != nil {
                    let isToday = Calendar.current.isDateInToday(entry.startTime!)
                    if isToday {
                        totalTime += (entry.stopTime?.timeIntervalSince(entry.startTime!))!
                    }
                } else {
                    totalTime += (Date().timeIntervalSince(entry.startTime!))
                }
            }
        }
        return totalTime
    }
    
    internal static func weekTime(projects: [Project], moc: NSManagedObjectContext) -> TimeInterval {
        
        let startOfThisWeek = Date().startOfWeek
        let calendar = NSCalendar.current
        var dateComponents = DateComponents()
        dateComponents.day = 7
        let startOfNextWeek = calendar.date(byAdding: dateComponents, to: startOfThisWeek)
        
        var totalTime = TimeInterval()
        for project in projects {
            //let timeLog = TimeLog(context: managedObjectContext!)
            //let timeLogArray = timeLog.getTimeLog(project: project, moc: managedObjectContext!)
            let timeLogArray = TimeLog.getTimeLog(project: project, moc: moc)
            for entry in timeLogArray {
                if entry.stopTime != nil {
                    if entry.startTime! >= startOfThisWeek && entry.startTime! < startOfNextWeek! {
                        totalTime += (entry.stopTime?.timeIntervalSince(entry.startTime!))!
                    }
                } else {
                    totalTime += (Date().timeIntervalSince(entry.startTime!))
                }
            }
        }
        return totalTime
    }
    
    internal static func inProgress(project: Project, moc: NSManagedObjectContext) -> Bool {
        var inProgress = false
        //let timeLog = TimeLog(context: managedObjectContext!)
        //let timeLogArray = timeLog.getTimeLog(project: project, moc: managedObjectContext!)
        let timeLogArray = TimeLog.getTimeLog(project: project, moc: moc)
        for entry in timeLogArray {
            if entry.stopTime == nil {
                inProgress = true
            }
        }
        return inProgress
    }
    
    internal static func currentSessionLength(project: Project, moc: NSManagedObjectContext) -> TimeInterval {
        //let timeLog = TimeLog(context: managedObjectContext!)
        //let timeLogArray = timeLog.getTimeLog(project: project, moc: managedObjectContext!)
        let timeLogArray = TimeLog.getTimeLog(project: project, moc: moc)
        for entry in timeLogArray {
            if entry.stopTime == nil {
                return (Date().timeIntervalSince(entry.startTime!))
            }
        }
        return 0
    }
    
//    func calculateSessionLength(timeLog: TimeLog, moc: NSManagedObjectContext) -> TimeInterval {
//        
//    }
    
    internal static func getCurrentEntry(project: Project, moc: NSManagedObjectContext) -> TimeLog {
        //let timeLog = TimeLog(context: managedObjectContext!)
        //let timeLogArray = timeLog.getTimeLog(project: project, moc: managedObjectContext!)
        let timeLogArray = TimeLog.getTimeLog(project: project, moc: moc)
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
