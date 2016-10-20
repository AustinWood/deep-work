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
// Remove deleteRecords() from app delegate and add option to settings
//
//////////////////////////////////////////////////
//////////////////////////////////////////////////
//
// TO DO:
//
// Delete/archive timers
// Display details
// Add back edit project name long press (disabled for reordering)
// Bug: App freezes if cell moved out of bounds of collection view during reordering
//
// After stopping a timer, fade-in a dialog with text
//    "You just saved an entry of #TimeInterval for project #Porject".
//    And two buttons: 'Delete' and 'Add Note'.
//    This view can fade out after 5 seconds.
//
// Add randomized confimation messages to "Add note"
// Daily/Weekly goals (see Evernote)
// Sort JSON time entries for readability
//
// Visual time line at top (like Hours)
// Give projects an Area parent / tags
// Animate invalid request if trying to start a timer while another is running
//
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
import MessageUI

class HomeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, MFMailComposeViewControllerDelegate {
    
    //////////////////////////////////////////////
    // MARK:- Properties
    
    let moc: NSManagedObjectContext? = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
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
        
        // Long Press Recognizer for editing project name
//        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
//        longPressRecognizer.minimumPressDuration = 0.5
//        longPressRecognizer.delaysTouchesBegan = true
//        self.collectionView?.addGestureRecognizer(longPressRecognizer)
        
        // For rearranging collection view cells
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        longPressGesture.minimumPressDuration = 0.3
        self.collectionView.addGestureRecognizer(longPressGesture)
    }
    
    var oldIndex = IndexPath()
    
    func handleLongPress(gesture: UILongPressGestureRecognizer) {
        print("Long press!")
        switch(gesture.state) {
            
        case UIGestureRecognizerState.began:
            guard let selectedIndexPath = self.collectionView.indexPathForItem(at: gesture.location(in: self.collectionView)) else {
                break
            }
            oldIndex = selectedIndexPath
            collectionView.beginInteractiveMovementForItem(at: selectedIndexPath)
            let selectedCell = self.collectionView.cellForItem(at: selectedIndexPath) as! ProjectCell
            selectedCell.circleView.backgroundColor = CustomColor.blueGreen
        
        case UIGestureRecognizerState.changed:
            collectionView.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view!))
        
        case UIGestureRecognizerState.ended:
            guard let newIndex = self.collectionView.indexPathForItem(at: gesture.location(in: self.collectionView)) else {
                break
            }
            let element = projects.remove(at: oldIndex.row)
            projects.insert(element, at: newIndex.row)
            updateProjectOrder()
            collectionView.endInteractiveMovement()
        default:
            collectionView.cancelInteractiveMovement()
        }
    }
    
    func updateProjectOrder() {
        var i = 0
        while i < projects.count {
            let project = projects[i] as Project
            project.order = Int16(i)
            i += 1
        }
    }
    
    //////////////////////////////////////////////
    // MARK:- Gesture recognizer
    
//    func tap(_ gestureRecognizer: UITapGestureRecognizer) {
//        // Tapped outside circle
//    }
    
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
    
//    func handleLongPress(gestureRecognizer: UILongPressGestureRecognizer) {
//        if (gestureRecognizer.state == UIGestureRecognizerState.began){
//            let p = gestureRecognizer.location(in: self.collectionView)
//            if let selectedIndex = (self.collectionView?.indexPathForItem(at: p)) as NSIndexPath? {
//                editProject(project: projects[selectedIndex.row])
//            }
//        }
//        return
//    }
    
    //////////////////////////////////////////////
    // MARK:- Collection View
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return projects.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "projectCell", for: indexPath) as! ProjectCell
        let currentProject = projects[indexPath.row]
        cell.configureCell(project: currentProject, moc: moc!)
//        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tap(_:)))
//        cell.circleView.addGestureRecognizer(gestureRecognizer)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let currentProject = projects[indexPath.row]
        startStopTimer(project: currentProject)
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
    }
    
    //////////////////////////////////////////////
    // MARK:- Alerts and Menus
    
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
            newProject.order = Int16((self?.projects.count)!)
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
    
    func addNote(timeLog: TimeLog) {
        let sessionLength = Date().timeIntervalSince(timeLog.startTime!)
        let sessionLengthFormatted = FormatTime().formattedHoursMinutes(timeInterval: sessionLength)
        let project = timeLog.project
        let alertController = UIAlertController(title: "\(project!.title!)\n\n\(sessionLengthFormatted)", message: "\nGreat work!\n\nYou may add a note if you wish.", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addTextField { (textField: UITextField) in }
        let deleteAction = UIAlertAction(title: "Delete entry", style: .destructive) { [weak self] (action: UIAlertAction) in
            self?.warningDeleteEntry(timeLog: timeLog)
        }
        let cancelAction = UIAlertAction(title: "Continue working", style: .default, handler: nil)
        let saveAction = UIAlertAction(title: "Save entry", style: .default) { [weak self] (action: UIAlertAction) in
            timeLog.stopTime = Date()
            var noteStr = alertController.textFields?.first?.text
            noteStr = noteStr?.replacingOccurrences(of: "\"", with: "'") // Replace double quotes with single quotes to avoid confusing JSON exporter
            timeLog.note = noteStr
            do { try self?.moc?.save() }
            catch { fatalError("Error storing data") }
            self?.loadData()
        }
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func warningDeleteEntry(timeLog: TimeLog) {
        let alertController = UIAlertController(title: "Warning!", message: "Are you sure you want to delete the current entry? This action cannot be undone.", preferredStyle: .actionSheet)
        let continueButton = UIAlertAction(title: "Delete entry", style: .destructive, handler: { (action) -> Void in
            do {
                let request: NSFetchRequest<TimeLog> = NSFetchRequest(entityName: "WorkEntry")
                do {
                    let results = try self.moc?.fetch(request)
                    for result in results! {
                        if result == timeLog {
                            print("Deleted!")
                            self.moc?.delete(result)
                        }
                    }
                }
            }
            catch { fatalError("Error deleting data") }
            self.loadData()
        })
        let cancelButton = UIAlertAction(title: "Continue working", style: .cancel, handler: { (action) -> Void in })
        alertController.addAction(continueButton)
        alertController.addAction(cancelButton)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func settingsPressed(_ sender: AnyObject) {
        let alertController = UIAlertController(title: "Settings", message: "What would you like to do?", preferredStyle: .actionSheet)
        let exportButton = UIAlertAction(title: "Export data as JSON", style: .default, handler: { (action) -> Void in
            self.emailData()
        })
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in })
        alertController.addAction(exportButton)
        alertController.addAction(cancelButton)
        self.present(alertController, animated: true, completion: nil)
    }

    //////////////////////////////////////////////
    // MARK:- Start / Stop time log

    func startStopTimer(project: Project) {
        let timeLog = TimeLog(context: moc!)
        if timeLog.inProgress(project: project, moc: moc!) {
            let currentEntry = timeLog.getCurrentEntry(project: project, moc: moc!)
            addNote(timeLog: currentEntry)
        } else if !timerRunning {
            // Start a new time log
            let newTimeLog = TimeLog(context: (self.moc)!)
            newTimeLog.project = project
            newTimeLog.startTime = Date()
            
            // THIS WILL NEED TO BE COPIED TO addComment SECTION
            do { try self.moc?.save() }
            catch { fatalError("Error storing data") }
            self.loadData()
        } else {
            // Animate invalid tap
            print("You can't start a timer while another is in progress!")
        }
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
        // Update the time in each collection view cell
        collectionView.reloadData()
        
        // Update the time of 'Today' and 'This week' labels
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
        displayWeekTotals = UserDefaults.standard.bool(forKey: "displayWeekTotals")
        let request: NSFetchRequest<Project> = NSFetchRequest(entityName: "Project")
        do {
            let results = try moc?.fetch(request)
            projects = results!
        }
        catch {
            fatalError("Error retrieving grocery item")
        }
        projects.sort(by: { $0.order < $1.order })
        checkForRunningTimers()
        updateTimeLabels()
    }
    
    //////////////////////////////////////////////
    // MARK:- Add Fake Time Data
    
    func addFakeTimeData() {
//        print("func addFakeTimeData()")
//        for project in projects {
//            let newTimeLog = TimeLog(context: (self.moc)!)
//            newTimeLog.project = project
//            newTimeLog.startTime = Date(timeIntervalSinceNow: -1700 * 60)
//            newTimeLog.stopTime = Date(timeIntervalSinceNow: -1650 * 60)
//            newTimeLog.note = "Here's my note"
//            do { try self.moc?.save() }
//            catch { fatalError("Error storing data") }
//        }
//        self.loadData()
    }
    
    //////////////////////////////////////////////
    // MARK:- Export Data
    
    func emailData() {
        if timerRunning {
            warningRunningTimer()
        } else {
            initiateEmail()
        }
    }
    
    func warningRunningTimer() {
        let alertController = UIAlertController(title: "Warning!", message: "A timer is currently running. Data with incomplete entries can lead to irregular results when later imported back into the app. Are you sure you want to export data now?", preferredStyle: .actionSheet)
        let continueButton = UIAlertAction(title: "Continue with export", style: .destructive, handler: { (action) -> Void in
            self.initiateEmail()
        })
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in
            // Do nothing
        })
        alertController.addAction(continueButton)
        alertController.addAction(cancelButton)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func initiateEmail() {
        print("\n\n************************************************************\n\n")
        print(exportJSON())
        print("\n\n************************************************************\n\n")
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            print("Error sending email")
        }
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let stringToSend = exportJSON()
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        mailComposerVC.setToRecipients(["austinkwood.57e2b0b@m.evernote.com"])
        mailComposerVC.setSubject("Deep Work data @Archive #data")
        mailComposerVC.setMessageBody("\(stringToSend)", isHTML: false)
        return mailComposerVC
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
    func exportJSON() -> String {
        var dataString = "{\"project\": [\n\n"
        //var tasksToSend = allTasks + substances + dataPoint
        //tasksToSend.sortInPlace({ $0.taskOrder < $1.taskOrder })
        for project in projects {
            dataString += "{\n" + "\"title\":\"" + project.title! + "\",\n"
            dataString += "\"order\":" + "\(project.order)" + ",\n"
            dataString += "\"color\":\"" + "" + "\",\n" // project.color!
            dataString += "\"image\":\"" + "" + "\",\n" // project.image!
            dataString += "\"workEntry\": [\n\n"
            var workData = ""
            for entry in project.workEntry! {
                let entryData = entry as! TimeLog
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                let startTime = entryData.startTime
                let startTimeStr = dateFormatter.string(from: startTime!)
                workData += "{\n" + "\"startTime\":\"" + startTimeStr + "\",\n"
                if let stopTime = entryData.stopTime {
                    let stopTimeStr = dateFormatter.string(from: stopTime)
                    workData += "\"stopTime\":\"" + stopTimeStr + "\",\n"
                } else {
                    workData += "\"stopTime\":\"" + "" + "\",\n"
                }
                if let note = entryData.note {
                    workData += "\"note\":\"" + note + "\"},\n"
                } else {
                    workData += "\"note\":\"" + "" + "\"},\n"
                }
            }
            workData += "]},"
            workData = workData.replacingOccurrences(of: "},\n]},", with: "}\n]},")
            dataString += workData
        }
        dataString += "]}"
        dataString = dataString.replacingOccurrences(of: "]},]}", with: "]}]}")
        return dataString
    }
    
}
