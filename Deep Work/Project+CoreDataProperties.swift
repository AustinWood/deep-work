//
//  Project+CoreDataProperties.swift
//  Deep Work
//
//  Created by Austin Wood on 2016-10-20.
//  Copyright © 2016 Austin Wood. All rights reserved.
//

import Foundation
import CoreData

extension Project {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Project> {
        return NSFetchRequest<Project>(entityName: "Project");
    }

    @NSManaged public var color: String?
    @NSManaged public var image: String?
    @NSManaged public var title: String?
    @NSManaged public var order: Int16
    @NSManaged public var workEntry: NSSet?

}

// MARK: Generated accessors for workEntry
extension Project {

    @objc(addWorkEntryObject:)
    @NSManaged public func addToWorkEntry(_ value: TimeLog)

    @objc(removeWorkEntryObject:)
    @NSManaged public func removeFromWorkEntry(_ value: TimeLog)

    @objc(addWorkEntry:)
    @NSManaged public func addToWorkEntry(_ values: NSSet)

    @objc(removeWorkEntry:)
    @NSManaged public func removeFromWorkEntry(_ values: NSSet)

}
