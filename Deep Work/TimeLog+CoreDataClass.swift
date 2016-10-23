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
    
    //////////////////////////////////////////////
    // Basic time log fetching
    
    internal static func getTimeLogs(searchPredicate: AnyObject?, moc: NSManagedObjectContext) -> [TimeLog] {
        let timeLogRequest: NSFetchRequest<TimeLog> = TimeLog.fetchRequest()
        if searchPredicate is NSPredicate {
            timeLogRequest.predicate = searchPredicate as? NSPredicate
        }
        do {
            let timeLogs = try moc.fetch(timeLogRequest)
            return timeLogs
        }
        catch {
            fatalError("Error getting time log")
        }
    }
    
    internal static func getTimeLogsForProjects(projects: [Project], moc: NSManagedObjectContext) -> [TimeLog] {
        var timeLogs: [TimeLog] = []
        for project in projects {
            let searchPredicate = NSPredicate(format: "project = %@", project)
            let projectTimeLogs = getTimeLogs(searchPredicate: searchPredicate, moc: moc)
            timeLogs += projectTimeLogs
        }
        return timeLogs
    }
    
    //////////////////////////////////////////////
    // Totals by day, week, month
    
    internal static func calculateTotalTime(timeLogs: [TimeLog], moc: NSManagedObjectContext) -> TimeInterval {
        var totalTime = TimeInterval()
        for timeLog in timeLogs {
            if timeLog.stopTime != nil {
                totalTime += (timeLog.stopTime?.timeIntervalSince(timeLog.startTime!))!
            } else {
                totalTime += (Date().timeIntervalSince(timeLog.startTime!))
            }
        }
        return totalTime
    }
    
    internal static func todayTime(projects: [Project], moc: NSManagedObjectContext) -> TimeInterval {
        let allTimeLogs = getTimeLogsForProjects(projects: projects, moc: moc)
        var todayTimeLogs: [TimeLog] = []
        for timeLog in allTimeLogs {
            if Calendar.current.isDateInToday(timeLog.startTime!) {
                todayTimeLogs.append(timeLog)
            }
        }
        return calculateTotalTime(timeLogs: todayTimeLogs, moc: moc)
    }
    
    internal static func weekTime(projects: [Project], moc: NSManagedObjectContext) -> TimeInterval {
        let startOfThisWeek = Date().startOfWeek
        let calendar = NSCalendar.current
        var dateComponents = DateComponents()
        dateComponents.day = 7
        let startOfNextWeek = calendar.date(byAdding: dateComponents, to: startOfThisWeek)
        let allTimeLogs = getTimeLogsForProjects(projects: projects, moc: moc)
        var weekTimeLogs: [TimeLog] = []
        for timeLog in allTimeLogs {
            if timeLog.startTime! >= startOfThisWeek && timeLog.startTime! < startOfNextWeek! {
                weekTimeLogs.append(timeLog)
            }
        }
        return calculateTotalTime(timeLogs: weekTimeLogs, moc: moc)
    }
    
    //////////////////////////////////////////////
    // Miscellaneous time log methods
    
    internal static func currentSessionLength(project: Project, moc: NSManagedObjectContext) -> TimeInterval {
        let currentEntry = getCurrentEntry(project: project, moc: moc)
        if currentEntry != nil {
            return (Date().timeIntervalSince(currentEntry!.startTime!))
        }
        return 0
    }
    
    internal static func getCurrentEntry(project: Project, moc: NSManagedObjectContext) -> TimeLog? {
        let timeLogs = getTimeLogsForProjects(projects: [project], moc: moc)
        for timeLog in timeLogs {
            if timeLog.stopTime == nil {
                return timeLog
            }
        }
        return nil
    }
    
}

//////////////////////////////////////////////
// Date extension

extension Date {
    struct Calendar {
        static let iso8601 = NSCalendar(calendarIdentifier: NSCalendar.Identifier.ISO8601)!
    }
    var startOfWeek: Date {
        return Calendar.iso8601.date(from: Calendar.iso8601.components([.yearForWeekOfYear, .weekOfYear], from: self as Date))!
    }
}
