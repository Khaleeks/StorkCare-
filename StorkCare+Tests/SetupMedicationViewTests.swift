//
//  SetupMedicationViewTests.swift
//  StorkCare+
//
//  Created by Khaleeqa Garrett on 11/15/24.
//


import XCTest
import SwiftUI
import ViewInspector
@testable import StorkCare_

final class SetupMedicationViewTests: XCTestCase {

    func testViewHasCorrectTitle() throws {
        // Arrange
        let medications = Binding.constant([Medication]())
        let view = SetupMedicationView(medications: medications)

        // Act
        let text = try view.inspect().find(text: "Set Up Medications").string()

        // Assert
        XCTAssertEqual(text, "Set Up Medications")
    }

    func testDescriptionTextExists() throws {
        // Arrange
        let medications = Binding.constant([Medication]())
        let view = SetupMedicationView(medications: medications)

        // Act
        let descriptionText = try view.inspect().find(text: "Let’s keep your health on track! Set reminders and manage your medications effortlessly!").string()

        // Assert
        XCTAssertEqual(descriptionText, "Let’s keep your health on track! Set reminders and manage your medications effortlessly!")
    }

    func testFeatureRowsExist() throws {
        // Arrange
        let medications = Binding.constant([Medication]())
        let view = SetupMedicationView(medications: medications)

        // Act & Assert
        let features = [
            "Track all your medications in one place.",
            "Set a schedule and get reminders for each medication.",
            "View a list of your medications."
        ]

        for feature in features {
            XCTAssertNoThrow(try view.inspect().find(text: feature))
        }
    }

    func testNavigationToAddMedicationView() throws {
        // Arrange
        let medications = Binding.constant([Medication]())
        let view = SetupMedicationView(medications: medications)

        // Act
        let button = try view.inspect().find(button: "Add Medication")
        try button.tap()

        // Assert
        XCTAssertNoThrow(try view.inspect().find(AddMedicationView.self))
    }
}
