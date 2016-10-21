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
    
    var project: Project?
    var timeLogArray: [TimeLog]?
    var moc: NSManagedObjectContext?
    
    //////////////////////////////////////////////
    // MARK:- Outlets
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    //////////////////////////////////////////////
    // MARK:- Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()
        intializeTimeLogs()
        setupController()
        setupTableView()
    }
    
    func setupController() {
        titleLabel.text = project?.title
    }
    
    func intializeTimeLogs() {
        let timeLog = TimeLog(context: moc!)
        timeLogArray = timeLog.getTimeLog(project: project!, moc: moc!)
        tableView.reloadData()
    }
    
    //////////////////////////////////////////////
    // MARK:- Table View
    
    func setupTableView() { // Called on viewDidLoad
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 75
        tableView.separatorColor = UIColor.clear
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (timeLogArray?.count)! + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Confifure DateCell
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "dateCell", for: indexPath) as! DateCell
            cell.selectionStyle = .none // DRY
            return cell
        }
        
        // Configure HistoryCell
        let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath) as! HistoryCell
        cell.selectionStyle = .none // DRY
        let entry = (timeLogArray?[indexPath.row - 1])! as TimeLog
        cell.configureCell(entry: entry, moc: moc!)
        return cell
    }
    
    
}
 
