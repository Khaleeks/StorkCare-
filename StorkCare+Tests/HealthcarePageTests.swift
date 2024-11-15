import XCTest
import SwiftUI
import ViewInspector
@testable import StorkCare_

// Extend HealthcarePage to conform to ViewInspector for testing
extension HealthcarePage: Inspectable {}

final class HealthcarePageTests: XCTestCase {
    
    var mockFirestoreService: MockFirestoreService!
    var viewModel: HealthcarePageViewModel!
    var view: HealthcarePage!
    
    override func setUp() {
        super.setUp()
        mockFirestoreService = MockFirestoreService()
        viewModel = HealthcarePageViewModel(firestoreService: mockFirestoreService)
        view = HealthcarePage(uid: "testUID")
    }
    
    override func tearDown() {
        mockFirestoreService = nil
        viewModel = nil
        view = nil
        super.tearDown()
    }
    
    // Test 1: Verify Title Text
    func testTitleText() throws {
        let title = try view.inspect().find(viewWithTag: 1).text().string()
        XCTAssertEqual(title, "Healthcare Provider Onboarding", "The title text does not match the expected value.")
    }
    
    // Test 2: Verify TextField Bindings
    func testTextFieldBindings() throws {
        // Gender TextField
        let genderTextField = try view.inspect().find(viewWithTag: 2).textField()
        try genderTextField.setInput("Female")
        XCTAssertEqual(try genderTextField.input(), "Female", "The gender TextField did not correctly bind the input.")
        
        // Occupation TextField
        let occupationTextField = try view.inspect().find(viewWithTag: 3).textField()
        try occupationTextField.setInput("Doctor")
        XCTAssertEqual(try occupationTextField.input(), "Doctor", "The occupation TextField did not correctly bind the input.")
        
        // Place of Work TextField
        let placeOfWorkTextField = try view.inspect().find(viewWithTag: 4).textField()
        try placeOfWorkTextField.setInput("Hospital")
        XCTAssertEqual(try placeOfWorkTextField.input(), "Hospital", "The place of work TextField did not correctly bind the input.")
    }
    
    // Test 3: Verify Complete Onboarding Button Success
    func testCompleteOnboardingButtonSuccess() throws {
        // Set up the mock service for success
        let mockFirestoreService = MockFirestoreService()
        mockFirestoreService.result = .success(())
        
        // Initialize the ViewModel with the mock service
        let viewModel = HealthcarePageViewModel(firestoreService: mockFirestoreService)
        let view = HealthcarePage(uid: "testUID", viewModel: viewModel)
        
        // Wrap the view for testing (ViewInspector requirement)
        let inspectedView = try view.inspect()
        
        // Fill all fields
        try inspectedView.find(viewWithTag: 2).textField().setInput("Female")
        try inspectedView.find(viewWithTag: 3).textField().setInput("Doctor")
        try inspectedView.find(viewWithTag: 4).textField().setInput("Hospital")
        
        // Tap Complete Onboarding button
        let completeButton = try inspectedView.find(viewWithTag: 5).button()
        try completeButton.tap()
        
        // Wait for updates
        let expectation = self.expectation(description: "Wait for onboarding success")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { expectation.fulfill() }
        wait(for: [expectation], timeout: 1.0)
        
        // Verify the message text
        let messageText = try inspectedView.find(viewWithTag: 6).text().string()
        XCTAssertEqual(messageText, "Onboarding complete!", "The success message does not match the expected value.")
    }




    
    // Test 4: Verify Message Display on Failure
    func testMessageDisplayOnFailure() throws {
        // Simulate Firestore failure
        let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Network error"])
        mockFirestoreService.result = .failure(error)
        
        // Fill some fields and leave one empty
        try view.inspect().find(viewWithTag: 2).textField().setInput("Female")
        try view.inspect().find(viewWithTag: 3).textField().setInput("")
        try view.inspect().find(viewWithTag: 4).textField().setInput("Hospital")
        
        // Tap Complete Onboarding button
        let completeButton = try view.inspect().find(viewWithTag: 5).button()
        try completeButton.tap()
        
        // Wait for updates
        let expectation = self.expectation(description: "Wait for onboarding failure")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { expectation.fulfill() }
        wait(for: [expectation], timeout: 1.0)
        
        // Verify message
        let messageText = try view.inspect().find(viewWithTag: 6).text().string()
        XCTAssertEqual(messageText, "Please fill in all fields", "The error message does not match the expected value.")
    }
}
