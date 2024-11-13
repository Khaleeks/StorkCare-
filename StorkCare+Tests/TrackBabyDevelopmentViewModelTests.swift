//
//  TrackBabyDevelopmentViewModelTests.swift
//  StorkCare+
//
//  Created by Khaleeqa Garrett on 11/13/24.
//


import XCTest
@testable import StorkCare_

final class TrackBabyDevelopmentViewModelTests: XCTestCase {
    
    func testInitialState() {
        let viewModel = TrackBabyDevelopmentViewModel()
        
        XCTAssertNil(viewModel.currentWeek)
        XCTAssertNil(viewModel.developmentInfo)
        XCTAssertEqual(viewModel.errorMessage, "")
        XCTAssertEqual(viewModel.hasEntry, false)
        XCTAssertEqual(viewModel.validate, 0)
    }
    
    func testConceptionDateValidation() {
        let viewModel = TrackBabyDevelopmentViewModel()
        
        // Valid conception date (e.g., 10 weeks ago)
        viewModel.conceptionDate = Calendar.current.date(byAdding: .weekOfYear, value: -10, to: Date())!
        viewModel.updateConceptionDate()
        XCTAssertEqual(viewModel.validate, 1, "Expected validation to be successful with valid conception date.")
        
        // Invalid conception date (e.g., 50 weeks ago)
        viewModel.conceptionDate = Calendar.current.date(byAdding: .weekOfYear, value: -50, to: Date())!
        viewModel.updateConceptionDate()
        XCTAssertEqual(viewModel.validate, 2, "Expected validation to fail with an out-of-bounds conception date.")
    }

    func testCalculateCurrentWeek() {
        let viewModel = TrackBabyDevelopmentViewModel()
        
        // Set a valid conception date 20 weeks ago
        viewModel.conceptionDate = Calendar.current.date(byAdding: .weekOfYear, value: -20, to: Date())!
        viewModel.calculateCurrentWeek()
        
        XCTAssertEqual(viewModel.currentWeek, 20, "Expected current week to be 20 for a conception date 20 weeks ago.")
        XCTAssertNotNil(viewModel.developmentInfo, "Expected development info for the 20th week.")
        
        // Set an out-of-bounds conception date (e.g., 45 weeks ago)
        viewModel.conceptionDate = Calendar.current.date(byAdding: .weekOfYear, value: -45, to: Date())!
        viewModel.calculateCurrentWeek()
        
        XCTAssertNil(viewModel.developmentInfo, "Expected no development info for an out-of-bounds week.")
    }
    
    func testHasEntryUpdatesAfterValidConceptionDate() {
        let viewModel = TrackBabyDevelopmentViewModel()
        
        // Set valid conception date and update entry
        viewModel.conceptionDate = Calendar.current.date(byAdding: .weekOfYear, value: -10, to: Date())!
        viewModel.updateConceptionDate()
        
        XCTAssertTrue(viewModel.hasEntry, "Expected hasEntry to be true after valid conception date.")
    }
}
