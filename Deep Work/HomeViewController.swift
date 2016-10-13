//////////////////////////////////////////////////
//////////////////////////////////////////////////
//
//  HomeViewController.swift
//  Deep Work
//
//  Created by Austin Wood on 2016-10-11.
//  Copyright © 2016 Austin Wood. All rights reserved.
//
//////////////////////////////////////////////////
//////////////////////////////////////////////////
//
// RESUME WITH:
//
// Determine if a timer is currecntly running, change color and text accordingly
// Tapping a cell starts a timer
// Tap to stop
// Don't allow other timers to be tapped when another timer is running
//
//////////////////////////////////////////////////
//////////////////////////////////////////////////
//
// TO DO:
//
// Replace fatalError with something friendlier
//
//////////////////////////////////////////////////
//////////////////////////////////////////////////
//
// REFERENCES:
//
// Dates in Swift 3
// http://www.globalnerdy.com/2016/08/18/how-to-work-with-dates-and-times-in-swift-3-part-1-dates-calendars-and-datecomponents/
//
// Calculating time intervals
// http://stackoverflow.com/questions/27182023/getting-the-difference-between-two-nsdates-in-months-days-hours-minutes-seconds
//
//////////////////////////////////////////////////
//////////////////////////////////////////////////

import UIKit
import CoreData

class HomeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    // Core Data
    var moc: NSManagedObjectContext?
    
    //let projects = ["Ruby", "iOS", "Object Oriented Design", "Deep Work", "Trekkie Calculator", "GamingU", "Stack Overflow", "Project Euler"]
    var projects = [Project]()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = CustomColor.blue
        
        // Core Data
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        moc = appDelegate.persistentContainer.viewContext
        loadData()
        Timer.scheduledTimer(timeInterval: 4.0, target: self, selector: #selector(self.addTimeData), userInfo: nil, repeats: false)
    }
    
    ///////////////////////////
    ///// COLLECTION VIEW /////
    ///////////////////////////
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return projects.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "projectCell", for: indexPath) as! ProjectCell
        let currentProject = projects[indexPath.row]
        cell.configureCell(project: currentProject, moc: moc!)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //print("\(projects[indexPath.row]) tapped")
    }
    
    ///////////////////////
    ///// ADD PROJECT /////
    ///////////////////////
    
    @IBAction func addPressed(_ sender: AnyObject) {
        let alertController = UIAlertController(title: "Add Project", message: "Enter a title:", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addTextField { (textField: UITextField) in }
        let addAction = UIAlertAction(title: "Add", style: .default) { [weak self] (action: UIAlertAction) in
            let projectTitle: String?
            if alertController.textFields?.first?.text != "" {
                projectTitle = alertController.textFields?.first?.text
            } else { return }
            let newProject = Project(context: (self?.moc)!)
            newProject.title = projectTitle
            do { try self?.moc?.save() }
            catch { fatalError("Error storing data") }
            self?.loadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    //////////////////////////////
    ///// ADD FAKE TIME DATA /////
    //////////////////////////////
    
    func addTimeData() {
        for project in projects {
            let newTimeLog = TimeLog(context: (self.moc)!)
            newTimeLog.project = project
            newTimeLog.startTime = Date(timeIntervalSinceNow: -20 * 60)
            newTimeLog.stopTime = Date(timeIntervalSinceNow: -5 * 60)
            newTimeLog.note = "Here's my note"
            do { try self.moc?.save() }
            catch { fatalError("Error storing data") }
        }
        self.loadData()
    }
    
    /////////////////////
    ///// LOAD DATA /////
    /////////////////////
    
    func loadData() {
        let request: NSFetchRequest<Project> = NSFetchRequest(entityName: "Project")
        do {
            let results = try moc?.fetch(request)
            projects = results!
            collectionView.reloadData()
        }
        catch {
            fatalError("Error retrieving grocery item")
        }
    }
    
//    func initializeFormatTime(intervalToFormat: TimeInterval) -> FormatTime {
//        let formatTime = FormatTime(timeInterval: intervalToFormat)
//        return formatTime
//    }
    
}
