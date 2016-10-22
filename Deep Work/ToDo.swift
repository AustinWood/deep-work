//////////////////////////////////////////////////
//////////////////////////////////////////////////
//
// RESUME WITH:
//
// Display details:
//   # Stylize today
//   # If entry is active:
//       # Cell color
//       # Remove stop time from output string
//       # Update timer each second
//   # Swipe to edit
//       # Delete entry
//       # Edit note
//       # Edit start/stop time
//   # Add edit project button in upper right
//   # Add summary views to top of VC
//   # Stylize this week (color code with summary view at top of VC)
//
//////////////////////////////////////////////////
//////////////////////////////////////////////////
//
// TO DO:
//
// Bug: single tapping in collection view where no cell exists throws error
// Turn off landscape
// Automatically capitalize first letter of entry note, and after periods
// Pause timer when "Great work!" screen appears (resume is 'Continue working' pressed), currently still running in background
// Animation: When starting timer: fade button color in, fade other buttons text/outline to gray
// Edge swipe to go back to main VC from HistoryVC

// Visual time line at top (like Hours... No! Better, like my new sketch)
// Give projects an Area parent / tags
// Daily/Weekly goals (see Evernote)
// Sort JSON time entries for readability
// Delete/archive timers
// Create an asynchronous request in History, upon completion scroll to bottom
// Add randomized confimation messages to "Add note"
// Verify that time entries are disaplayed the same when moving across time zones
// Animation: Invalid action if trying to start a timer while another is running
// Replace fatalError with something friendlier
// Refactor time summations (todayTime and weekTime DRY)
// Professional design (see Evernote, by asset pack?)
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
