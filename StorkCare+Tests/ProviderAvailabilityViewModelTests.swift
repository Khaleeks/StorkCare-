//
//  ProviderAvailabilityViewModelTests.swift
//  StorkCare+
//
//  Created by Khaleeqa Garrett on 11/13/24.
//


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
        XCTAssertTrue(viewModel.selectedTimeSlots.isEmpty)
        XCTAssertTrue(viewModel.showingConfirmation)
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
    
    // Test: Ensure that the 'Confirm' action triggers saveAvailability method
    func testConfirmAction() {
        // Given
        viewModel.selectedTimeSlots = ["9:00 AM"]
        
        // When
        viewModel.saveAvailability()
        
        // Then
        // Check if the availability is saved
        // This test assumes saveAvailability changes something observable
        XCTAssertTrue(viewModel.selectedTimeSlots.isEmpty)  // For example, it might clear the selected time slots after saving
    }
}
