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
// Calculate total time for today
// Calculate total time for this week
//
//////////////////////////////////////////////////
//////////////////////////////////////////////////
//
// TO DO:
//
// Rearrange by dragging: http://nshint.io/blog/2015/07/16/uicollectionviews-now-have-easy-reordering/
// Give projects an Area parent
// Animate invalid request if trying to start a timer while another is running
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
    
    //////////////////////////////////////////////
    // MARK:- Properties
    
    var moc: NSManagedObjectContext?
    var projects = [Project]()
    var timerRunning = false
    
    //////////////////////////////////////////////
    // MARK:- Outlets
    
    @IBOutlet weak var todayLabel: UILabel!
    @IBOutlet weak var weekLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    //////////////////////////////////////////////
    // MARK:- Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setColors()
        initializeCoreData()
    }
    
    func setColors() {
        self.view.backgroundColor = CustomColor.blue
    }
    
    func initializeCoreData() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        moc = appDelegate.persistentContainer.viewContext
        loadData()
        Timer.scheduledTimer(timeInterval: 4.0, target: self, selector: #selector(self.addTimeData), userInfo: nil, repeats: false)
    }
    
    //////////////////////////////////////////////
    // MARK:- Collection View
    
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
        let currentProject = projects[indexPath.row]
        startStopTimer(project: currentProject)
    }
    
    //////////////////////////////////////////////
    // MARK:- Add New Project
    
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
    
    //////////////////////////////////////////////
    // MARK:- Start / Stop time log
    
    func startStopTimer(project: Project) {
        let timeLog = TimeLog(context: moc!)
        if timeLog.inProgress(project: project, moc: moc!) {
            print("Stop the timer")
            let currentEntry = timeLog.getCurrentEntry(project: project, moc: moc!)
            currentEntry.stopTime = Date()
            //currentEntry.note = "Here's my note"
        } else if !timerRunning {
            // Start a new time log
            print("Start the timer")
            let newTimeLog = TimeLog(context: (self.moc)!)
            newTimeLog.project = project
            newTimeLog.startTime = Date()
        } else {
            // Animate invalid tap
            print("You can't start a timer while another is in progress!")
        }
        do { try self.moc?.save() }
        catch { fatalError("Error storing data") }
        self.loadData()
    }
    
    //////////////////////////////////////////////
    // MARK:- Check for running timers
    
    func checkForRunningTimers() {
        timerRunning = false
        for project in projects {
            let timeLog = TimeLog(context: moc!)
            if timeLog.inProgress(project: project, moc: moc!)  {
                timerRunning = true
            }
        }
    }
    
    //////////////////////////////////////////////
    // MARK:- Calculate Daily and Weekly Totals
    
    func calculateTotalTime() {
        var totalTimeToday = TimeInterval()
        for project in projects {
            let timeLog = TimeLog(context: moc!)
            let (totalTime, inProgress) = timeLog.totalTime(project: project, moc: moc!)
            totalTimeToday += totalTime
        }
        let displayInterval = FormatTime().timeIntervalToString(timeInterval: totalTimeToday)
        todayLabel.text = displayInterval
    }
    
    
    //////////////////////////////////////////////
    // MARK:- Load Data
    
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
        checkForRunningTimers()
        calculateTotalTime()
    }
    
    //////////////////////////////////////////////
    // MARK:- Add Fake Time Data
    
    func addTimeData() {
        for project in projects {
            let newTimeLog = TimeLog(context: (self.moc)!)
            newTimeLog.project = project
            newTimeLog.startTime = Date(timeIntervalSinceNow: -1700 * 60)
            newTimeLog.stopTime = Date(timeIntervalSinceNow: -1650 * 60)
            newTimeLog.note = "Here's my note"
            do { try self.moc?.save() }
            catch { fatalError("Error storing data") }
        }
        self.loadData()
    }
    
}
