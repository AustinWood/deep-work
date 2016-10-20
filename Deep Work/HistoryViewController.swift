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
        titleLabel.text = project?.title
        intializeTimeLogs()
    }
    
    func intializeTimeLogs() {
        let timeLog = TimeLog(context: moc!)
        timeLogArray = timeLog.getTimeLog(project: project!, moc: moc!)
        for entry in timeLogArray! {
            print(entry.startTime)
        }
        tableView.reloadData()
    }
    
    //////////////////////////////////////////////
    // MARK:- Initialization
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (timeLogArray?.count)! + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "dateCell", for: indexPath) as! DateCell
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath) as! HistoryCell
        let entry = (timeLogArray?[indexPath.row - 1])! as TimeLog
        
        let entryLength = entry.stopTime?.timeIntervalSince(entry.startTime!)
        let entryLengthFormatted = FormatTime().formattedHoursMinutes(timeInterval: entryLength!)
        
        cell.timeLabel.text = entryLengthFormatted
        return cell
    }
    
    
}
 
