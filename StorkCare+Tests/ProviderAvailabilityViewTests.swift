import XCTest
import SwiftUI
import ViewInspector
@testable import StorkCare_

class ProviderAvailabilityViewTests: XCTestCase {
    
    var providerAvailabilityView: ProviderAvailabilityView!
    var mockViewModel: ProviderAvailabilityViewModel!
    
    override func setUp() {
        super.setUp()
        // Create a mock ViewModel and initialize the ProviderAvailabilityView with it.
        mockViewModel = ProviderAvailabilityViewModel()
        mockViewModel.providerData = ProviderData(name: "Dr. Smith", occupation: "Doctor", placeOfWork: "StorkCare Clinic", gender: "Female") // Mock data
        mockViewModel.selectedTimeSlots = ["9:00 AM", "10:00 AM", "11:00 AM"]
        mockViewModel.selectedDate = Date()
        providerAvailabilityView = ProviderAvailabilityView(viewModel: self.mockViewModel)
    }

    func testProviderInfoCard() throws {
        let view = try providerAvailabilityView.inspect()
        let providerInfoCard = try view.find(viewWithId: "ProviderInfoCard")
        XCTAssertNotNil(providerInfoCard)
    }
    
    func testDatePicker() throws {
        let view = try providerAvailabilityView.inspect()
        let datePicker = try view.find(viewWithId: "DatePicker")
        XCTAssertNotNil(datePicker)
    }

    func testTimeSlotButton() throws {
        let view = try providerAvailabilityView.inspect()
        // Assuming the time slots are being dynamically generated based on the mock data
        let timeSlotButton = try view.find(viewWithId: "TimeSlotButton-9:00 AM")
        XCTAssertNotNil(timeSlotButton)
    }
    
    func testConfirmButton() throws {
        let view = try providerAvailabilityView.inspect()
        let confirmButton = try view.find(viewWithId: "ConfirmButton")
        XCTAssertNotNil(confirmButton)
    }
    
    func testMessageLabel() throws {
        let view = try providerAvailabilityView.inspect()
        let messageLabel = try view.find(viewWithId: "MessageLabel")
        XCTAssertNotNil(messageLabel)
    }
}
