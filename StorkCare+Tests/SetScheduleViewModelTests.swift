//
//  SetScheduleViewModelTests.swift
//  StorkCare+
//
//  Created by Khaleeqa Garrett on 11/11/24.
//


import XCTest
@testable import StorkCare_

final class SetScheduleViewModelTests: XCTestCase {

    func testAddTime_ShouldAddTimeToSpecificTimes() {
        let viewModel = SetScheduleViewModel()

        // Get initial count of specificTimes
        let initialCount = viewModel.specificTimes.count

        // Simulate adding a time
        let time = Date() // Just an example time
        viewModel.addTime(time)

        // Verify that the time is added
        XCTAssertEqual(viewModel.specificTimes.count, initialCount + 1)
    }

    func testOnNextButtonTapped_ShouldShowErrorIfNoTimeAdded() {
        let viewModel = SetScheduleViewModel()

        // Initially, showErrorMessage should be false
        XCTAssertFalse(viewModel.showErrorMessage)

        // Simulate tapping the Next button with no time added
        viewModel.onNextButtonTapped()

        // Verify that showErrorMessage becomes true
        XCTAssertTrue(viewModel.showErrorMessage)
    }

    func testOnNextButtonTapped_ShouldShowSummaryIfTimeAdded() {
        let viewModel = SetScheduleViewModel()

        // Simulate adding a time
        let time = Date()
        viewModel.addTime(time)

        // Initially, showErrorMessage should be false
        XCTAssertFalse(viewModel.showErrorMessage)

        // Simulate tapping the Next button with a time added
        viewModel.onNextButtonTapped()

        // Verify that showSummary becomes true
        XCTAssertTrue(viewModel.showSummary)
    }
}
