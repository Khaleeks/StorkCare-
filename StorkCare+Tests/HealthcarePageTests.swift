import XCTest
import SwiftUI
import ViewInspector
@testable import StorkCare_

final class HealthcarePageTests: XCTestCase {
    
    func testTitleText() throws {
        let view = HealthcarePage(uid: "testUID")
        let title = try view.inspect().find(viewWithTag: 1).text().string()
        
        XCTAssertEqual(title, "Healthcare Provider Onboarding")
    }
    
    func testTextFieldBindings() throws {
        let view = HealthcarePage(uid: "testUID")
        
        // Access and test the `gender` TextField binding
        let genderTextField = try view.inspect().find(viewWithTag: 2).textField()
        try genderTextField.setInput("Female")
        XCTAssertEqual(try genderTextField.input(), "Female")

        // Access and test the `occupation` TextField binding
        let occupationTextField = try view.inspect().find(viewWithTag: 3).textField()
        try occupationTextField.setInput("Doctor")
        XCTAssertEqual(try occupationTextField.input(), "Doctor")

        // Access and test the `placeOfWork` TextField binding
        let placeOfWorkTextField = try view.inspect().find(viewWithTag: 4).textField()
        try placeOfWorkTextField.setInput("Hospital")
        XCTAssertEqual(try placeOfWorkTextField.input(), "Hospital")
    }
    
    func testCompleteOnboardingButton() throws {
            let view = HealthcarePage(uid: "testUID")
            
            // Set values for TextFields as if user is filling them out
            try view.inspect().find(viewWithTag: 2).textField().setInput("Female")
            try view.inspect().find(viewWithTag: 3).textField().setInput("Doctor")
            try view.inspect().find(viewWithTag: 4).textField().setInput("Hospital")
            
            // Simulate button tap
            let completeButton = try view.inspect().find(viewWithTag: 5).button()
            try completeButton.tap()
            
            // Check for completion message to appear
            let messageText = try view.inspect().find(viewWithTag: 6).text().string()
            XCTAssertEqual(messageText, "Onboarding Complete") // Assuming this is the completion message
        }
    
    func testMessageDisplayOnFailure() throws {
            let view = HealthcarePage(uid: "testUID")
            
            // Leave a required field empty to simulate failure
            try view.inspect().find(viewWithTag: 2).textField().setInput("") // Gender is empty
            try view.inspect().find(viewWithTag: 3).textField().setInput("Doctor")
            try view.inspect().find(viewWithTag: 4).textField().setInput("Hospital")
            
            // Simulate button tap
            let completeButton = try view.inspect().find(viewWithTag: 5).button()
            try completeButton.tap()
            
            // Check for error message to appear
            let messageText = try view.inspect().find(viewWithTag: 6).text().string()
            XCTAssertEqual(messageText, "Please fill in all fields") // Assuming this is the error message
        }
}
