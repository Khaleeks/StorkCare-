//
//  TrackBabyDevelopmentViewTests.swift
//  StorkCare+
//
//  Created by Khaleeqa Garrett on 11/15/24.
//


import XCTest
import SwiftUI
import ViewInspector
@testable import StorkCare_

class TrackBabyDevelopmentViewTests: XCTestCase {
    
    var trackBabyDevelopmentView: TrackBabyDevelopmentView!
    
    override func setUp() {
        super.setUp()
        trackBabyDevelopmentView = TrackBabyDevelopmentView()
    }

    func testBabyInTitle() throws {
        let view = try trackBabyDevelopmentView.inspect()
        let babyInTitle = try view.find(viewWithId: "BabyInTitle")
        XCTAssertNotNil(babyInTitle)
    }

    func testTrackBabyDevelopmentTitle() throws {
        let view = try trackBabyDevelopmentView.inspect()
        let trackBabyTitle = try view.find(viewWithId: "TrackBabyDevelopmentTitle")
        XCTAssertNotNil(trackBabyTitle)
    }

    func testConceptionDateInstructions() throws {
        let view = try trackBabyDevelopmentView.inspect()
        let instructions = try view.find(viewWithId: "ConceptionDateInstructions")
        XCTAssertNotNil(instructions)
    }

    func testConceptionDatePicker() throws {
        let view = try trackBabyDevelopmentView.inspect()
        let datePicker = try view.find(viewWithId: "ConceptionDatePicker")
        XCTAssertNotNil(datePicker)
    }

    func testUpdateStartDateButton() throws {
        let view = try trackBabyDevelopmentView.inspect()
        let button = try view.find(viewWithId: "UpdateStartDateButton")
        XCTAssertNotNil(button)
    }

    func testCalculateCurrentWeekButton() throws {
        let view = try trackBabyDevelopmentView.inspect()
        let button = try view.find(viewWithId: "CalculateCurrentWeekButton")
        XCTAssertNotNil(button)
    }

    func testProgressBar() throws {
        let view = try trackBabyDevelopmentView.inspect()
        let progressBar = try view.find(viewWithId: "ProgressBar")
        XCTAssertNotNil(progressBar)
    }

    func testDevelopmentInfoLabel() throws {
        let view = try trackBabyDevelopmentView.inspect()
        let infoLabel = try view.find(viewWithId: "DevelopmentInfoLabel")
        XCTAssertNotNil(infoLabel)
    }

    func testWeeksLeftLabel() throws {
        let view = try trackBabyDevelopmentView.inspect()
        let weeksLeftLabel = try view.find(viewWithId: "WeeksLeftLabel")
        XCTAssertNotNil(weeksLeftLabel)
    }
}
