//
//  HistoryViewController.swift
//  Deep Work
//
//  Created by Austin Wood on 2016-10-20.
//  Copyright © 2016 Austin Wood. All rights reserved.
//

import UIKit
import CoreData

class HistoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
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
        //intializeTimeLogs()
    }
    
    private func loadData() {
        fetchedResultsController = DataService.fetchTimeLogs(project: project!, moc: moc!)
    }
    
    func setupViewController() {
        titleLabel.text = project?.title
    }
    
    // ************************************************
    // ************************************************
    // ****************** TABLE VIEW ******************
    // ************************************************
    // ************************************************
    
    //////////////////////////////////////////////
    // MARK:- Table View Initialization
    
    var timer = Timer()
    
    func setupTableView() { // Called on viewDidLoad
        
        // Give tableView a header same size as Visual Effects View which contains back button and project title
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 76))
        headerView.backgroundColor = UIColor.clear
        tableView.tableHeaderView = headerView
        
        // Miscellaneous tableView setup
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
    // MARK:- Table View Section Headers
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50 as CGFloat
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = TableViewHeaderLabel()
        if let sections = fetchedResultsController.sections {
            let currentSection = sections[section]
            let firstObject = currentSection.objects?.first as! TimeLog
            let workDay = firstObject.workDay! as WorkDay
            let fullDateStr = FormatTime.dateISOtoFull(isoStr: workDay.workDay!)
            label.text = fullDateStr
        }
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
        
        //////////////////////////////////////////////
        // Old code:
//        var cell = UITableViewCell()
//        // Confifure DateCell
//        if cellInitializerArray[indexPath.row] < 0 {
//            let dateCell = tableView.dequeueReusableCell(withIdentifier: "dateCell", for: indexPath) as! DateCell
//            let entry = timeLogNestedArray[-(cellInitializerArray[indexPath.row] + 1)][0]
//            let formattedDate = FormatTime().formattedDate(date: entry.startTime!)
//            dateCell.dateLabel.text = formattedDate
//            cell = dateCell
//            // Confifure HistoryCell
//        } else {
//            let historyCell = tableView.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath) as! HistoryCell
//            let entry = (timeLogArray[cellInitializerArray[indexPath.row]]) as TimeLog
//            historyCell.configureCell(entry: entry, moc: moc!)
//            cell = historyCell
//        }
//        // Applicable to both types of cells
//        cell.selectionStyle = .none
//        cell.backgroundColor = colorArray[indexPath.row]
//        return cell
        
        //////////////////////////////////////////////
        // New code:
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath) as! HistoryCell
        let timeLog = fetchedResultsController.object(at: indexPath)
        cell.configureCell(entry: timeLog, moc: moc!)
        return cell
    }
    
    //////////////////////////////////////////////
    //////////////////////////////////////////////
    //////////////////////////////////////////////
    // MARK:- below this line -- OLD CODE
    //////////////////////////////////////////////
    //////////////////////////////////////////////
    //////////////////////////////////////////////
    
    //////////////////////////////////////////////
    // MARK:- Old Table View
//    
//    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        
//        // No edit actions for dateCell
//        if cellInitializerArray[indexPath.row] < 0 {
//            return false
//        }
//        
//        // No edit actions for entry if inProgress
//        let entry = (timeLogArray[cellInitializerArray[indexPath.row]]) as TimeLog
//        if entry.stopTime == nil {
//            return false
//        }
//        
//        return true
//    }
//
//    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
//        
//        print((timeLogArray.count + timeLogNestedArray.count - 1))
//        print(indexPath.row)
//        
//        let entry = (timeLogArray[cellInitializerArray[indexPath.row]]) as TimeLog
//        
//        // Delete Button
//        let deleteButton = UITableViewRowAction(style: .default, title: "Delete") { (action: UITableViewRowAction!, indexPath: IndexPath!) -> Void in
//            let confirmDeleteAlertController = UIAlertController(title: "Delete Entry", message: "Are you sure you would like to delete this entry?", preferredStyle: .actionSheet)
//            let deleteAction = UIAlertAction(title: "Delete", style: .default, handler: { [weak self] (action: UIAlertAction) in
//                self?.moc?.delete(entry)
//                do {
//                    try self?.moc?.save()
//                    var rowsToDelete = [indexPath]
//                    if (self?.cellInitializerArray[indexPath.row - 1])! < 0 {
//                        let nestedIndex = -((self?.cellInitializerArray[indexPath.row - 1])! + 1)
//                        if (self?.timeLogNestedArray[nestedIndex].count)! == 1 {
//                            let previousIndexPath = IndexPath(row: (indexPath.row - 1), section: 0)
//                            rowsToDelete = [previousIndexPath, indexPath]
//                        }
//                    }
//                    self?.intializeTimeLogs()
//                    tableView.deleteRows(at: rowsToDelete as! [IndexPath], with: .fade)
//                }
//                catch { fatalError("Error storing data") }
//                })
//            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction) in
//                
//                tableView.isEditing = false
//            })
//            confirmDeleteAlertController.addAction(deleteAction)
//            confirmDeleteAlertController.addAction(cancelAction)
//            self.present(confirmDeleteAlertController, animated: true, completion: nil)
//        }
//        
//        deleteButton.backgroundColor = CustomColor.red
//        
//        return [deleteButton]
//    }
    
}
