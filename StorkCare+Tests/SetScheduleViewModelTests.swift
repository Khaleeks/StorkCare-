import XCTest
@testable import StorkCare_  

class SetScheduleViewModelTests: XCTestCase {

    var viewModel: SetScheduleViewModel!

    override func setUp() {
        super.setUp()
        viewModel = SetScheduleViewModel()
    }

    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }

    // Test the default state of the view model
    func testDefaultState() {
        XCTAssertEqual(viewModel.scheduleFrequency, "Every day")
        XCTAssertEqual(viewModel.specificTimes, [])
        XCTAssertEqual(viewModel.capsuleQuantity, "1 capsule")
        XCTAssertEqual(viewModel.startDate, Date(), "Start date should be initialized to the current date")
        XCTAssertEqual(viewModel.endDate, Date(), "End date should be initialized to the current date")
        XCTAssertFalse(viewModel.showSummary)
        XCTAssertFalse(viewModel.showErrorMessage)
        XCTAssertFalse(viewModel.isAddingTime)
    }

    // Test adding a time and checking if the specificTimes array is updated
    func testAddTime() {
        let initialTimesCount = viewModel.specificTimes.count
        let newTime = Date()
        
        viewModel.addTime(newTime)
        
        XCTAssertEqual(viewModel.specificTimes.count, initialTimesCount + 1, "The time should be added to specificTimes array")
        XCTAssertEqual(viewModel.specificTimes.last, viewModel.formattedTime(newTime), "The last time in specificTimes should match the formatted time")
    }

    // Test validateAndProceed when no times are added (should show error message)
    func testValidateAndProceed_NoTimes() {
        viewModel.specificTimes = []  // Ensure no times are added
        
        viewModel.validateAndProceed()
        
        XCTAssertTrue(viewModel.showErrorMessage, "showErrorMessage should be true when no times are added")
        XCTAssertFalse(viewModel.showSummary, "showSummary should be false when no times are added")
    }

    // Test validateAndProceed when times are added (should show summary)
    func testValidateAndProceed_WithTimes() {
        viewModel.specificTimes = ["08:00 AM", "09:00 AM"]  // Add some times
        
        viewModel.validateAndProceed()
        
        XCTAssertTrue(viewModel.showSummary, "showSummary should be true when times are added")
        XCTAssertFalse(viewModel.showErrorMessage, "showErrorMessage should be false when times are added")
    }

    // Test the formattedTime method
    func testFormattedTime() {
        let testDate = Date(timeIntervalSince1970: 1623000000)  // Specific test date
        let formattedDate = viewModel.formattedTime(testDate)
        let expectedFormattedDate = "11:00 PM"  // Format based on the date and time provided

        XCTAssertEqual(formattedDate, expectedFormattedDate, "The formatted time should match the expected time format")
    }

    // Test changing the frequency
    func testChangeScheduleFrequency() {
        let newFrequency = "On specific days of the week"
        viewModel.scheduleFrequency = newFrequency
        
        XCTAssertEqual(viewModel.scheduleFrequency, newFrequency, "The scheduleFrequency should be updated correctly")
    }
    
    // Test adding multiple times
    func testAddMultipleTimes() {
        let initialCount = viewModel.specificTimes.count
        
        let times = [
            Date(timeIntervalSince1970: 1623000000),  // 11:00 PM
            Date(timeIntervalSince1970: 1623003600)   // 12:00 AM
        ]
        
        for time in times {
            viewModel.addTime(time)
        }
        
        XCTAssertEqual(viewModel.specificTimes.count, initialCount + times.count, "The specificTimes array should contain all added times")
        XCTAssertEqual(viewModel.specificTimes.last, viewModel.formattedTime(times.last!), "The last added time should match the formatted time")
    }
}
