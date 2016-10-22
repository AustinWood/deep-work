//////////////////////////////////////////////////
//////////////////////////////////////////////////
//
// RESUME WITH:

// # Bug: doesn't reload data after saving entry
//
// HistoryVC:
//   # Swipe to edit
//       # Bug: crash if deleting last entry in a day
//       # Move to bottom of table view after delete (or move appropriate height down)
//       # Edit note
//       # Edit start/stop time
//       # If in progress - stop entry option instead of delete
//   # Add edit project button in upper right
//       # Edit project name
//
//////////////////////////////////////////////////
//////////////////////////////////////////////////
//
// TO DO:
//
// Priority 1
//   # Bug: single tapping in collection view where no cell exists throws error
//   # Turn off landscape
//   # Automatically capitalize first letter of entry note, and after periods
//   # Animation: When starting timer: fade button color in, fade other buttons text/outline to gray
//   # Edge swipe to go back to main VC from HistoryVC
//
// Priority 2
//   # Visual time line at top (like Hours... No! Better, like my new sketch)
//   # Give projects an Area parent / tags
//   # Daily/Weekly goals (see Evernote)
//   # Sort JSON time entries for readability
//   # Delete/archive timers (when dragging, views at top can turn into trash can / archive bin)
//   # Add randomized confimation messages to "Add note"
//   # Verify that time entries are disaplayed the same when moving across time zones
//   # Animation: Invalid action if trying to start a timer while another is running
//   # Replace fatalError with something friendlier
//   # Refactor time summations (todayTime and weekTime DRY)
//   # Professional design (see Evernote, by asset pack?)
//   # HistoryVC:
//       # Add summary views to top of VC
//       # Stylize today
//       # Stylize this week (color code with summary view at top of VC)
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
