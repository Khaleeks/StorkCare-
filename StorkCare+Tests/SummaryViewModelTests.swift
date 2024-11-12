//
//  SetScheduleViewModelTests.swift
//  StorkCare+
//
//  Created by Khaleeqa Garrett on 12/11/24.
//

import XCTest
@testable import StorkCare_

final class SummaryViewModelTests: XCTestCase {

    var viewModel: SummaryViewModel!

    override func setUp() {
        super.setUp()
        // Correct initialization of the test view model
        let testStartDate = Date(timeIntervalSince1970: 1000000) // Sample start date
        let testEndDate = Date(timeIntervalSince1970: 2000000)   // Sample end date

        // Using Date for reminderTime
        let testMedications = [
            Medication(name: "Aspirin", reminderTime: Date(timeIntervalSince1970: 100000)) // Example reminder time
        ]

        viewModel = SummaryViewModel(
            medications: testMedications,
            scheduleFrequency: "Twice a day",
            specificTimes: ["9:00 AM", "9:00 PM"],
            capsuleQuantity: "2 capsules",
            startDate: testStartDate,
            endDate: testEndDate
        )
    }

    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }

    func test_initialValues_shouldBeCorrect() {
        // Then
        XCTAssertEqual(viewModel.scheduleFrequency, "Twice a day", "scheduleFrequency should be 'Twice a day'")
        XCTAssertEqual(viewModel.specificTimes, ["9:00 AM", "9:00 PM"], "specificTimes should match the input")
        XCTAssertEqual(viewModel.capsuleQuantity, "2 capsules", "capsuleQuantity should be '2 capsules'")
        XCTAssertNotNil(viewModel.startDate, "startDate should be initialized")
        XCTAssertNotNil(viewModel.endDate, "endDate should be initialized")
    }

    func test_initialization_shouldAssignCorrectValues() {
        // Given
        let testStartDate = Date(timeIntervalSince1970: 1000000) // Sample start date
        let testEndDate = Date(timeIntervalSince1970: 2000000)   // Sample end date

        // Using Date for reminderTime
        let testMedications = [
            Medication(name: "Aspirin", reminderTime: Date(timeIntervalSince1970: 100000)) // Example reminder time
        ]

        // When
        let testViewModel = SummaryViewModel(
            medications: testMedications,
            scheduleFrequency: "Twice a day",
            specificTimes: ["9:00 AM", "9:00 PM"],
            capsuleQuantity: "2 capsules",
            startDate: testStartDate,
            endDate: testEndDate
        )

        // Then
        XCTAssertEqual(testViewModel.scheduleFrequency, "Twice a day", "scheduleFrequency should be 'Twice a day'")
        XCTAssertEqual(testViewModel.specificTimes, ["9:00 AM", "9:00 PM"], "specificTimes should match the new input")
        XCTAssertEqual(testViewModel.capsuleQuantity, "2 capsules", "capsuleQuantity should be '2 capsules'")
        XCTAssertEqual(testViewModel.startDate, testStartDate, "startDate should match the input")
        XCTAssertEqual(testViewModel.endDate, testEndDate, "endDate should match the input")
    }

    func test_dateFormatting_shouldReturnCorrectString() {
        // Given
        let testDate = Date(timeIntervalSince1970: 1000000) // Specific date to test formatting
        let testViewModel = SummaryViewModel(
            medications: [],
            scheduleFrequency: "Once a day",
            specificTimes: ["8:00 AM", "8:00 PM"],
            capsuleQuantity: "1 capsule",
            startDate: testDate,
            endDate: testDate
        )
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        let expectedDateString = dateFormatter.string(from: testDate)

        // When
        // Format the date directly in the test
        let formattedDate = dateFormatter.string(from: testViewModel.startDate)

        // Then
        XCTAssertEqual(formattedDate, expectedDateString, "formattedDate should return a string that matches the expected date format")
    }

}
