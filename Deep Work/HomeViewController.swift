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
//
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
    var managedObjectContext: NSManagedObjectContext?
    
    //let projects = ["Ruby", "iOS", "Object Oriented Design", "Deep Work", "Trekkie Calculator", "GamingU", "Stack Overflow", "Project Euler"]
    var projects = [Project]()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = CustomColor.blue
        
        // Core Data
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        managedObjectContext = appDelegate.persistentContainer.viewContext
        loadData()
        Timer.scheduledTimer(timeInterval: 4.0, target: self, selector: #selector(self.addTimeData), userInfo: nil, repeats: false)
    }
    
    ///////////////////////////
    ///// COLLECTION VIEW /////
    ///////////////////////////
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return projects.count + 1
    }
    var firstLoad = true
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "projectCell", for: indexPath) as! ProjectCell
        ///// You want to do cell setup in the cell subclass itself!!! /////
        //cell.titleLabel.text = projects[indexPath.row]
        
        if indexPath.row == projects.count {
            cell.timeLabel.text = "+"
            cell.titleLabel.text = ""
        } else {
            let project = projects[indexPath.row]
            getTimeLog(project: project)
            cell.timeLabel.text = "1h 7m"
            cell.titleLabel.text = project.title
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //print("\(projects[indexPath.row]) tapped")
        
        // Add a new item
        if indexPath.row == projects.count {
            addProject()
        }
    }
    
    ///////////////////////
    ///// ADD PROJECT /////
    ///////////////////////
    
    func addProject() {
        let alertController = UIAlertController(title: "Add Project", message: "Enter a title:", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addTextField { (textField: UITextField) in }
        let addAction = UIAlertAction(title: "Add", style: .default) { [weak self] (action: UIAlertAction) in
            let projectTitle: String?
            if alertController.textFields?.first?.text != "" {
                projectTitle = alertController.textFields?.first?.text
            } else { return }
            let newProject = Project(context: (self?.managedObjectContext)!)
            newProject.title = projectTitle
            do { try self?.managedObjectContext?.save() }
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
            let newTimeLog = TimeLog(context: (self.managedObjectContext)!)
            newTimeLog.project = project
            newTimeLog.startTime = Date(timeIntervalSinceNow: -20 * 60)
            newTimeLog.stopTime = Date(timeIntervalSinceNow: -5 * 60)
            newTimeLog.note = "Here's my note"
            do { try self.managedObjectContext?.save() }
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
            let results = try managedObjectContext?.fetch(request)
            projects = results!
            collectionView.reloadData()
        }
        catch {
            fatalError("Error retrieving grocery item")
        }
    }
    
    func getTimeLog(project: Project) { // private
        print("func getTimeLog()")
        let timeLog = TimeLog(context: managedObjectContext!)
        let timeLogArray = timeLog.getTimeLog(project: project, moc: managedObjectContext!)
        print("project: \(project.title!)")
        print("timeLogArray: \(timeLogArray)")
        
        var totalTime = TimeInterval()
        for entry in timeLogArray {
            //let interval = Calendar.current.dateComponents([.minute], from: entry.startTime!, to: entry.startTime!).minute ?? 0
            totalTime += (entry.stopTime?.timeIntervalSince(entry.startTime!))!
        }
        print("totalTime: \(totalTime)")
    }
    
}
