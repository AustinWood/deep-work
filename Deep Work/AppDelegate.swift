//
//  AppDelegate.swift
//  Deep Work
//
//  Created by Austin Wood on 2016-10-11.
//  Copyright © 2016 Austin Wood. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        deleteRecords()
        checkDataStore()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Deep_Work")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    //////////////////////////////////////////////
    // Custom Core Data junk
    
    func checkDataStore() {
        let request: NSFetchRequest<Project> = Project.fetchRequest()
        let moc: NSManagedObjectContext? = self.persistentContainer.viewContext
        do {
            let projectCount = try moc?.count(for: request)
            print("projectCount = \(projectCount!)")
            if projectCount == 0 {
                uploadSampleData()
            }
        }
        catch {
            fatalError("Error counting project records")
        }
    }
    
    func uploadSampleData() {
        print("func uploadSampleData()")
        let moc: NSManagedObjectContext? = self.persistentContainer.viewContext
        let url = Bundle.main.url(forResource: "sampleData", withExtension: "json")
        let data = try? Data(contentsOf: url!)
        do {
            let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
            let jsonArray = jsonResult.value(forKey: "project") as! NSArray
            
            //var home: NSManagedObject?
            for json in jsonArray {
                
                let projectData = json as! [String: AnyObject]
                
                guard let title = projectData["title"] else {
                    return
                }
                
                guard let order = projectData["order"] else {
                    return
                }
                
                guard let color = projectData["color"] else {
                    return
                }
                
                guard let image = projectData["image"] else {
                    return
                }
                
                // Project object initialization
                let project = Project(context: moc!)
                project.title = title as? String
                print(order)
                project.order = order.int16Value
                project.color = color as? String
                project.image = image as? String
                
                // Time logs
                if let workEntries = projectData["workEntry"] {
                    let workEntryData = project.workEntry?.mutableCopy() as! NSMutableSet
                    
                    for workEntry in workEntries as! NSArray {
                        let entryData = workEntry as! [String: AnyObject]
                        
                        let logEntry = TimeLog(context: moc!)
                        let startTimeStr = entryData["startTime"] as! String
                        let stopTimeStr = entryData["stopTime"] as! String
                        
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                        let startTime = dateFormatter.date(from: startTimeStr)
                        let stopTime = dateFormatter.date(from: stopTimeStr)
                        
                        logEntry.startTime = startTime
                        logEntry.stopTime = stopTime
                        
                        logEntry.note = entryData["note"] as? String
                        
                        workEntryData.add(logEntry)
                        project.workEntry = workEntryData.copy() as? NSSet
                    }
                }
            }
            saveContext()
        }
        catch {
            fatalError("Cannot upload sample data")
        }
    }
    
    func deleteRecords() {
        print("func deleteRecords()")
        let moc: NSManagedObjectContext? = self.persistentContainer.viewContext
        let projectRequest: NSFetchRequest<Project> = Project.fetchRequest()
        let workEntryRequest: NSFetchRequest<TimeLog> = TimeLog.fetchRequest()
        
        var deleteRequest: NSBatchDeleteRequest
        var deleteResults: NSPersistentStoreResult
        do {
            deleteRequest = NSBatchDeleteRequest(fetchRequest: projectRequest as! NSFetchRequest<NSFetchRequestResult>)
            deleteResults = try moc!.execute(deleteRequest)
            
            deleteRequest = NSBatchDeleteRequest(fetchRequest: workEntryRequest as! NSFetchRequest<NSFetchRequestResult>)
            deleteResults = try moc!.execute(deleteRequest)
            
            print(deleteResults)
        }
        catch {
            fatalError("Failed removing existing records")
        }
    }
    
}
