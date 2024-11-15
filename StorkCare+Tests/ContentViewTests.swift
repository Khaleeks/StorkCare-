//
//  ContentViewTests.swift
//  StorkCare+
//
//  Created by Khaleeqa Garrett on 11/15/24.
//


import XCTest
import SwiftUI
@testable import StorkCare_
final class ContentViewTests: XCTestCase {

    func testFilteredUseCases_noSearchText() {
        // Arrange
        let contentView = ContentView()

        // Act
        let filtered = contentView.filteredUseCases

        // Assert
        XCTAssertEqual(filtered.count, 4, "Filtered use cases should include all use cases when search text is empty.")
    }

    func testFilteredUseCases_withMatchingSearchText() {
        // Arrange
        var contentView = ContentView()
        contentView.searchText = "baby"

        // Act
        let filtered = contentView.filteredUseCases

        // Assert
        XCTAssertEqual(filtered.count, 1, "Filtered use cases should include only matching titles.")
        XCTAssertEqual(filtered.first?.title, "Track Baby Development", "The filtered title should match the search text.")
    }

    func testFilteredUseCases_withNonMatchingSearchText() {
        // Arrange
        var contentView = ContentView()
        contentView.searchText = "nonexistent"

        // Act
        let filtered = contentView.filteredUseCases

        // Assert
        XCTAssertTrue(filtered.isEmpty, "Filtered use cases should be empty when no titles match the search text.")
    }

    func testNavigationDestination_trackBabyDevelopment() {
        // Arrange
        let contentView = ContentView()
        let trackBabyDevelopmentView = contentView.destinationView(for: "Track Baby Development")

        // Assert
        XCTAssertTrue(trackBabyDevelopmentView is TrackBabyDevelopmentView, "Should navigate to TrackBabyDevelopmentView.")
    }

    func testNavigationDestination_scheduleTelehealthConsultation() {
        // Arrange
        let contentView = ContentView()
        let scheduleTelehealthView = contentView.destinationView(for: "Schedule Telehealth Consultation")

        // Assert
        XCTAssertTrue(scheduleTelehealthView is ScheduleTelehealthView, "Should navigate to ScheduleTelehealthView.")
    }

    func testNavigationDestination_medicationReminder() {
        // Arrange
        var contentView = ContentView()
        contentView.medications = []

        let medicationView = contentView.destinationView(for: "Medication Reminder")

        // Assert
        XCTAssertTrue(medicationView is SetupMedicationView, "Should navigate to SetupMedicationView.")
    }

    func testNavigationDestination_providerAvailability() {
        // Arrange
        let contentView = ContentView()
        let providerAvailabilityView = contentView.destinationView(for: "Provider Availability")

        // Assert
        XCTAssertTrue(providerAvailabilityView is ProviderAvailabilityView, "Should navigate to ProviderAvailabilityView.")
    }

    func testNavigationDestination_unknownUseCase() {
        // Arrange
        let contentView = ContentView()
        let unknownView = contentView.destinationView(for: "Unknown Use Case")

        // Assert
        XCTAssertTrue(unknownView is Text, "Unknown use case should default to a Text view.")
    }
}
