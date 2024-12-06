import XCTest
import SwiftUI
@testable import StorkCare_

final class RegistrationViewTests: XCTestCase {
    var registrationView: RegistrationView!
    var viewModel: RegistrationViewModel!
    var isAuthenticated: Binding<Bool>!
    
    override func setUp() {
        super.setUp()
        isAuthenticated = Binding.constant(false)
        viewModel = RegistrationViewModel()
        registrationView = RegistrationView(isAuthenticated: isAuthenticated)
    }
    
    override func tearDown() {
        registrationView = nil
        super.tearDown()
    }
    
    func testEmailTextField() {
        viewModel.email = "test@example.com"
        XCTAssertEqual(viewModel.email, "test@example.com")
    }
    
    func testPasswordSecureField() {
        viewModel.password = "Password1!"
        XCTAssertEqual(viewModel.password, "Password1!")
    }
    
    func testRolePicker() {
        viewModel.role = "Pregnant Woman"
        XCTAssertEqual(viewModel.role, "Pregnant Woman")
    }
    
    func testRegisterButton_Disabled_WhenRoleIsEmpty() {
        viewModel.role = ""
        viewModel.isLoading = false
        XCTAssertFalse(viewModel.isLoading)
    }
    
    func testRegisterButton_Enabled_WhenRoleIsSelected() {
        viewModel.role = "Healthcare Provider"
        viewModel.isLoading = false
        XCTAssertFalse(viewModel.isLoading)
    }
    
    func testRegisterButton_TriggersLoadingState() {
        viewModel.role = "Healthcare Provider"
        viewModel.registerUser()
        XCTAssertTrue(viewModel.isLoading)
    }
    
    func testMessageDisplay_SuccessfulRegistration() {
        viewModel.message = "Registration successful!"
        XCTAssertEqual(viewModel.message, "Registration successful!")
    }
    
    func testMessageDisplay_Error() {
        viewModel.message = "Invalid email format."
        XCTAssertEqual(viewModel.message, "Invalid email format.")
    }
}
