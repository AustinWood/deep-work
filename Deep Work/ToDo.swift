//////////////////////////////////////////////////
//////////////////////////////////////////////////
//
// NOW:
//
//   # Animation: Fade in button color in when starting timer, fade others out
//   # Make FormatTime an extension of Date()
//   # Move Date extension from TimeLog+CoreDataClass.swift to separate file
//
//////////////////////////////////////////////////
//////////////////////////////////////////////////
//
// PRIORITY 1:
//
//   # DRY: Pass MyDateRange into TimeLog to prevent numerous switch statements throughout project
//   # projectCell size should be dynamic
//   # Bug: Incorrect time displayed in project cell while dragging if timer is running
//   # Month + year title labels should by dynamic (now fixed "October" and "2016")
//   # HistoryVC:
//       # Swipe to edit note
//   # Reordering:
//       # Cell usually stays highlighted until another action is performed
//       # App sometimes freezes if lots of reordering is done quickly
//   # Import data from Hours
//   # Backup to BitBucket with .gitignore
//
//////////////////////////////////////////////////
//////////////////////////////////////////////////
//
// PRIORITY 2:
//
//   # Investigate why some timeLogs with startTime == nil, create cleanup function?
//   # Confirmation toast when deleting data / restoring from JSON
//   # Delete data, 3 options: delete all, upload sample, import from backupt
//   # Update fonts
//   # Replace fatalError with something friendlier
//   # Delete timers
//   # Design:
//       # App icon
//       # Launch screen
//
//////////////////////////////////////////////////
//////////////////////////////////////////////////
//
// AFTER v1.0:
//
//   # HistoryVC:
//       # Swipe to edit start/stop time
//       # If in progress, "stop entry" instead of "delete"
//       # Update style to match HomeVC
//       # Add blur effects (section headers, NavBar)
//       # Add summary views to top of VC
//       # Stylize today
//       # Stylize this week (color code with summary view at top of VC)
//       # Show totals by day next to each dateLabel
//       # After deleting a record, scroll to correct position
//   # projectCell border shows percentage of weekly goal
//   # Range checker should use workDay attribute, not starTime attribute
//   # Calculate totals on timerStartStop, store in array, add one second
//   # Create an asynchronous request in History, upon completion scroll to bottom (more elegant implementation than arbitrary 0.1 second delay)
//   # Core Data optimization (see course notes)
//   # isAfterMidnight()
//   # Settings: Choose color for each project: text + border when not selected, background color when selected
//   # Use gradient colors
//   # Switch between fixed and relative summaries (e.g. "October" vs "Last 30 days")
//   # Settings: choose for 2-4 project cells per lines
//   # Option to switch between All Time totals and Year totals
//   # Sounds
//   # Visual time line at top (see sketch scan in Evernote)
//   # Give projects an Area parent / tags
//   # Delete/archive timers (when dragging, views at top turn into trash can/archive)
//   # Add randomized confimation messages to "Add note"
//   # Verify that time entries are disaplayed the same when moving across time zones
//   # Animate: Invalid action, try to start timer while another running: startStopTimer()
//
//////////////////////////////////////////////////
//////////////////////////////////////////////////
//
// REFERENCES:
//
// Dates in Swift 3
// http://www.globalnerdy.com/2016/08/18/how-to-work-with-dates-and-times-in-swift-3-part-1-dates-calendars-and-datecomponents/
//
// Calculating time intervals
// http://stackoverflow.com/questions/27182023/getting-the-difference-between-two-nsdates-in-months-days-hours-minutes-seconds
//
//////////////////////////////////////////////////
//////////////////////////////////////////////////
