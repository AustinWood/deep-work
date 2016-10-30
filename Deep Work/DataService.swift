//
//  DataService.swift
//  Deep Work
//
//  Created by Austin Wood on 2016-10-23.
//  Copyright © 2016 Austin Wood. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class DataService {
    
    internal static func fetchTimeLogs(project: Project, moc: NSManagedObjectContext) -> NSFetchedResultsController<TimeLog> {
        
        let fetchedResultsController: NSFetchedResultsController<TimeLog>
        
        let request: NSFetchRequest<TimeLog> = TimeLog.fetchRequest()
        let workDaySort = NSSortDescriptor(key: "workDay", ascending: true)
        let timeSort = NSSortDescriptor(key: "startTime", ascending: true)
        request.sortDescriptors = [timeSort, workDaySort]
        
        let searchPredicate: NSPredicate?
        searchPredicate = NSPredicate(format: "project = %@", project)
        request.predicate = searchPredicate
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: moc, sectionNameKeyPath: "workDay", cacheName: nil)
        
        do {
            try fetchedResultsController.performFetch()
        }
        catch {
            fatalError("Error fetching time logs")
        }
        
        return fetchedResultsController
    }
    
}
