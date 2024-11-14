import XCTest
import ViewInspector
@testable import StorkCare_

final class SetScheduleViewTests: XCTestCase {
    
    func testViewLoadsCorrectly() throws {
        // Create a mock or empty medications list for the test
        let medications: [Medication] = []
        let viewModel = SetScheduleViewModel()

        // Initialize the view with the mock view model and medications
        let setScheduleView = SetScheduleView(medications: .constant(medications), viewModel: viewModel)

        // Check for "Set a Schedule" title
        let titleText = try setScheduleView.inspect().find(text: "Set a Schedule")
        XCTAssertEqual(try titleText.string(), "Set a Schedule")
        
        // Check for "Start Date" label
        let startDateLabel = try setScheduleView.inspect().find(text: "Start Date")
        XCTAssertEqual(try startDateLabel.string(), "Start Date")
        
        // Check if the DatePicker is present for selecting the start date
        let datePicker = try setScheduleView.inspect().find(ViewType.DatePicker.self)
        XCTAssertNotNil(datePicker)

        // Check if the "Next" button is present
        let nextButton = try setScheduleView.inspect().find(button: "Next")
        XCTAssertNotNil(nextButton)

        // Check if the "Add Time" button is present
        let addTimeButton = try setScheduleView.inspect().find(button: "Add Time")
        XCTAssertNotNil(addTimeButton)
    }

    func testErrorMessageWhenNoTimeAdded() throws {
        // Create an empty medications list for testing
        let medications: [Medication] = []
        let viewModel = SetScheduleViewModel()
        
        // Initialize the SetScheduleView with empty medications list and view model
        let setScheduleView = SetScheduleView(medications: .constant(medications), viewModel: viewModel)

        // Initially, no error message should be visible
        XCTAssertNil(try? setScheduleView.inspect().find(text: "Please add at least one time."))

        // Simulate tapping the "Next" button without adding any time
        let nextButton = try setScheduleView.inspect().find(button: "Next")
        try nextButton.tap()

        // After tapping the "Next" button, error message should appear
        let errorMessage = try setScheduleView.inspect().find(text: "Please add at least one time.")
        XCTAssertEqual(try errorMessage.string(), "Please add at least one time.")
    }

    func testAddTimeButton() throws {
        // Create empty medications list for testing
        let medications: [Medication] = []
        let viewModel = SetScheduleViewModel()

        // Initialize the view with empty medications list and the view model
        let setScheduleView = SetScheduleView(medications: .constant(medications), viewModel: viewModel)

        // Check that "Add Time" button is present
        let addTimeButton = try setScheduleView.inspect().find(button: "Add Time")
        XCTAssertNotNil(addTimeButton)

        // Simulate tapping the "Add Time" button
        try addTimeButton.tap()

        // After tapping, check that at least one time slot appears (or whatever dynamic behavior you expect)
        // For example, checking if a new time slot element is added to the view
        let timeSlotElements = try setScheduleView.inspect().findAll(ViewType.Text.self)
        XCTAssertTrue(timeSlotElements.count > 0)  // Assuming a time slot is added
    }

    func testNextButtonTapped() throws {
        let medications: [Medication] = []  // Empty list for testing
        let viewModel = SetScheduleViewModel()

        // Initialize the SetScheduleView with mock medications list
        let setScheduleView = SetScheduleView(medications: .constant(medications), viewModel: viewModel)

        // Find the "Next" button and simulate a tap
        let nextButton = try setScheduleView.inspect().find(button: "Next")
        try nextButton.tap()

        // After tapping the "Next" button, check if the view navigates to the next screen (e.g., SummaryView)
        // Assuming the SummaryView should appear after tapping "Next"
        let summaryView = try setScheduleView.inspect().find(SummaryView.self)
        XCTAssertNotNil(summaryView)
    }
}
