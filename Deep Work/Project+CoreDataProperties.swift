//
//  Project+CoreDataProperties.swift
//  Deep Work
//
//  Created by Austin Wood on 2016-10-24.
//  Copyright © 2016 Austin Wood. All rights reserved.
//

import Foundation
import CoreData 

extension Project {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Project> {
        return NSFetchRequest<Project>(entityName: "Project");
    }

    @NSManaged public var color: String?
    @NSManaged public var order: Int16
    @NSManaged public var title: String?
    @NSManaged public var timeLog: NSSet?

}

// MARK: Generated accessors for timeLog
extension Project {

    @objc(addTimeLogObject:)
    @NSManaged public func addToTimeLog(_ value: TimeLog)

    @objc(removeTimeLogObject:)
    @NSManaged public func removeFromTimeLog(_ value: TimeLog)

    @objc(addTimeLog:)
    @NSManaged public func addToTimeLog(_ values: NSSet)

    @objc(removeTimeLog:)
    @NSManaged public func removeFromTimeLog(_ values: NSSet)

}
