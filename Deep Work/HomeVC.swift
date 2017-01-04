//
//  HomeVC.swift
//  Deep Work
//
//  Created by Austin Wood on 2016-10-25.
//  Copyright © 2016 Austin Wood. All rights reserved.
//

import UIKit
import CoreData
import MessageUI

class HomeVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, MFMailComposeViewControllerDelegate {
    
    //////////////////////////////////////////////
    // MARK:- Properties
    
    let moc: NSManagedObjectContext? = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var projects = [Project]()
    
    //////////////////////////////////////////////
    // MARK:- Outlets
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var summaryCV: UICollectionView!
    @IBOutlet weak var projectCV: UICollectionView!
    @IBOutlet weak var bottomView: UIView!
    
    //////////////////////////////////////////////
    // MARK:- Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addGestureRecognizers()
        setupView()
        loadUserDefaults()
        setupSummaryCV()
        setupProjectCV()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadData()
        self.navigationController?.isNavigationBarHidden = true
//        addGrayBorders()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        addColoredBorders()
        projectCV.reloadData()
    }
    
    //var x = 0
    override func viewDidLayoutSubviews() {
        //print("update labels: \(x)")
        //x += 1
        let cells = projectCV.visibleCells
        print("visible cell count: \(cells.count)")
        let visibleCells = cells as! [ProjectCell]
        for cell in visibleCells {
            //let index = projectCV.indexPath(for: cell)!.row
            //let visibleProject = projects[index]
            //cell.sliderPast.setLabelText(text: "\(x)")
//            visibleStr += "\(cell.currentRow!) "
//            cell.updateLabels()
            //cell.configureCell(rowNumber: cell.currentRow!, currentSmokeSession: smokeSession!)
            let circleWidth = cell.circleView.frame.width
            let circleHeight = cell.circleView.frame.height
            print("width: \(circleWidth), height: \(circleHeight)")
            cell.layoutCell()
        }
        //print("visible cells: \(visibleStr)")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        removeColoredBorders()
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    func setupView() {
        topView.addBorder(edges: [.bottom])
        bottomView.addBorder(edges: [.top])
    }
    
    func loadUserDefaults() {
        let defaults = UserDefaults.standard
        let savedDateRange = defaults.integer(forKey: "dateRange")
        dateRange = MyDateRange(rawValue: savedDateRange)!
    }
    
    //////////////////////////////////////////////
    // MARK:- Gesture Recognizers
    
    func addGestureRecognizers() {
        
        // Long press recognizer for rearranging project cells
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        longPressGesture.minimumPressDuration = 0.3
        self.projectCV.addGestureRecognizer(longPressGesture)
        
        // Single and double tap recognizers for project cells
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(self.didSingleTap))
        singleTap.numberOfTapsRequired = 1
        self.projectCV!.addGestureRecognizer(singleTap)
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(self.didDoubleTap))
        doubleTap.numberOfTapsRequired = 2
        self.projectCV!.addGestureRecognizer(doubleTap)
        singleTap.require(toFail: doubleTap)
    }
    
    func didSingleTap(_ gesture: UITapGestureRecognizer) {
        if validateTap(gestureLocation: gesture.location(in: self.projectCV!)) {
            startStopTimer(project: selectedProject!)
        }
    }
    
    func didDoubleTap(_ gesture: UITapGestureRecognizer) {
        if validateTap(gestureLocation: gesture.location(in: self.projectCV!)) {
            performSegue(withIdentifier: "goToHistory", sender: self)
        }
    }
    
    var selectedProject: Project?
    
    func validateTap(gestureLocation: CGPoint) -> Bool {
        if let selectedIndexPath = self.projectCV!.indexPathForItem(at: gestureLocation) {
            selectedProject = projects[selectedIndexPath.row]
            return true
        }
        return false
    }
    
    var oldIndex = IndexPath()
    var lastIndex = IndexPath()
    
    func handleLongPress(gesture: UILongPressGestureRecognizer) {
        if validateTap(gestureLocation: gesture.location(in: self.projectCV!)) {
            switch(gesture.state) {
            case UIGestureRecognizerState.began:
                guard let selectedIndexPath = self.projectCV.indexPathForItem(at: gesture.location(in: self.projectCV))
                    else { break }
                oldIndex = selectedIndexPath
                projectCV.beginInteractiveMovementForItem(at: selectedIndexPath)
                let selectedCell = self.projectCV.cellForItem(at: selectedIndexPath) as! ProjectCell
                selectedCell.circleView.backgroundColor = CustomColor.blueLight
            case UIGestureRecognizerState.changed:
                projectCV.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view!))
                if let currentIndexPath = self.projectCV.indexPathForItem(at: gesture.location(in: self.projectCV)) {
                    lastIndex = currentIndexPath
                } else { break }
            case UIGestureRecognizerState.ended:
                let element = projects.remove(at: oldIndex.row)
                if let newIndex = self.projectCV.indexPathForItem(at: gesture.location(in: self.projectCV)) {
                    projects.insert(element, at: newIndex.row)
                } else {
                    projects.insert(element, at: lastIndex.row)
                }
                updateProjectOrder()
                projectCV.endInteractiveMovement()
            default:
                projectCV.cancelInteractiveMovement()
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
    
    //////////////////////////////////////////////
    // MARK:- Collection View setup
    
    @IBOutlet weak var summaryCVHeight: NSLayoutConstraint!
    
    func setupSummaryCV() {
        summaryCV.layoutIfNeeded()
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let cellSpacing: CGFloat = 10
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let collectionViewWidth = summaryCV.frame.width
        let cellWidth = (collectionViewWidth - (cellSpacing * 4)) / 5
        let cellHeight = cellWidth + 36
        layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        layout.minimumInteritemSpacing = cellSpacing
        layout.minimumLineSpacing = cellSpacing
        summaryCV.collectionViewLayout = layout
        summaryCVHeight.constant = cellHeight
        summaryCV.reloadData()
    }
    
    func addGrayBorders() {
        var i = 0
        while i <= 4 {
            let indexPath = IndexPath(row: i, section: 0)
            let cell = summaryCV.cellForItem(at: indexPath) as! SummaryCell
            cell.circleView.drawGrayBorder()
            i += 1
        }
    }
    
    func addColoredBorders() {
        var i = 0
        while i <= 4 {
            let indexPath = IndexPath(row: i, section: 0)
            let cell = summaryCV.cellForItem(at: indexPath) as! SummaryCell
            cell.addBorder(indexPath: i)
            i += 1
        }
    }
    
    func removeColoredBorders() {
        var i = 0
        while i <= 4 {
            let indexPath = IndexPath(row: i, section: 0)
            let cell = summaryCV.cellForItem(at: indexPath) as! SummaryCell
            cell.circleView.removeBorders()
            i += 1
        }
    }
    
//    var visibleProjects = [Project]()
//    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        if scrollView == projectCV {
//            print("we scrolling")
//            initiateVisibleProjects()
//        }
//    }
//    
//    func initiateVisibleProjects() {
//        var newVisibleProjects = [Project]()
//        let cells = projectCV.visibleCells
//        let visibleCells = cells as! [ProjectCell]
//        for cell in visibleCells {
//            let index = projectCV.indexPath(for: cell)!.row
//            let visibleProject = projects[index]
//            if !visibleProjects.contains(visibleProject) {
//                cell.circleView.drawBorder(fillPercent: 1.0)
//            }
//            newVisibleProjects.append(visibleProject)
//        }
//        visibleProjects = newVisibleProjects
//    }
//    
//    var drawBorders = false
//    
//    func setupProjectCells() {
//        initiateVisibleProjects()
//        drawBorders = true
//        projectCV.reloadData()
////        for cell in projectCV.visibleCells {
////            let projectCell = cell as! ProjectCell
////            let index = projectCV.indexPath(for: cell)!.row
////            projectCell.circleView.drawBorder(fillPercent: 1.0)
////        }
////        drawBorders = true
//    }
    
    func setupProjectCV() {
        topView.layoutIfNeeded()
        bottomView.layoutIfNeeded()
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let topInset = topView.frame.height + 10
        let bottomInset = bottomView.frame.height + 10
        let leftRightInset: CGFloat = 18
        layout.sectionInset = UIEdgeInsets(top: topInset, left: leftRightInset, bottom: bottomInset, right: leftRightInset)
        
        let collectionViewWidth = projectCV.frame.width - (leftRightInset * 2)
        let cellSpacing: CGFloat = 0
        let numberOfColumns: CGFloat = 3
        let cellWidth = (collectionViewWidth - (cellSpacing * (numberOfColumns - 1))) / numberOfColumns
        let cellHeight = cellWidth + 48
        
        layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        layout.minimumInteritemSpacing = cellSpacing
        layout.minimumLineSpacing = cellSpacing
        projectCV.collectionViewLayout = layout
        projectCV.backgroundColor = CustomColor.dark2
    }
    
    //////////////////////////////////////////////
    // MARK:- Collection View required methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Summary collection view
        if collectionView.tag == 0 {
            return 5
        }
        // Project collection view
        return projects.count
    }
    
    var loadBorders = true
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Summary collection view
        if collectionView.tag == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "summaryCell", for: indexPath) as! SummaryCell
            cell.configureCell(indexPath: indexPath.row, projects: projects, moc: moc!)
            return cell
        }
        // Project collection view
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "projectCell", for: indexPath) as! ProjectCell
        let currentProject = projects[indexPath.row]
        cell.configureCell(project: currentProject, moc: moc!)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        // Logic for moving cells in handleLongPress()
    }
    
    //////////////////////////////////////////////
    // MARK:- Start / Stop time log
    
    func startStopTimer(project: Project) {
        let currentEntry = TimeLog.getCurrentEntry(project: project, moc: moc!)
        if currentEntry != nil {
            // Stop the timer for the current time log
            currentEntry?.stopTime = Date()
            timer.invalidate()
            updateTimeLabels()
            addNote(timeLog: currentEntry!)
        } else if !timerRunning {
            // Start a new time log
            let newTimeLog = TimeLog(context: (self.moc)!)
            newTimeLog.project = project
            newTimeLog.workDay = CustomDateFormatter.dateISO(date: Date())
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
    // MARK:- Update time labels
    
    var dateRange: MyDateRange = .today
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.tag == 0 {
            dateRange = MyDateRange(rawValue: indexPath.row)!
            print("\(dateRange)")
            let defaults = UserDefaults.standard
            defaults.set(indexPath.row, forKey: "dateRange")
            updateSummaryColors()
            updateTimeLabels()
        }
    }
    
    func updateTimeLabels() {
        updateProjectLabels()
        updateSummaryColors()
        updateSummaryLabels()
    }
    
    func updateSummaryLabels() {
        var i = 0
        // Refactor: this is bad code, as I have to update each instance manually when summaryCV number of cells changes
        while i <= 4 {
            let indexPath = IndexPath(row: i, section: 0)
            let cell = summaryCV.cellForItem(at: indexPath) as! SummaryCell
            cell.updateTimeLabel(indexPath: i, projects: projects, moc: moc!)
            i += 1
        }
    }
    
    func updateSummaryColors() {
        var i = 0
        while i <= 4 {
            let indexPath = IndexPath(row: i, section: 0)
            let cell = summaryCV.cellForItem(at: indexPath) as! SummaryCell
            cell.updateBackgroundColor(indexPath: i)
            i += 1
        }
    }
    
    func updateProjectLabels() {
        if projects.count == 0 { return }
        for cell in projectCV.visibleCells {
            let projectCell = cell as! ProjectCell
            let index = projectCV.indexPath(for: cell)!.row
            let project = projects[index]
            projectCell.updateTimeLabels(project: project, moc: moc!)
        }
    }
    
    //////////////////////////////////////////////
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToHistory" {
            let destinationController = segue.destination as! HistoryVC
            destinationController.project = selectedProject!
            destinationController.moc = moc
        }
    }
    
    //////////////////////////////////////////////
    // MARK:- Alerts and Menus
    
    @IBAction func addPressed(_ sender: AnyObject) {
        let alertController = UIAlertController(title: "Add Project", message: "Enter a title:", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addTextField { (textField: UITextField) in
            textField.autocapitalizationType = .words
            textField.autocorrectionType = .yes
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
        let sessionLengthFormatted = CustomDateFormatter.formattedHoursMinutes(timeInterval: sessionLength)
        let project = timeLog.project
        let alertController = UIAlertController(title: "\(project!.title!)\n\n\(sessionLengthFormatted)", message: "\nGreat work!\n\nYou may add a note if you wish.", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addTextField { (textField: UITextField) in
            textField.autocapitalizationType = .sentences
            textField.autocorrectionType = .yes
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
    // MARK:- Data Management
    
    func loadData() {
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
    // MARK:- JSON Exporter
    
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
