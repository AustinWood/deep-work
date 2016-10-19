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
// Views at top of screen switch between displaying project time as day total or week total
//
//////////////////////////////////////////////////
//////////////////////////////////////////////////
//
// TO DO:
//
// Export data to JSON/CSV
// Import data
// Display details
// Delete/archive timers
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
    var displayWeekTotals = false
    
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
        super.viewDidLoad()
        addGestureRecognizers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadData()
        //addFakeTimeData()
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    func addGestureRecognizers() {
        let dayRecognizer = UITapGestureRecognizer(target: self, action: #selector(dayPressed(_:)))
        dayView.addGestureRecognizer(dayRecognizer)
        let weekRecognizer = UITapGestureRecognizer(target: self, action: #selector(weekPressed(_:)))
        weekView.addGestureRecognizer(weekRecognizer)
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        longPressRecognizer.minimumPressDuration = 0.5
        longPressRecognizer.delaysTouchesBegan = true
        self.collectionView?.addGestureRecognizer(longPressRecognizer)
    }
    
    //////////////////////////////////////////////
    // MARK:- Gesture recognizer
    
    func tap(_ gestureRecognizer: UITapGestureRecognizer) {
        // Tapped outside circle
    }
    
    func dayPressed(_ gestureRecognizer: UITapGestureRecognizer) {
        displayWeekTotals = false
        saveDisplaySettings()
    }
    
    func weekPressed(_ gestureRecognizer: UITapGestureRecognizer) {
        displayWeekTotals = true
        saveDisplaySettings()
    }
    
    func saveDisplaySettings() {
        UserDefaults.standard.set(displayWeekTotals, forKey: "displayWeekTotals")
        updateTimeLabels()
    }
    
    func handleLongPress(gestureRecognizer: UILongPressGestureRecognizer) {
        if (gestureRecognizer.state == UIGestureRecognizerState.began){
            let p = gestureRecognizer.location(in: self.collectionView)
            if let selectedIndex = (self.collectionView?.indexPathForItem(at: p)) as NSIndexPath? {
                editProject(project: projects[selectedIndex.row])
            }
        }
        return
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
    // MARK:- Add / Edit Project
    
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
        alertController.addAction(cancelAction)
        alertController.addAction(addAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func editProject(project: Project) {
        let alertController = UIAlertController(title: "Edit Project Title", message: "Enter a new title for \(project.title!):", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addTextField { (textField: UITextField) in }
        let saveAction = UIAlertAction(title: "Save", style: .default) { [weak self] (action: UIAlertAction) in
            let projectTitle: String?
            if alertController.textFields?.first?.text != "" {
                projectTitle = alertController.textFields?.first?.text
            } else { return }
            //let newProject = Project(context: (self?.moc)!)
            project.title = projectTitle
            do { try self?.moc?.save() }
            catch { fatalError("Error storing data") }
            self?.loadData()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)
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
    
    var timerRunning = false
    var lastStartTime: Date?
    var timer = Timer()
    
    func checkForRunningTimers() {
        timerRunning = false
        lastStartTime = nil
        timer.invalidate()
        for project in projects {
            let timeLog = TimeLog(context: moc!)
            if timeLog.inProgress(project: project, moc: moc!)  {
                timerRunning = true
                lastStartTime = timeLog.getCurrentEntry(project: project, moc: moc!).startTime
                timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.updateTimeLabels), userInfo: nil, repeats: true);
            }
        }
    }
    
    //////////////////////////////////////////////
    // MARK:- Calculate Daily and Weekly Totals
    
    func updateTimeLabels() {
        collectionView.reloadData()
        
        let timeLog = TimeLog(context: moc!)
        let todayTime = timeLog.todayTime(projects: projects, moc: moc!)
        let todayFormatted = FormatTime().formattedHoursMinutes(timeInterval: todayTime)
        todayLabel.text = todayFormatted
        let weekTime = timeLog.weekTime(projects: projects, moc: moc!)
        let weekFormatted = FormatTime().formattedHoursMinutes(timeInterval: weekTime)
        weekLabel.text = weekFormatted
        
        // Refresh the design of 'Today' and 'This week' labels
        if displayWeekTotals {
            weekView.isSelected()
            dayView.isNotSelected()
        } else {
            weekView.isNotSelected()
            dayView.isSelected()
        }
    }
    
    //////////////////////////////////////////////
    // MARK:- Load Data
    
    func loadData() {
        print("func loadData()")
        displayWeekTotals = UserDefaults.standard.bool(forKey: "displayWeekTotals")
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
    
    func addFakeTimeData() {
        print("func addFakeTimeData()")
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
