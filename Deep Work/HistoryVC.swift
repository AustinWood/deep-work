//
//  HistoryViewController.swift
//  Deep Work
//
//  Created by Austin Wood on 2016-10-20.
//  Copyright © 2016 Austin Wood. All rights reserved.
//

import UIKit
import CoreData

class HistoryVC: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {
    
    //////////////////////////////////////////////
    // MARK:- Properties
    
    var moc: NSManagedObjectContext?
    var project: Project?
    var fetchedResultsController: NSFetchedResultsController<TimeLog>!
    
    //////////////////////////////////////////////
    // MARK:- Outlets
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    //////////////////////////////////////////////
    // MARK:- Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        setupViewController()
        setupTableView()
    }
    
    private func loadData() {
        fetchedResultsController = DataService.fetchTimeLogs(project: project!, moc: moc!)
        fetchedResultsController.delegate = self
    }
    
    func setupViewController() {
        self.title = project?.title
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editTitle))
        self.view.backgroundColor = CustomColor.dark2
    }
    
    //////////////////////////////////////////////
    // MARK:- Table View Initialization
    
    var timer = Timer()
    
    func setupTableView() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 75
        tableView.separatorColor = UIColor.clear
        
        // Without a short delay, scrollToBottom() is called before the data is loaded
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.scrollToBottom), userInfo: nil, repeats: false)
    }
    
    func scrollToBottom() {
        timer.invalidate()
        var lastSection = 0
        var lastRow = 0
        if let sections = fetchedResultsController.sections {
            lastSection = sections.count - 1
            lastRow = sections[lastSection].numberOfObjects - 1
        }
        let lastIndex = IndexPath(row: lastRow, section: lastSection)
        tableView.scrollToRow(at: lastIndex, at: .bottom, animated: true)
    }
    
    //////////////////////////////////////////////
    // MARK:- Edit Project Title
    
    func editTitle() {
        let alertController = UIAlertController(title: "Edit Project Title", message: "Enter a new title for \(project!.title!):", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addTextField { (textField: UITextField) in
            textField.autocapitalizationType = .words
            textField.autocorrectionType = .yes
        }
        let saveAction = UIAlertAction(title: "Save", style: .default) { [weak self] (action: UIAlertAction) in
            let projectTitle: String?
            if alertController.textFields?.first?.text != "" {
                projectTitle = alertController.textFields?.first?.text
            } else { return }
            self?.project?.title = projectTitle
            do { try self?.moc?.save() }
            catch { fatalError("Error storing data") }
            self?.setupViewController()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)
        present(alertController, animated: true, completion: nil)
    }
    
    //////////////////////////////////////////////
    // MARK:- Table View Section Headers
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50 as CGFloat
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = TableViewHeaderLabel()
        if let sections = fetchedResultsController.sections {
            let currentSection = sections[section]
            let firstObject = currentSection.objects?.first as! TimeLog
            let workDayStr = firstObject.workDay
            let fullDateStr = CustomDateFormatter.dateISOtoFull(isoStr: workDayStr!)
            label.text = fullDateStr
        }
        // Would like to make use of the TableViewHeaderLabel.addBlur(), but can't get the text and blur to work together
        label.backgroundColor = CustomColor.dark1
        return label
    }
    
    //////////////////////////////////////////////
    // MARK:- Table View Required Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if let sections = fetchedResultsController.sections {
            return sections.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchedResultsController.sections {
            let currentSection = sections[section]
            return currentSection.numberOfObjects
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath) as! HistoryCell
        cell.selectionStyle = .none
        let timeLog = fetchedResultsController.object(at: indexPath)
        cell.configureCell(entry: timeLog, moc: moc!)
        return cell
    }
    
    //////////////////////////////////////////////
    // MARK:- Swipe to Edit / Delete Row
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // No edit actions for entry if in progress
        let timeLog = fetchedResultsController.object(at: indexPath)
        if timeLog.stopTime == nil {
            return false
        }
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let timeLog = self.fetchedResultsController.object(at: indexPath)
        let editButton = UITableViewRowAction(style: .default, title: "Edit     ") { (action: UITableViewRowAction!, indexPath: IndexPath!) -> Void in
            self.editNote(timeLog: timeLog)
        }
        editButton.backgroundColor = CustomColor.green
        let deleteButton = UITableViewRowAction(style: .default, title: "Delete") { (action: UITableViewRowAction!, indexPath: IndexPath!) -> Void in
            self.deleteTimeLog(timeLog: timeLog)
        }
        deleteButton.backgroundColor = CustomColor.pinkHot
        return [editButton, deleteButton]
    }
    
    //////////////////////////////////////////////
    // MARK:- Edit Note
    
    func editNote(timeLog: TimeLog) {
        let alertController = UIAlertController(title: "Edit Note", message: "", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addTextField { (textField: UITextField) in
            textField.autocapitalizationType = .sentences
            textField.autocorrectionType = .yes
            textField.text = timeLog.note
        }
        let saveAction = UIAlertAction(title: "Save", style: .default) { [weak self] (action: UIAlertAction) in
            let newNote = alertController.textFields?.first?.text
            timeLog.note = newNote
            do { try self?.moc?.save() }
            catch { fatalError("Error storing data") }
            self?.tableView.reloadData()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)
        present(alertController, animated: true, completion: nil)
    }
    
    //////////////////////////////////////////////
    // MARK:- Delete Row
    
    func deleteTimeLog(timeLog: TimeLog) {
        let confirmDeleteAlertController = UIAlertController(title: "Delete Entry", message: "Are you sure you would like to delete this entry?", preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: "Delete", style: .default, handler: { [weak self] (action: UIAlertAction) in
            self?.moc?.delete(timeLog)
            let delegate = UIApplication.shared.delegate as! AppDelegate
            delegate.saveContext()
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction) in self.tableView.isEditing = false })
        confirmDeleteAlertController.addAction(deleteAction)
        confirmDeleteAlertController.addAction(cancelAction)
        self.present(confirmDeleteAlertController, animated: true, completion: nil)
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        if type == NSFetchedResultsChangeType.delete {
            tableView.deleteSections([sectionIndex], with: .fade)
            self.view.makeToast(message: "Deletion successful!")
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        if type == NSFetchedResultsChangeType.delete {
            tableView.deleteRows(at: [indexPath!], with: UITableViewRowAnimation.fade)
            self.view.makeToast(message: "Deletion successful!")
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
}
