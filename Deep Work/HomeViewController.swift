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
// See responses on Stack Overflow...
// Put tap recognizer on circle, not cell (use tag?)
//
// Bug: Don't repeat updateLabel() when no timer running
//
//
// Long press to start/stop
// Short press opens details
//
//////////////////////////////////////////////////
//////////////////////////////////////////////////
//
// TO DO:
//
// Only current entry (not project) updates by second; project, day, week by minute
// Visual time line at top (like Hours)
// Rearrange by dragging: http://nshint.io/blog/2015/07/16/uicollectionviews-now-have-easy-reordering/
// Give projects an Area parent
// Animate invalid request if trying to start a timer while another is running
// Replace fatalError with something friendlier
// Refactor time summations (todayTime and weekTime DRY)
// Professional design
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
    
    var moc: NSManagedObjectContext? = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var projects = [Project]()
    
    //////////////////////////////////////////////
    // MARK:- Outlets
    
    @IBOutlet weak var todayLabel: UILabel!
    @IBOutlet weak var weekLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var dayView: DayWeekView!
    @IBOutlet weak var weekView: DayWeekView!
    
    //////////////////////////////////////////////
    // MARK:- Initialization
    
    override func viewDidLoad() {
        print("func viewDidLoad()")
        super.viewDidLoad()
        addGestureRecognizers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("func viewWillAppear()")
        loadData()
        //addTimeData()
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    func addGestureRecognizers() {
        let dayRecognizer = UITapGestureRecognizer(target: self, action: #selector(dayPressed(_:)))
        dayView.addGestureRecognizer(dayRecognizer)
        let weekRecognizer = UITapGestureRecognizer(target: self, action: #selector(weekPressed(_:)))
        weekView.addGestureRecognizer(weekRecognizer)
        
    }
    
    //////////////////////////////////////////////
    // MARK:- Gesture recognizer
    
    func tap(_ gestureRecognizer: UITapGestureRecognizer) {
        // Tapped outside circle
    }
    
    func dayPressed(_ gestureRecognizer: UITapGestureRecognizer) {
        print("Day pressed")
    }
    
    func weekPressed(_ gestureRecognizer: UITapGestureRecognizer) {
        print("Week pressed")
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
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tap(_:)))
        cell.circleView.addGestureRecognizer(gestureRecognizer)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let currentProject = projects[indexPath.row]
        startStopTimer(project: currentProject)
    }
    
    //////////////////////////////////////////////
    // MARK:- Add New Project
    
    @IBAction func addPressed(_ sender: AnyObject) {
        print("func addPressed()")
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
        print("func startStopTimer()")
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
    
    var timerRunning = false
    var lastStartTime: Date?
    var timer = Timer()
    
    func checkForRunningTimers() {
        print("func checkForRunningTimers()")
        timerRunning = false
        lastStartTime = nil
        timer.invalidate()
        for project in projects {
            let timeLog = TimeLog(context: moc!)
            if timeLog.inProgress(project: project, moc: moc!)  {
                timerRunning = true
                lastStartTime = timeLog.getCurrentEntry(project: project, moc: moc!).startTime
                Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.updateTimeLabels), userInfo: nil, repeats: true);
            }
        }
    }
    
    //////////////////////////////////////////////
    // MARK:- Calculate Daily and Weekly Totals
    
    func updateTimeLabels() {
        //print("func updateTimeLabels(\(Date()))")
        let timeLog = TimeLog(context: moc!)
        
        collectionView.reloadData()
        
        let todayTime = timeLog.todayTime(projects: projects, moc: moc!)
        let todayFormatted = FormatTime().timeIntervalToString(timeInterval: todayTime)
        todayLabel.text = todayFormatted
        
        let weekTime = timeLog.weekTime(projects: projects, moc: moc!)
        let weekFormatted = FormatTime().timeIntervalToString(timeInterval: weekTime)
        weekLabel.text = weekFormatted
    }
    
    //////////////////////////////////////////////
    // MARK:- Load Data
    
    func loadData() {
        print("func loadData()")
        let request: NSFetchRequest<Project> = NSFetchRequest(entityName: "Project")
        do {
            let results = try moc?.fetch(request)
            projects = results!
        }
        catch {
            fatalError("Error retrieving grocery item")
        }
        checkForRunningTimers()
        updateTimeLabels()
    }
    
    //////////////////////////////////////////////
    // MARK:- Add Fake Time Data
    
    func addTimeData() {
        print("func addTimeData()")
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
