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
    var timeLogArray: [TimeLog] = []
    var timeLogNestedArray: [[TimeLog]] = []
    var cellInitializerArray: [Int] = []
    var colorArray: [UIColor] = []
    let color1 = UIColor.black
    let color2 = CustomColor.blueDark
    
    //////////////////////////////////////////////
    // MARK:- Outlets
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    //////////////////////////////////////////////
    // MARK:- Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()
        intializeTimeLogs()
        setupViewController()
        setupTableView()
    }
    
    func setupViewController() {
        titleLabel.text = project?.title
    }
    
    func intializeTimeLogs() {
        let timeLog = TimeLog(context: moc!)
        timeLogArray = timeLog.getTimeLog(project: project!, moc: moc!)
        timeLogArray.sort(by: { $0.startTime! < $1.startTime! })
        
        print("\n***********\n")
        for entry in timeLogArray {
            let currentFormmattedDate = FormatTime().formattedDate(date: entry.startTime!)
            var i = 0
            var foundMatch = false
            while i < timeLogNestedArray.count && !foundMatch {
                let dateArray = timeLogNestedArray[i]
                let existingFormmattedDate = FormatTime().formattedDate(date: dateArray[0].startTime!)
                if currentFormmattedDate == existingFormmattedDate {
                    timeLogNestedArray[i].append(entry)
                    foundMatch = true
                }
                i += 1
            }
            if !foundMatch {
                timeLogNestedArray.append([entry])
            }
        }
        print("\n***********\n")
        
        // Do I need to sort again?
        
        var x = 0
        var y = 0
        while x < timeLogNestedArray.count {
            cellInitializerArray.append(-(x+1))
            createColorArray(x: x)
            for _ in timeLogNestedArray[x] {
                cellInitializerArray.append(y)
                createColorArray(x: x)
                y += 1
            }
            x += 1
        }
        print(cellInitializerArray)
        print(colorArray)
    }
    
    func createColorArray(x: Int) {
        if x % 2 == 0 {
            colorArray.append(color2)
        } else {
            colorArray.append(color1)
        }
    }
    
    //////////////////////////////////////////////
    // MARK:- Table View
    
    var timer = Timer()
    
    func setupTableView() { // Called on viewDidLoad
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 75
        tableView.separatorColor = UIColor.clear
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.scrollToBottom), userInfo: nil, repeats: false)
    }
    
    func scrollToBottom() {
        let stopIndexPath = IndexPath(row: cellInitializerArray.count - 1, section: 0)
        tableView.scrollToRow(at: stopIndexPath, at: .bottom, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let blackView = UIView()
        blackView.backgroundColor = UIColor.clear
        return blackView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        // This should be the same as Visual Effects View which contains the back button and project title
        return 76 as CGFloat
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timeLogArray.count + timeLogNestedArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Confifure DateCell
        if cellInitializerArray[indexPath.row] < 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "dateCell", for: indexPath) as! DateCell
            cell.selectionStyle = .none // DRY
            cell.backgroundColor = colorArray[indexPath.row] // DRY
            let entry = timeLogNestedArray[-(cellInitializerArray[indexPath.row]+1)][0]
            let formattedDate = FormatTime().formattedDate(date: entry.startTime!)
            cell.dateLabel.text = formattedDate
            return cell
        }
        
        // Configure HistoryCell
        let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath) as! HistoryCell
        cell.selectionStyle = .none // DRY
        cell.backgroundColor = colorArray[indexPath.row] // DRY
        let entry = (timeLogArray[cellInitializerArray[indexPath.row]]) as TimeLog
        cell.configureCell(entry: entry, moc: moc!)
        return cell
    }
    
}
