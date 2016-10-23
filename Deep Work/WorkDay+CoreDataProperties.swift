//
//  WorkDay+CoreDataProperties.swift
//  Deep Work
//
//  Created by Austin Wood on 2016-10-23.
//  Copyright © 2016 Austin Wood. All rights reserved.
//

import Foundation
import CoreData

extension WorkDay {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WorkDay> {
        return NSFetchRequest<WorkDay>(entityName: "WorkDay");
    }

    @NSManaged public var workDay: String?
    @NSManaged public var timeLog: NSSet?

}

// MARK: Generated accessors for timeLog
extension WorkDay {

    @objc(addTimeLogObject:)
    @NSManaged public func addToTimeLog(_ value: TimeLog)

    @objc(removeTimeLogObject:)
    @NSManaged public func removeFromTimeLog(_ value: TimeLog)

    @objc(addTimeLog:)
    @NSManaged public func addToTimeLog(_ values: NSSet)

    @objc(removeTimeLog:)
    @NSManaged public func removeFromTimeLog(_ values: NSSet)

}
