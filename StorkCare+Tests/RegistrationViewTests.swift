import XCTest
import SwiftUI
import ViewInspector
@testable import StorkCare_

class RegistrationViewTests: XCTestCase {
    
    var registrationView: RegistrationView!
    var isAuthenticated: Binding<Bool>!
    
    override func setUp() {
        super.setUp()
        
        // Create a Binding for the isAuthenticated property
        isAuthenticated = Binding(get: { false }, set: { _ in })
        
        // Initialize RegistrationView with the Binding
        registrationView = RegistrationView(isAuthenticated: isAuthenticated)
    }

    func testRegisterTitle() throws {
        let view = try registrationView.inspect()
        let registerTitle = try view.find(viewWithId: "RegisterTitle")
        XCTAssertNotNil(registerTitle)
    }

    func testEmailTextField() throws {
        let view = try registrationView.inspect()
        let emailTextField = try view.find(viewWithId: "EmailTextField")
        XCTAssertNotNil(emailTextField)
    }

    func testPasswordSecureField() throws {
        let view = try registrationView.inspect()
        let passwordField = try view.find(viewWithId: "PasswordSecureField")
        XCTAssertNotNil(passwordField)
    }

    func testRolePicker() throws {
        let view = try registrationView.inspect()
        let rolePicker = try view.find(viewWithId: "RolePicker")
        XCTAssertNotNil(rolePicker)
    }

    func testRegisterButton() throws {
        let view = try registrationView.inspect()
        let registerButton = try view.find(viewWithId: "RegisterButton")
        XCTAssertNotNil(registerButton)
    }

    func testMessageLabel() throws {
        let view = try registrationView.inspect()
        let messageLabel = try view.find(viewWithId: "MessageLabel")
        XCTAssertNotNil(messageLabel)
    }

    func testLoadingProgressView() throws {
        let view = try registrationView.inspect()
        let loadingProgressView = try view.find(viewWithId: "LoadingProgressView")
        XCTAssertNotNil(loadingProgressView)
    }
}
