//
//  AddMedicationViewTests.swift
//  StorkCare+
//
//  Created by Khaleeqa Garrett on 11/15/24.
//


import XCTest
import SwiftUI
import ViewInspector // You need ViewInspector for detailed SwiftUI view testing
@testable import StorkCare_

final class AddMedicationViewTests: XCTestCase {

    func testViewStructure() throws {
        // Given
        let medications = Binding.constant([Medication]())
        let view = AddMedicationView(medications: medications)
        
        // When
        let inspectedView = try view.inspect()
        
        // Then
        XCTAssertNoThrow(try inspectedView.vStack(), "The main layout should be a VStack")
        XCTAssertEqual(try inspectedView.vStack().count, 7, "The VStack should have 7 elements, including text, pickers, and buttons.")
    }
    
    func testTitleText() throws {
        // Given
        let medications = Binding.constant([Medication]())
        let view = AddMedicationView(medications: medications)
        
        // When
        let titleText = try view.inspect().vStack().text(0)
        
        // Then
        XCTAssertEqual(try titleText.string(), "Add Medication", "The title should be 'Add Medication'")
        XCTAssertEqual(try titleText.attributes().font(), Font.title, "The title font should be 'title'")
    }
    
    func testMedicationNameTextField() throws {
        // Given
        let medications = Binding.constant([Medication]())
        let view = AddMedicationView(medications: medications)
        
        // When
        let textField = try view.inspect().vStack().textField(2)
        let placeholder = try textField.labelView().text() // Access the placeholder as a child Text view
        
        // Then
        XCTAssertEqual(try placeholder.string(), "Enter Medication Name", "The text field placeholder should be correct")
    }

    func testAlertPresence() throws {
        // Given
        let medications = Binding.constant([Medication]())
        let view = AddMedicationView(medications: medications)
        
        // When
        let inspectedView = try view.inspect()
        
        // Then
        XCTAssertNoThrow(try inspectedView.vStack().button(5).alert(), "The button should present an alert")
    }
    
    func testNavigationToSetScheduleView() throws {
        // Given
        let medications = Binding.constant([Medication]())
        let view = AddMedicationView(medications: medications)
        
        // When
        let navigation = try view.inspect().vStack().button(5).navigationDestination()
        
        // Then
        XCTAssertNoThrow(try navigation.view(SetScheduleView.self), "Tapping Next should navigate to SetScheduleView")
    }
}
