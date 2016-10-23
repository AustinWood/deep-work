//
//  OldReferenceCode.swift
//  Deep Work
//
//  Created by Austin Wood on 2016-10-23.
//  Copyright © 2016 Austin Wood. All rights reserved.
//

////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////
// Add fake time data

//    func addFakeTimeData() {
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
//    }

////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////
// This is just funny, now that I know about NSFetchedResultsController

//    var timeLogArray: [TimeLog] = []
//    var timeLogNestedArray: [[TimeLog]] = []
//    var cellInitializerArray: [Int] = []
//    var colorArray: [UIColor] = []
//    let color1 = UIColor.black
//    let color2 = CustomColor.blueDark

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
