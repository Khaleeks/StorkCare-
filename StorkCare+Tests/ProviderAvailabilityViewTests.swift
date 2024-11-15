import XCTest
import SwiftUI
import ViewInspector
@testable import StorkCare_

class ProviderAvailabilityViewTests: XCTestCase {
    
    var providerAvailabilityView: ProviderAvailabilityView!
    
    override func setUp() {
        super.setUp()
        providerAvailabilityView = ProviderAvailabilityView()
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
