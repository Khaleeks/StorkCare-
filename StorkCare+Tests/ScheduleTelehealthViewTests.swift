//  ScheduleTelehealthViewTests.swift
//  StorkCare+
//
//  Created by Khaleeqa Garrett on 11/14/24.
//

import XCTest
import SwiftUI
import ViewInspector
@testable import StorkCare_

class ScheduleTelehealthViewTests: XCTestCase {

    // Test for rendering the "Schedule a Telehealth Consultation" text
    func testScheduleTelehealthTitle() throws {
        let view = ScheduleTelehealthView()

        // Inspect the view
        let text = try view.inspect().find(text: "Schedule a Telehealth Consultation")

        // Assert that the text exists
        XCTAssertEqual(try text.string(), "Schedule a Telehealth Consultation")
    }

    // Test for rendering the DatePicker for the appointment date
    func testDatePicker() throws {
        let view = ScheduleTelehealthView()
        
        // Inspect for the presence of DatePicker
        let datePicker = try view.inspect().find(DatePicker<Text>.self)
        
        // Assert that the DatePicker is found
        XCTAssertNotNil(datePicker)
    }

    // Test for rendering the Picker to select a healthcare provider
    func testHealthcareProviderPicker() throws {
        let view = ScheduleTelehealthView()
        
        // Inspect for the presence of Picker
        let picker = try view.inspect().find(Picker<Text, String, ForEach<[String], String, Text>>.self)
        
        // Assert that the Picker is found
        XCTAssertNotNil(picker)
    }
    // Test for displaying a confirmation message (without ViewModel)
    func testConfirmationMessage() throws {
        let view = ScheduleTelehealthView()
        
        // Look for the confirmation message text
        let confirmationText = try view.inspect().find(text: "Your appointment has been confirmed!")
        
        // Assert that the confirmation message is displayed
        XCTAssertEqual(try confirmationText.string(), "Your appointment has been confirmed!")
    }

    // Test for handling the provider unavailable message (without ViewModel)
    func testProviderUnavailableMessage() throws {
        let view = ScheduleTelehealthView()

        // Assume the providerUnavailable flag is handled internally by the view
        // Check for the unavailable message text
        let message = try view.inspect().find(text: "This provider is currently unavailable.")
        
        // Assert that the message is displayed when the provider is unavailable
        XCTAssertEqual(try message.string(), "This provider is currently unavailable.")
    }
}
