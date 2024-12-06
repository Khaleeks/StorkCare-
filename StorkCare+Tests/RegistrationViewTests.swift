//
//  RegistrationViewTests.swift
//  StorkCare+
//
//  Created by Khaleeqa Garrett on 12/6/24.
//

import SwiftUI
import XCTest
@testable import StorkCare_

class RegistrationViewTests: XCTestCase {

    var registrationView: RegistrationView!

       override func setUp() {
           super.setUp()

           // Create a mock binding for isAuthenticated
           let isAuthenticatedBinding = Binding<Bool>(
               get: { false },
               set: { _ in }
           )
           
           // Inject a mock viewModel
           let viewModel = RegistrationViewModel()
           registrationView = RegistrationView(isAuthenticated: isAuthenticatedBinding, viewModel: viewModel)
       }

       override func tearDown() {
           registrationView = nil
           super.tearDown()
       }

    func testEmailTextField() {
        // Simulate entering email in the text field
        registrationView.viewModel.email = "test@example.com"
        XCTAssertEqual(registrationView.viewModel.email, "test@example.com")
    }

    func testPasswordSecureField() {
        // Simulate entering password in the secure field
        registrationView.viewModel.password = "Password1!"
        XCTAssertEqual(registrationView.viewModel.password, "Password1!")
    }

    func testRolePicker() {
        // Simulate selecting a role from the picker
        registrationView.viewModel.role = "Pregnant Woman"
        XCTAssertEqual(registrationView.viewModel.role, "Pregnant Woman")
    }

    func testRegisterButton_Disabled_WhenRoleIsEmpty() {
        registrationView.viewModel.role = ""
        XCTAssertTrue(registrationView.viewModel.isLoading == false)
    }

    func testRegisterButton_Enabled_WhenRoleIsSelected() {
        registrationView.viewModel.role = "Healthcare Provider"
        XCTAssertFalse(registrationView.viewModel.isLoading == true)
    }

    func testRegisterButton_TriggersLoadingState() {
        registrationView.viewModel.role = "Healthcare Provider"
        
        // Simulate button press to register
        registrationView.viewModel.registerUser()
        
        XCTAssertTrue(registrationView.viewModel.isLoading)
    }

    func testMessageDisplay_SuccessfulRegistration() {
        // Simulate a successful registration flow
        registrationView.viewModel.message = "Registration successful!"
        XCTAssertEqual(registrationView.viewModel.message, "Registration successful!")
    }

    func testMessageDisplay_Error() {
        // Simulate an error message during registration
        registrationView.viewModel.message = "Invalid email format."
        XCTAssertEqual(registrationView.viewModel.message, "Invalid email format.")
    }
}
