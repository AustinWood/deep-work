//
//  WorkDay+CoreDataClass.swift
//  Deep Work
//
//  Created by Austin Wood on 2016-10-23.
//  Copyright © 2016 Austin Wood. All rights reserved.
//

import Foundation
import CoreData


public class WorkDay: NSManagedObject {
    
    internal static func getWorkDay(workDayStr: String, moc: NSManagedObjectContext) -> WorkDay {
        let workDayRequest: NSFetchRequest<WorkDay> = WorkDay.fetchRequest()
        workDayRequest.predicate = NSPredicate(format: "workDay = %@", workDayStr)
        
        do {
            let workDay = try moc.fetch(workDayRequest)
            if workDay.count != 0 {
                return workDay.first!
            } else {
                let newWorkDay = WorkDay(context: moc)
                newWorkDay.workDay = workDayStr
                return newWorkDay
            }
        }
        catch {
            fatalError("Error getting time log")
        }
    }
    
    
    internal static func getAllWorkDays(moc: NSManagedObjectContext) -> [WorkDay] {
        let workDayRequest: NSFetchRequest<WorkDay> = WorkDay.fetchRequest()
        
        do {
            let workDays = try moc.fetch(workDayRequest)
            return workDays
        }
        catch {
            fatalError("Error getting work days")
        }
    }

}
