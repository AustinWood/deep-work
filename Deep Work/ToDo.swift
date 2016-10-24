//////////////////////////////////////////////////
//////////////////////////////////////////////////
//
// RESUME WITH:
//
//   # Sort JSON time entries for readability
//   # Import new JSON data, update with workDayString
//
//
//////////////////////////////////////////////////
//////////////////////////////////////////////////
//
// TO DO:
//
// Priority 1
//   # HistoryVC: Edit project name, button in top right
//   # Turn off landscape
//   # Automatically capitalize first letter of entry note, and after periods
//   # Animation: Fade in button color in when starting timer, fade others out
//   # Edge swipe to go back to main VC from HistoryVC
//   # Confirmation toast when deleting data / restoring from JSON
//   # HistoryVC:
//       # Swipe to edit note
//       # Swipe to edit start/stop time
//
// Priority 2
//   # DRY: dayPressed + weekPressed
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
//   # Refactor time summations (todayTime and weekTime DRY)
//   # Reordering:
//       # Cell usually stays highlighted until another action is performed
//       # App sometimes freezes if lots of reordering is done quickly
//   # Design:
//       # Professional design (see Evernote, by asset pack?)
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
// After v1.0
//   # Create an asynchronous request in History, upon completion scroll to bottom
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
