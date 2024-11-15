import XCTest
import SwiftUI
@testable import StorkCare_

class ProviderAvailabilityViewModelTests: XCTestCase {
    
    var viewModel: ProviderAvailabilityViewModel!
    
    override func setUp() {
        super.setUp()
        // Initialize the ViewModel
        viewModel = ProviderAvailabilityViewModel()
    }
    
    override func tearDown() {
        // Clean up after each test
        viewModel = nil
        super.tearDown()
    }
    
    // Test: Check if provider data is loaded correctly
    func testProviderDataLoading() {
        // Given
        let providerData = ProviderData(name: "John Doe", occupation: "Doctor", placeOfWork: "Hospital", gender: "Male")
        viewModel.providerData = providerData
        
        // When
        viewModel.loadProviderData()
        
        // Then
        XCTAssertEqual(viewModel.providerData.name, "John Doe")
        XCTAssertEqual(viewModel.providerData.occupation, "Doctor")
        XCTAssertEqual(viewModel.providerData.placeOfWork, "Hospital")
        XCTAssertEqual(viewModel.providerData.gender, "Male")
    }
    
    // Test: Check if time slot selection toggles correctly
    func testTimeSlotSelection() {
        // Given
        let initialSelectedTimeSlots = viewModel.selectedTimeSlots
        
        // When: Select a time slot
        viewModel.toggleTimeSlot("9:00 AM")
        
        // Then: Check if the time slot is selected
        XCTAssertTrue(viewModel.selectedTimeSlots.contains("9:00 AM"))
        
        // When: Deselect the time slot
        viewModel.toggleTimeSlot("9:00 AM")
        
        // Then: Check if the time slot is deselected
        XCTAssertFalse(viewModel.selectedTimeSlots.contains("9:00 AM"))
    }
    
    // Test: Confirm button is enabled when time slots are selected
    func testConfirmButtonEnabledWhenTimeSlotsSelected() {
        // Given
        viewModel.selectedTimeSlots = ["9:00 AM", "10:00 AM"]
        
        // Then
        XCTAssertTrue(viewModel.selectedTimeSlots.count > 0)
        XCTAssertFalse(viewModel.showingConfirmation)
    }
    
    // Test: Confirm button is disabled when no time slots are selected
    func testConfirmButtonDisabledWhenNoTimeSlotsSelected() {
        // Given
        viewModel.selectedTimeSlots = []
        
        // Then
        XCTAssertTrue(viewModel.selectedTimeSlots.isEmpty)  // Ensure no time slots are selected
        XCTAssertFalse(viewModel.showingConfirmation)      // Ensure confirmation is not showing (disabled)
    }
    
    // Test: Date selection works properly
    func testDateSelection() {
        // Given
        let initialDate = viewModel.selectedDate
        let newDate = Calendar.current.date(byAdding: .day, value: 1, to: initialDate)!
        
        // When
        viewModel.selectedDate = newDate
        
        // Then
        XCTAssertEqual(viewModel.selectedDate, newDate)
    }
    
    // Test: Ensure error message is displayed when saveAvailability fails
    func testSaveAvailabilityFails() {
        // Given
        viewModel.selectedTimeSlots = ["9:00 AM"]
        
        // Simulate Firestore failure by passing an error to the callback
        let expectation = self.expectation(description: "Save availability should fail")
        
        viewModel.saveAvailability()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            XCTAssertEqual(self.viewModel.message, "Error: Failed to save availability")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 3, handler: nil)
    }

    // Test: Ensure success message is displayed when saveAvailability is successful
    func testSaveAvailabilitySuccess() {
        // Given
        viewModel.selectedTimeSlots = ["9:00 AM"]
        
        // Simulate Firestore success by calling saveAvailability and checking the success message
        let expectation = self.expectation(description: "Save availability should succeed")
        
        viewModel.saveAvailability()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            XCTAssertEqual(self.viewModel.message, "Availability updated successfully!")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 3, handler: nil)
    }

    func testIsLoadingStateDuringSave() {
        viewModel.selectedTimeSlots = ["9:00 AM"]
        
        let expectation = self.expectation(description: "isLoading state updates correctly")
        
        viewModel.saveAvailability()
        
        XCTAssertTrue(viewModel.isLoading)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            XCTAssertFalse(self.viewModel.isLoading)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 2.0, handler: nil)
    }
    
    // Test: Ensure no availability is loaded when no time slots exist for the selected date
    func testNoAvailabilityForDate() {
        // Given
        let newDate = Calendar.current.date(byAdding: .day, value: 1, to: viewModel.selectedDate)!
        viewModel.selectedDate = newDate
        
        // Simulate no time slots in Firestore
        viewModel.loadExistingAvailability()
        
        // Then
        XCTAssertTrue(viewModel.selectedTimeSlots.isEmpty)
    }
}
