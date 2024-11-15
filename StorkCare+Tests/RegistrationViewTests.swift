import XCTest
import SwiftUI
import ViewInspector
@testable import StorkCare_

final class RegistrationViewTests: XCTestCase {
    
    var registrationView: RegistrationView!
    var isAuthenticated: Binding<Bool>!

    override func setUp() {
        super.setUp()

        // Mock binding for isAuthenticated
        var isAuthState = false
        isAuthenticated = Binding(get: { isAuthState }, set: { isAuthState = $0 })

        // Mock RegistrationViewModel
        let mockViewModel = RegistrationViewModel()
        mockViewModel.email = "test@example.com"
        mockViewModel.password = "password123"
        mockViewModel.role = "Healthcare Provider"

        // Initialize RegistrationView
        registrationView = RegistrationView(isAuthenticated: isAuthenticated, viewModel: mockViewModel)
    }

    // Test that the registration title is correct
    func testRegisterTitle() throws {
        let title = try registrationView.inspect().find(text: "Register for StorkCare+")
        XCTAssertEqual(try title.string(), "Register for StorkCare+")
    }

    func testEmailTextField() throws {
        // Inspect the form or container that holds the text fields
        let form = try registrationView.inspect().find(viewWithId: "EmailForm")
        
        // Then look for the text field within that container
        let emailTextField = try form.textField(0) // Check the correct index
        XCTAssertNotNil(emailTextField, "The 'EmailTextField' should be found.")
        
        // Set input and verify view model
        try emailTextField.setInput("test@example.com")
        XCTAssertEqual(registrationView.viewModel.email, "test@example.com")
    }




    // Test that the password secure field exists and updates correctly
    func testPasswordSecureField() throws {
        // Access the SecureField directly via its index in the VStack
        let passwordField = try registrationView.inspect().vStack().secureField(1) // Adjust index if necessary
        
        XCTAssertNotNil(passwordField, "The 'PasswordSecureField' should be found.")
        
        // Optional: Set a test password to verify the binding
        try passwordField.setInput("Test123!")
        XCTAssertEqual(registrationView.viewModel.password, "Test123!", "The password field binding should update the view model.")
    }

    // Test that the role picker exists
    func testRolePicker() throws {
        let rolePicker = try registrationView.inspect().find(viewWithId: "RolePicker")
        XCTAssertNotNil(rolePicker, "The 'RolePicker' should be found.")
    }

    // Test that the register button exists
    func testRegisterButton() throws {
        let registerButton = try registrationView.inspect().find(viewWithId: "RegisterButton")
        XCTAssertNotNil(registerButton, "The 'RegisterButton' should be found.")
    }

    func testLoadingProgressView() throws {
        // If the ProgressView is inside a VStack, search for it within the correct context
        let progressView = try registrationView.inspect().vStack().find(viewWithId: "LoadingProgressView")
        XCTAssertNotNil(progressView, "The 'LoadingProgressView' should be found.")
    }

    func testMessageLabel() throws {
        // If the MessageLabel is inside a container, search for it in the correct context
        let messageLabel = try registrationView.inspect().vStack().find(viewWithId: "MessageLabel")
        XCTAssertNotNil(messageLabel, "The 'MessageLabel' should be found.")
    }

    // Test that the register button action triggers the correct logic
    func testRegisterButtonAction() throws {
        let registerButton = try registrationView.inspect().find(viewWithId: "RegisterButton")
        try registerButton.button().tap()

        // Assert registration logic
        XCTAssertEqual(registrationView.viewModel.email, "test@example.com")
        XCTAssertEqual(registrationView.viewModel.password, "password123")
        XCTAssertEqual(registrationView.viewModel.role, "Healthcare Provider")
    }
}
