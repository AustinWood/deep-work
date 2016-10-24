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
        print("* AppDelegate: checkDataStore()")
        countProjects()
        countTimeLogs()
    }
    
    func countProjects() {
        let request: NSFetchRequest<Project> = Project.fetchRequest()
        let moc: NSManagedObjectContext? = self.persistentContainer.viewContext
        do {
            let projectCount = try moc?.count(for: request)
            print("projectCount: \(projectCount!)")
            if projectCount == 0 {
                uploadSampleData()
            }
        }
        catch {
            fatalError("Error counting project records")
        }
    }
    
    func countTimeLogs() {
        let request: NSFetchRequest<TimeLog> = TimeLog.fetchRequest()
        let moc: NSManagedObjectContext? = self.persistentContainer.viewContext
        do {
            let timeLogCount = try moc?.count(for: request)
            print("timeLogCount: \(timeLogCount!)")
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
                
                // Project object initialization
                let project = Project(context: moc!)
                project.title = title as? String
                project.order = order.int16Value
                project.color = color as? String
                
                // Time logs
                if let timeLogs = projectData["timeLog"] {
                    let timeLogsData = project.timeLog?.mutableCopy() as! NSMutableSet
                    for timeLog in timeLogs as! NSArray {
                        let timeLogData = timeLog as! [String: AnyObject]
                        let timeLog = TimeLog(context: moc!)
                        timeLog.workDay = timeLogData["workDay"] as? String
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                        let startTimeStr = timeLogData["startTime"] as! String
                        let startTime = dateFormatter.date(from: startTimeStr)
                        timeLog.startTime = startTime
                        let stopTimeStr = timeLogData["stopTime"] as! String
                        let stopTime = dateFormatter.date(from: stopTimeStr)
                        timeLog.stopTime = stopTime
                        timeLog.note = timeLogData["note"] as? String
                        timeLogsData.add(timeLog)
                        project.timeLog = timeLogsData.copy() as? NSSet
                    }
                }
            }
            saveContext()
            checkDataStore()
        }
        catch {
            fatalError("Cannot upload sample data")
        }
    }
    
    func deleteRecords() {
        print("func deleteRecords()")
        let moc: NSManagedObjectContext? = self.persistentContainer.viewContext
        let projectRequest: NSFetchRequest<Project> = Project.fetchRequest()
        let timeLogRequest: NSFetchRequest<TimeLog> = TimeLog.fetchRequest()
        var deleteRequest: NSBatchDeleteRequest
        do {
            deleteRequest = NSBatchDeleteRequest(fetchRequest: projectRequest as! NSFetchRequest<NSFetchRequestResult>)
            try moc!.execute(deleteRequest)
            deleteRequest = NSBatchDeleteRequest(fetchRequest: timeLogRequest as! NSFetchRequest<NSFetchRequestResult>)
            try moc!.execute(deleteRequest)
        }
        catch {
            fatalError("Failed removing existing records")
        }
    }
    
}
