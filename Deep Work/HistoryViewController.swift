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
    
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 50 as CGFloat
//    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let label = TableViewHeaderLabel()
//        
//        
//        if let sections = fetchedResultsController.sections {
//            let currentSection = sections[section]
//            let firstObject = currentSection.objects?.first as! TimeLog
//            let workDay = firstObject.workDay! as WorkDay
//            let fullDateStr = FormatTime.dateISOtoFull(isoStr: workDay.workDay!)
//            label.text = fullDateStr
//        }
        
        
        
        let label = UILabel()
        
        label.backgroundColor = UIColor.black
        label.textColor = UIColor.white
        
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.text = "Here's to the crazy ones. The misfits. The rebels. The troublemakers. The round pegs in the square holes. The ones who see things differently. They're not fond of rules. And they have no respect for the status quo. You can quote them, disagree with them, glorify or vilify them. About the only thing you can't do is ignore them. Because they change things. They push the human race forward. And while some may see them as the crazy ones, we see genius. Because the people who are crazy enough to think they can change the world, are the ones who do."
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
    
//    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        
//        // No edit actions for entry if in progress
//        let timeLog = fetchedResultsController.object(at: indexPath)
//        if timeLog.stopTime == nil {
//            return false
//        }
//        
//        return true
//    }
//    
//    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
//        
//        let timeLog = fetchedResultsController.object(at: indexPath)
//        
//        // Delete Button
//        let deleteButton = UITableViewRowAction(style: .default, title: "Delete") { (action: UITableViewRowAction!, indexPath: IndexPath!) -> Void in
//            let confirmDeleteAlertController = UIAlertController(title: "Delete Entry", message: "Are you sure you would like to delete this entry?", preferredStyle: .actionSheet)
//            
//            let deleteAction = UIAlertAction(title: "Delete", style: .default, handler: { [weak self] (action: UIAlertAction) in
//                print("\n\n")
//                let sections = self?.fetchedResultsController.sections
//                print("number of sections: \(sections?.count)")
//                print("number of objects in current section: \(sections?[indexPath.section].numberOfObjects)")
//                
//                self?.moc?.delete(timeLog)
//                
//                do {
//                    try self?.moc?.save()
//                    
//                    print("number of sections: \(sections?.count)")
//                    print("number of objects in current section: \(sections?[indexPath.section].numberOfObjects)")
//                    
//                    self?.loadData()
//                    
//                    self?.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self?.reloadTableViewData), userInfo: nil, repeats: false)
//                    
//                    print("number of sections: \(sections?.count)")
//                    print("number of objects in current section: \(sections?[indexPath.section].numberOfObjects)")
//                    
////                    if let sections = self?.fetchedResultsController.sections {
////                        
////
////                        
//////                        if sections[indexPath.section].numberOfObjects <= 1 {
//////                            print("delete a section")
//////                            self?.loadData()
//////                            print("number of sections: \(sections.count)")
//////                            print("number of objects in current section: \(sections[indexPath.section].numberOfObjects)")
//////                            tableView.deleteSections([indexPath.section], with: .fade)
//////                            
//////                        } else {
//////                            print("delete a row")
//////                            self?.loadData()
//////                            print("number of sections: \(sections.count)")
//////                            print("number of objects in current section: \(sections[indexPath.section].numberOfObjects)")
//////                            tableView.deleteRows(at: [indexPath], with: .fade)
//////                        }
////                    }
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
//    func reloadTableViewData() {
//        timer.invalidate()
//        tableView.reloadData()
//    }
    
    
}
