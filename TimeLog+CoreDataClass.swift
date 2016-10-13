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
                totalTime += (entry.stopTime?.timeIntervalSince(entry.startTime!))!
            } else {
                inProgress = true
            }
        }
        return (totalTime, inProgress)
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
