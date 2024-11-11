//
//  AddMedicationViewModelTests.swift
//  StorkCare+
//
//  Created by Khaleeqa Garrett on 11/11/24.
//


import XCTest
@testable import StorkCare_

final class AddMedicationViewModelTests: XCTestCase {

    // Test case when no medication name is provided
    func testAddMedication_NoMedicationName_ShowsAlert() {
        // Initialize the view model with an empty list of medications
        let viewModel = AddMedicationViewModel(medications: [])

        // Set medication name to empty
        viewModel.medicationName = ""

        // Simulate tapping the "Next" button
        viewModel.onNextButtonTapped()

        // Verify that an alert is shown with the expected message
        XCTAssertTrue(viewModel.showAlert)
        XCTAssertEqual(viewModel.alertMessage, "Please enter the medication name.")
    }
    
    // Test case when a medication name is provided
    func testAddMedication_WithMedicationName_NavigatesToSetSchedule() {
        // Initialize the view model with an empty list of medications
        let viewModel = AddMedicationViewModel(medications: [])

        // Set a valid medication name
        viewModel.medicationName = "Ibuprofen"

        // Simulate tapping the "Next" button
        viewModel.onNextButtonTapped()

        // Verify that navigation occurs and alert is not shown
        XCTAssertTrue(viewModel.showingSetSchedule)
        XCTAssertFalse(viewModel.showAlert)
    }
}
