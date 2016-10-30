//
//  HistoryViewController.swift
//  Deep Work
//
//  Created by Austin Wood on 2016-10-20.
//  Copyright © 2016 Austin Wood. All rights reserved.
//

////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
//////// PRE-NSFETCHED RESULTS CONTROLLER IMPLEMENTATION
////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////

//import UIKit
//import CoreData
//
//class HistoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
//    
//    //////////////////////////////////////////////
//    // MARK:- Properties
//    
//    var moc: NSManagedObjectContext?
//    var project: Project?
//    var timeLogArray: [TimeLog] = []
//    var timeLogNestedArray: [[TimeLog]] = []
//    var cellInitializerArray: [Int] = []
//    var colorArray: [UIColor] = []
//    let color1 = UIColor.black
//    let color2 = CustomColor.blueDark
//    
//    //////////////////////////////////////////////
//    // MARK:- Outlets
//    
//    @IBOutlet weak var titleLabel: UILabel!
//    @IBOutlet weak var tableView: UITableView!
//    
//    //////////////////////////////////////////////
//    // MARK:- Initialization
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        intializeTimeLogs()
//        setupViewController()
//        setupTableView()
//    }
//    
//    func setupViewController() {
//        titleLabel.text = project?.title
//    }
//    
//    func intializeTimeLogs() {
//        
//        timeLogArray = []
//        timeLogNestedArray = []
//        cellInitializerArray = []
//        colorArray = []
//        
//        // Create an array of all TimeLog entries for the selected project and sort it
//        timeLogArray = TimeLog.getTimeLog(project: project!, moc: moc!)
//        timeLogArray.sort(by: { $0.startTime! < $1.startTime! })
//        
//        // Created an array of arrays of TimeLog entries, grouping them by date
//        for entry in timeLogArray {
//            let currentFormmattedDate = FormatTime().formattedDate(date: entry.startTime!)
//            var foundMatch = false
//            var i = 0
//            while i < timeLogNestedArray.count && !foundMatch {
//                let entryArray = timeLogNestedArray[i]
//                let existingFormmattedDate = FormatTime().formattedDate(date: entryArray[0].startTime!)
//                if currentFormmattedDate == existingFormmattedDate {
//                    timeLogNestedArray[i].append(entry)
//                    foundMatch = true
//                }
//                i += 1
//            }
//            if !foundMatch {
//                timeLogNestedArray.append([entry])
//            }
//        }
//        
//        // Create cellInitializerArray, which is used by tableView's cellForRowAtIndexPath for configuring cells
//        // Each element's position in the array corresponds to a cell's indexPath
//        var x = 0
//        var y = 0
//        while x < timeLogNestedArray.count {
//            // Negative values indicate a DateCell and their corresponding position in timeLogNestedArray
//            cellInitializerArray.append(-(x+1))
//            createColorArray(x: x)
//            for _ in timeLogNestedArray[x] {
//                // Positive values indicate a time log HistoryCell and their corresponding position in timeLogArray
//                cellInitializerArray.append(y)
//                createColorArray(x: x)
//                y += 1
//            }
//            x += 1
//        }
//        
//        print(cellInitializerArray)
//    }
//    
//    // colorArray is used by tableView's cellForRowAtIndexPath for determining the background color of the cell
//    func createColorArray(x: Int) {
//        if x % 2 == 0 {
//            colorArray.append(color2)
//        } else {
//            colorArray.append(color1)
//        }
//    }
//    
//    //////////////////////////////////////////////
//    // MARK:- Table View
//    
//    var timer = Timer()
//    
//    func setupTableView() { // Called on viewDidLoad
//        tableView.rowHeight = UITableViewAutomaticDimension
//        tableView.estimatedRowHeight = 75
//        tableView.separatorColor = UIColor.clear
//        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.scrollToBottom), userInfo: nil, repeats: false)
//    }
//    
//    func scrollToBottom() {
//        let stopIndexPath = IndexPath(row: cellInitializerArray.count - 1, section: 0)
//        tableView.scrollToRow(at: stopIndexPath, at: .bottom, animated: true)
//    }
//    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let blackView = UIView()
//        blackView.backgroundColor = UIColor.clear
//        return blackView
//    }
//    
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        // This should be the same as Visual Effects View which contains the back button and project title
//        return 76 as CGFloat
//    }
//    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return timeLogArray.count + timeLogNestedArray.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
//    }
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
//    
//}
