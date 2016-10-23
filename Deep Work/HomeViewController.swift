//
//  HomeViewController.swift
//  Deep Work
//
//  Created by Austin Wood on 2016-10-11.
//  Copyright © 2016 Austin Wood. All rights reserved.
//

import UIKit
import CoreData
import MessageUI

class HomeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, MFMailComposeViewControllerDelegate {
    
    //////////////////////////////////////////////
    // MARK:- Count Records
    
    func countData() {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        delegate.checkDataStore()
        self.countTimeLogs()
    }
    
    func countTimeLogs() {
        print("* HomeViewController: countTimeLogs()")
        var x = 0
        for project in projects {
            let timeLogs = TimeLog.getTimeLogsForProjects(projects: [project], moc: moc!)
            let timeLogCount = timeLogs.count
            x += timeLogCount
            print("project: \(project.title!), timeLogs: \(timeLogCount)")
        }
        print("timeLogs belonging to projects: \(x)")
        let allTimeLogs = TimeLog.getTimeLogs(searchPredicate: nil, moc: moc!)
        print("allTimeLogs: \(allTimeLogs.count)")
    }
    
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
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    //////////////////////////////////////////////
    // MARK:- Gesture Recognizers
    
    func addGestureRecognizers() {
        
        // For recognizing taps on views at top of VC
        let dayRecognizer = UITapGestureRecognizer(target: self, action: #selector(dayPressed(_:)))
        dayView.addGestureRecognizer(dayRecognizer)
        let weekRecognizer = UITapGestureRecognizer(target: self, action: #selector(weekPressed(_:)))
        weekView.addGestureRecognizer(weekRecognizer)
        
        // Long press recognizer for rearranging collection view cells
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        longPressGesture.minimumPressDuration = 0.3
        self.collectionView.addGestureRecognizer(longPressGesture)
        
        // Single and double tap recognizers for collection view cells
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(self.didSingleTap))
        singleTap.numberOfTapsRequired = 1
        self.collectionView!.addGestureRecognizer(singleTap)
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(self.didDoubleTap))
        doubleTap.numberOfTapsRequired = 2
        self.collectionView!.addGestureRecognizer(doubleTap)
        singleTap.require(toFail: doubleTap)
    }
    
    func didSingleTap(_ gesture: UITapGestureRecognizer) {
        if validateTap(gestureLocation: gesture.location(in: self.collectionView!)) {
            startStopTimer(project: selectedProject!)
        }
    }
    
    func didDoubleTap(_ gesture: UITapGestureRecognizer) {
        if validateTap(gestureLocation: gesture.location(in: self.collectionView!)) {
            performSegue(withIdentifier: "goToHistory", sender: self)
        }
    }
    
    var selectedProject: Project?
    
    func validateTap(gestureLocation: CGPoint) -> Bool {
        if let selectedIndexPath = self.collectionView!.indexPathForItem(at: gestureLocation) {
            selectedProject = projects[selectedIndexPath.row]
            return true
        }
        return false
    }
    
    var oldIndex = IndexPath()
    var lastIndex = IndexPath()
    
    func handleLongPress(gesture: UILongPressGestureRecognizer) {
        if validateTap(gestureLocation: gesture.location(in: self.collectionView!)) {
            switch(gesture.state) {
            case UIGestureRecognizerState.began:
                guard let selectedIndexPath = self.collectionView.indexPathForItem(at: gesture.location(in: self.collectionView))
                    else { break }
                oldIndex = selectedIndexPath
                collectionView.beginInteractiveMovementForItem(at: selectedIndexPath)
                let selectedCell = self.collectionView.cellForItem(at: selectedIndexPath) as! ProjectCell
                selectedCell.circleView.backgroundColor = CustomColor.blueGreen
            case UIGestureRecognizerState.changed:
                collectionView.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view!))
                if let currentIndexPath = self.collectionView.indexPathForItem(at: gesture.location(in: self.collectionView)) {
                    lastIndex = currentIndexPath
                } else { break }
            case UIGestureRecognizerState.ended:
                let element = projects.remove(at: oldIndex.row)
                if let newIndex = self.collectionView.indexPathForItem(at: gesture.location(in: self.collectionView)) {
                    projects.insert(element, at: newIndex.row)
                } else {
                    projects.insert(element, at: lastIndex.row)
                }
                updateProjectOrder()
                collectionView.endInteractiveMovement()
            default:
                collectionView.cancelInteractiveMovement()
            }
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
    
    // DRY !!!
    // I could combine dayPressed and weekPressed by adding tags to the views
    // This will be especially useful if I want to add a month and year view
    
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
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        // Logic for moving cells in handleLongPress()
    }
    
    //////////////////////////////////////////////
    // MARK:- Alerts and Menus
    
    @IBAction func addPressed(_ sender: AnyObject) {
        let alertController = UIAlertController(title: "Add Project", message: "Enter a title:", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addTextField { (textField: UITextField) in
            textField.autocapitalizationType = .words
        }
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
    
    func addNote(timeLog: TimeLog) {
        let sessionLength = Date().timeIntervalSince(timeLog.startTime!)
        let sessionLengthFormatted = FormatTime.formattedHoursMinutes(timeInterval: sessionLength)
        let project = timeLog.project
        let alertController = UIAlertController(title: "\(project!.title!)\n\n\(sessionLengthFormatted)", message: "\nGreat work!\n\nYou may add a note if you wish.", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addTextField { (textField: UITextField) in
            textField.autocapitalizationType = .sentences
        }
        let deleteAction = UIAlertAction(title: "Delete entry", style: .destructive) { [weak self] (action: UIAlertAction) in
            self?.warningDeleteEntry(timeLog: timeLog)
        }
        let cancelAction = UIAlertAction(title: "Continue working", style: .default) { (action: UIAlertAction) in
            timeLog.stopTime = nil
            self.checkForRunningTimers()
        }
        let saveAction = UIAlertAction(title: "Save entry", style: .default) { [weak self] (action: UIAlertAction) in
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
                let request: NSFetchRequest<TimeLog> = NSFetchRequest(entityName: "TimeLog")
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
        let deleteButton = UIAlertAction(title: "Delete records", style: .destructive, handler: { (action) -> Void in
            self.deleteRecords()
        })
        let countButton = UIAlertAction(title: "Count data", style: .default, handler: { (action) -> Void in
            self.countData()
        })
        let exportButton = UIAlertAction(title: "Export data as JSON", style: .default, handler: { (action) -> Void in
            self.emailData()
        })
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in })
        alertController.addAction(deleteButton)
        alertController.addAction(countButton)
        alertController.addAction(exportButton)
        alertController.addAction(cancelButton)
        self.present(alertController, animated: true, completion: nil)
    }

    //////////////////////////////////////////////
    // MARK:- Start / Stop time log

    func startStopTimer(project: Project) {
        let currentEntry = TimeLog.getCurrentEntry(project: project, moc: moc!)
        if currentEntry != nil {
            currentEntry?.stopTime = Date()
            timer.invalidate()
            updateTimeLabels()
            addNote(timeLog: currentEntry!)
        } else if !timerRunning {
            // Start a new time log
            let newTimeLog = TimeLog(context: (self.moc)!)
            newTimeLog.project = project
            newTimeLog.workDay = FormatTime.dateISO(date: Date())
            newTimeLog.startTime = Date()
            do { try self.moc?.save() }
            catch { fatalError("Error storing data") }
            self.loadData()
        } else {
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
            let currentEntry = TimeLog.getCurrentEntry(project: project, moc: moc!)
            if currentEntry != nil{
                timerRunning = true
                lastStartTime = TimeLog.getCurrentEntry(project: project, moc: moc!)?.startTime
                timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.updateTimeLabels), userInfo: nil, repeats: true)
            }
        }
    }
    
    //////////////////////////////////////////////
    // MARK:- Calculate Daily and Weekly Totals
    
    func updateTimeLabels() {
        // Update the time in each collection view cell
        collectionView.reloadData()
        
        // Update the time of 'Today' and 'This week' labels
        let todayTime = TimeLog.todayTime(projects: projects, moc: moc!)
        let todayFormatted = FormatTime.formattedHoursMinutes(timeInterval: todayTime)
        todayLabel.text = todayFormatted
        let weekTime = TimeLog.weekTime(projects: projects, moc: moc!)
        let weekFormatted = FormatTime.formattedHoursMinutes(timeInterval: weekTime)
        weekLabel.text = weekFormatted
        
        
        let monthTime = TimeLog.monthTime(projects: projects, moc: moc!)
        let monthFormatted = FormatTime.formattedHoursMinutes(timeInterval: monthTime)
        print("Total for month: \(monthFormatted)")
        
        
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
    
    func deleteRecords() {
        let alertController = UIAlertController(title: "Warning!", message: "This action will delete all data associated with this app and replace it with the contents of 'sampleData.json'\n\nAre you sure you want to continue?", preferredStyle: .actionSheet)
        let continueButton = UIAlertAction(title: "Yes, delete my data", style: .destructive, handler: { (action) -> Void in
            self.proceedWithDeleteRecords()
        })
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in
            // Do nothing
        })
        alertController.addAction(continueButton)
        alertController.addAction(cancelButton)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func proceedWithDeleteRecords() {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        delegate.checkDataStore()
        delegate.deleteRecords()
        delegate.checkDataStore()
        loadData()
    }
    
    //////////////////////////////////////////////
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToHistory" {
            let destinationController = segue.destination as! HistoryViewController
            destinationController.project = selectedProject!
            destinationController.moc = moc
        }
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
    
    // DRY: Combine with warning for deleting all entries, for deleting entry after having stopped timer, etc
    func warningRunningTimer() {
        let alertController = UIAlertController(title: "Warning!", message: "A timer is currently running. Data with incomplete entries can lead to irregular results when later imported back into the app. It is recommended that you only use the export feature after having stopped all timers.\n\nAre you sure you want to export data now?", preferredStyle: .actionSheet)
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
        var exportDataStr = "{\"project\": [\n\n"
        for project in projects {
            exportDataStr += "{\n" + "\"title\":\"" + project.title! + "\",\n"
            exportDataStr += "\"order\":" + "\(project.order)" + ",\n"
            exportDataStr += "\"color\":\"" + "" + "\",\n" // project.color!
            exportDataStr += "\"timeLog\": [\n\n"
            let projectTimeLogs = TimeLog.getTimeLogsForProjects(projects: [project], moc: moc!).sorted(by: { $0.startTime! < $1.startTime! })
            var timeLogDataStr = ""
            for timeLog in projectTimeLogs {
                timeLogDataStr += "{\n" + "\"workDay\":\"" + timeLog.workDay! + "\",\n"
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                let startTime = timeLog.startTime
                let startTimeStr = dateFormatter.string(from: startTime!)
                timeLogDataStr += "\"startTime\":\"" + startTimeStr + "\",\n"
                if let stopTime = timeLog.stopTime {
                    let stopTimeStr = dateFormatter.string(from: stopTime)
                    timeLogDataStr += "\"stopTime\":\"" + stopTimeStr + "\",\n"
                } else {
                    timeLogDataStr += "\"stopTime\":\"" + "" + "\",\n"
                }
                if let note = timeLog.note {
                    timeLogDataStr += "\"note\":\"" + note + "\"},\n"
                } else {
                    timeLogDataStr += "\"note\":\"" + "" + "\"},\n"
                }
            }
            timeLogDataStr += "]},"
            timeLogDataStr = timeLogDataStr.replacingOccurrences(of: "},\n]},", with: "}\n]},")
            exportDataStr += timeLogDataStr
        }
        exportDataStr += "]}"
        exportDataStr = exportDataStr.replacingOccurrences(of: "]},]}", with: "]}]}")
        return exportDataStr
    }
    
}
