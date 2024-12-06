import XCTest
@testable import StorkCare_

class RegistrationViewModelTests: XCTestCase {

    var viewModel: RegistrationViewModel!

    override func setUp() {
        super.setUp()
        viewModel = RegistrationViewModel()
    }

    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }

    // Test email validation
    func testValidateEmail_ValidEmail_ReturnsTrue() {
        viewModel.email = "test@example.com"
        XCTAssertTrue(viewModel.validateEmail())
    }

    func testValidateEmail_InvalidEmail_ReturnsFalse() {
        viewModel.email = "invalidemail.com"
        XCTAssertFalse(viewModel.validateEmail())
    }

    // Test password validation
    func testValidatePassword_ValidPassword_ReturnsTrue() {
        viewModel.password = "Password1!"
        XCTAssertTrue(viewModel.validatePassword())
    }

    func testValidatePassword_InvalidPassword_ReturnsFalse() {
        viewModel.password = "short"
        XCTAssertFalse(viewModel.validatePassword())
    }

    // Test registration flow with valid data
    func testRegisterUser_ValidData_Success() {
        // Simulate a valid user registration
        viewModel.email = "test@example.com"
        viewModel.password = "Password1!"
        viewModel.role = "Healthcare Provider"
        
        let expectation = self.expectation(description: "Registration success")
        
        viewModel.registerUser()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            XCTAssertEqual(self.viewModel.message, "Registration successful!")
            XCTAssertTrue(self.viewModel.isAuthenticated)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 3.0)
    }

    // Test registration with invalid email
    func testRegisterUser_InvalidEmail_ErrorMessage() {
        viewModel.email = "invalidemail.com"
        viewModel.password = "Password1!"
        viewModel.role = "Healthcare Provider"
        
        viewModel.registerUser()
        
        XCTAssertEqual(viewModel.message, "Invalid email format.")
        XCTAssertFalse(viewModel.isAuthenticated)
    }

    // Test registration with invalid password
    func testRegisterUser_InvalidPassword_ErrorMessage() {
        viewModel.email = "test@example.com"
        viewModel.password = "short"
        viewModel.role = "Healthcare Provider"
        
        viewModel.registerUser()
        
        XCTAssertEqual(viewModel.message, "Password must be at least 6 to 30 characters long, contain a number, and a special character.")
        XCTAssertFalse(viewModel.isAuthenticated)
    }

    // Test registration with no role selected
    func testRegisterUser_NoRole_ErrorMessage() {
        viewModel.email = "test@example.com"
        viewModel.password = "Password1!"
        viewModel.role = ""
        
        viewModel.registerUser()
        
        XCTAssertEqual(viewModel.message, "Please select a role.")
        XCTAssertFalse(viewModel.isAuthenticated)
    }
}
