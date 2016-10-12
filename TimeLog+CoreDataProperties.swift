//
//  TimeLog+CoreDataProperties.swift
//  Deep Work
//
//  Created by Austin Wood on 2016-10-12.
//  Copyright © 2016 Austin Wood. All rights reserved.
//

import Foundation
import CoreData

extension TimeLog {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TimeLog> {
        return NSFetchRequest<TimeLog>(entityName: "WorkEntry");
    }

    @NSManaged public var startTime: Date?
    @NSManaged public var stopTime: Date?
    @NSManaged public var note: String?
    @NSManaged public var project: Project?

}
