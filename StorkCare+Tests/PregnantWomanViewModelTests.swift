import XCTest
@testable import StorkCare_

class PregnantWomanViewModelTests: XCTestCase {

    var viewModel: PregnantWomanViewModel!
    
    override func setUp() {
        super.setUp()
        // Initialize the view model before each test
        viewModel = PregnantWomanViewModel()
    }

    override func tearDown() {
        // Clean up the view model after each test
        viewModel = nil
        super.tearDown()
    }

    func testInitialValues() {
        // Test the initial values in the view model
        XCTAssertEqual(viewModel.name, "")
        XCTAssertEqual(viewModel.selectedSex, "")
        XCTAssertEqual(viewModel.selectedHeight, 0)
        XCTAssertEqual(viewModel.selectedWeight, 0)
        XCTAssertFalse(viewModel.isProfileCreated)
    }

    func testSavePregnantWomanData_CompleteData() {
        // Test saving data when all fields are filled
        viewModel.name = "Jane Doe"
        viewModel.selectedSex = "Female"
        viewModel.selectedHeight = 160
        viewModel.selectedWeight = 60
        
        // Call the method to save data
        viewModel.savePregnantWomanData(uid: "testUID")
        
        // Assert that the profile is marked as created
        XCTAssertTrue(viewModel.isProfileCreated)
    }

    func testSavePregnantWomanData_IncompleteData() {
        // Test saving data with incomplete information
        viewModel.name = "Jane Doe"
        viewModel.selectedSex = ""
        viewModel.selectedHeight = 160
        viewModel.selectedWeight = 60
        
        // Call the method to save data
        viewModel.savePregnantWomanData(uid: "testUID")
        
        // Assert that the profile is not created because of missing information
        XCTAssertFalse(viewModel.isProfileCreated)
    }
    
    func testDateFormatted() {
        // Test the date formatting functionality
        let date = Date(timeIntervalSince1970: 0) // 1970-01-01
        let formattedDate = viewModel.dateFormatted(date: date)
        
        // Validate the formatted string
        XCTAssertEqual(formattedDate, "January 1, 1970")
    }

    func testSexPickerInteraction() {
        // Simulate a sex picker interaction
        viewModel.selectedSex = "Male"
        
        // Assert that the sex is updated correctly
        XCTAssertEqual(viewModel.selectedSex, "Male")
    }
    
    func testHeightPickerInteraction() {
        // Simulate height picker selection
        viewModel.selectedHeight = 170
        
        // Assert that the height is updated correctly
        XCTAssertEqual(viewModel.selectedHeight, 170)
    }
    
    func testWeightPickerInteraction() {
        // Simulate weight picker selection
        viewModel.selectedWeight = 70
        
        // Assert that the weight is updated correctly
        XCTAssertEqual(viewModel.selectedWeight, 70)
    }
}
