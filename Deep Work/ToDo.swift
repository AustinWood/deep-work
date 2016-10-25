//////////////////////////////////////////////////
//////////////////////////////////////////////////
//
// RESUME WITH:
//
//
//////////////////////////////////////////////////
//////////////////////////////////////////////////
//
// TO DO:
//
// Priority 1:
//
//   # Update fonts
//   # DRY: Pass MyDateRange into TimeLog to prevent numerous switch statements throughout project
//   # Month + year title labels should by dynamic (now fixed "October" and "2016")
//   # projectCell size should be dynamic
//   # Calculate totals on timerStartStop, store in array, add one second
//   # Import data from other trackers since January
//   # Implement spell checker in textView
//   # Range checker should use workDay attribute, not starTime attribute
//   # Confirmation toast when deleting data / restoring from JSON
//   # Make FormatTime an extension of Date()
//   # Move Date extension from TimeLog+CoreDataClass.swift to separate file
//   # Animation: Fade in button color in when starting timer, fade others out
//   # Edge swipe to go back to main VC from HistoryVC
//   # HistoryVC:
//       # Swipe to edit note
//       # Swipe to edit start/stop time
//
// Priority 2:
//
//   # Use gradient colors
//   # Add blur effect
//   # Switch between fixed and relative summaries (e.g. "October" vs "Last 30 days")
//   # Settings: choose for 2-4 project cells per lines
//   # isAfterMidnight()
//   # Option to switch between All Time totals and Year totals
//   # After deleting a record in HistoryVC, scroll to correct position
//   # Sounds
//   # Visual time line at top (like Hours... No! Better, like my new sketch)
//   # Give projects an Area parent / tags
//   # Daily/Weekly goals (see Evernote)
//   # Delete/archive timers (when dragging, views at top turn into trash can/archive)
//   # Add randomized confimation messages to "Add note"
//   # Verify that time entries are disaplayed the same when moving across time zones
//   # Animate: Invalid action, try to start timer while another running: startStopTimer()
//   # Replace fatalError with something friendlier
//   # Reordering:
//       # Cell usually stays highlighted until another action is performed
//       # App sometimes freezes if lots of reordering is done quickly
//   # Design:
//       # Professional design (see Evernote, buy asset pack?)
//       # App icon
//       # Launch screen
//   # HistoryVC:
//       # Add summary views to top of VC
//       # Stylize today
//       # Stylize this week (color code with summary view at top of VC)
//       # Show totals by day next to each dateLabel
//   # Swipe to edit
//       # If in progress - stop entry option instead of delete
//       # Move to bottom of table view after delete (or move appropriate height down)
//
// After v1.0:
//
//   # Create an asynchronous request in History, upon completion scroll to bottom (more elegant implementation than arbitrary 0.1 second delay)
//   # Core Data optimization (see course notes)
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
