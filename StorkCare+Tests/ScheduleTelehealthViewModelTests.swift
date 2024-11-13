//
//  ScheduleTelehealthViewModelTests.swift
//  StorkCare+
//
//  Created by Khaleeqa Garrett on 11/13/24.
//


import XCTest
@testable import StorkCare_

class ScheduleTelehealthViewModelTests: XCTestCase {
    var viewModel: ScheduleTelehealthViewModel!

    override func setUp() {
        super.setUp()
        viewModel = ScheduleTelehealthViewModel()
    }

    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }

    func testLoadAvailableSlots_withAvailableProvider() {
        viewModel.loadAvailableSlots(for: "Dr. Smith")
        XCTAssertFalse(viewModel.noSlotsAvailable)
        XCTAssertFalse(viewModel.providerUnavailable)
        XCTAssertEqual(viewModel.availableSlots, ["9:00 AM", "10:30 AM", "1:00 PM", "3:00 PM"])
    }
    
    func testLoadAvailableSlots_withUnavailableProvider() {
        viewModel.loadAvailableSlots(for: "Dr. Lee")
        XCTAssertTrue(viewModel.providerUnavailable)
        XCTAssertEqual(viewModel.availableSlots, [])
    }
    
    func testConfirmAppointment_withValidSlot() {
        viewModel.selectedProvider = "Dr. Smith"
        viewModel.selectedSlot = "9:00 AM"
        viewModel.confirmAppointment()
        
        XCTAssertFalse(viewModel.confirmationMessage.isEmpty)
        XCTAssertTrue(viewModel.showRescheduleOptions)
    }
    
    func testConfirmAppointment_withoutSlot() {
        viewModel.selectedProvider = "Dr. Smith"
        viewModel.selectedSlot = ""
        viewModel.confirmAppointment()
        
        XCTAssertEqual(viewModel.confirmationMessage, "Please select a time slot.")
        XCTAssertFalse(viewModel.showRescheduleOptions)
    }

    func testRescheduleAppointment() {
        viewModel.confirmationMessage = "Confirmed"
        viewModel.showRescheduleOptions = true
        
        viewModel.rescheduleAppointment()
        
        XCTAssertTrue(viewModel.confirmationMessage.isEmpty)
        XCTAssertTrue(viewModel.selectedSlot.isEmpty)
        XCTAssertFalse(viewModel.showRescheduleOptions)
    }
}
