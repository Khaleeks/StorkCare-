// RegistrationViewModelTests.swift
// StorkCare+
//
// Created by Khaleeqa Garrett on 11/11/24.
//

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

    func testEmailValidation_ValidEmail() {
        viewModel.email = "test@example.com"
        XCTAssertTrue(viewModel.validateEmail(), "The email should be valid.")
    }

    func testEmailValidation_InvalidEmail() {
        viewModel.email = "invalidemail"
        XCTAssertFalse(viewModel.validateEmail(), "The email should be invalid.")
    }

    func testEmailValidation_EmptyEmail() {
        viewModel.email = ""
        XCTAssertFalse(viewModel.validateEmail(), "The email should be invalid when empty.")
    }

    func testPasswordValidation_ValidPassword() {
        viewModel.password = "Password1!"
        XCTAssertTrue(viewModel.validatePassword(), "The password should be valid.")
    }

    func testPasswordValidation_InvalidPassword_NoNumber() {
        viewModel.password = "Password!"
        XCTAssertFalse(viewModel.validatePassword(), "The password should be invalid without a number.")
    }

    func testPasswordValidation_InvalidPassword_NoSpecialCharacter() {
        viewModel.password = "Password123"
        XCTAssertFalse(viewModel.validatePassword(), "The password should be invalid without a special character.")
    }

    func testPasswordValidation_EmptyPassword() {
        viewModel.password = ""
        XCTAssertFalse(viewModel.validatePassword(), "The password should be invalid when empty.")
    }

    func testRegisterUser_ValidInput() {
        viewModel.email = "test@example.com"
        viewModel.password = "Password1!"
        viewModel.role = "Pregnant Woman"

        viewModel.registerUser()

        XCTAssertTrue(viewModel.isAuthenticated, "The user should be authenticated.")
        XCTAssertEqual(viewModel.message, "Registration successful!", "The registration message should be success.")
    }

    func testRegisterUser_InvalidEmail() {
        viewModel.email = "invalidemail"
        viewModel.password = "Password1!"
        viewModel.role = "Pregnant Woman"

        viewModel.registerUser()

        XCTAssertFalse(viewModel.isAuthenticated, "The user should not be authenticated with invalid email.")
        XCTAssertEqual(viewModel.message, "Invalid email format.", "The error message should indicate invalid email format.")
    }

    func testRegisterUser_InvalidPassword() {
        viewModel.email = "test@example.com"
        viewModel.password = "Password"
        viewModel.role = "Pregnant Woman"

        viewModel.registerUser()

        XCTAssertFalse(viewModel.isAuthenticated, "The user should not be authenticated with invalid password.")
        XCTAssertEqual(viewModel.message, "Password must be at least 6 to 30 characters long, contain a number, and a special character.", "The error message should indicate invalid password.")
    }

    func testRegisterUser_EmptyRole() {
        viewModel.email = "test@example.com"
        viewModel.password = "Password1!"
        viewModel.role = ""

        viewModel.registerUser()

        XCTAssertFalse(viewModel.isAuthenticated, "The user should not be authenticated when the role is empty.")
        XCTAssertEqual(viewModel.message, "Please select a role.", "The error message should indicate that a role needs to be selected.")
    }

    func testRegisterUser_SuccessfulWithHealthcareProviderRole() {
        viewModel.email = "provider@example.com"
        viewModel.password = "Password1!"
        viewModel.role = "Healthcare Provider"

        viewModel.registerUser()

        XCTAssertTrue(viewModel.isAuthenticated, "The user should be authenticated.")
        XCTAssertEqual(viewModel.message, "Registration successful!", "The registration message should be success.")
    }

    func testRegisterUser_InvalidRoleWithSpaces() {
        viewModel.email = "test@example.com"
        viewModel.password = "Password1!"
        viewModel.role = "Pregnant Woman "

        viewModel.registerUser()

        XCTAssertTrue(viewModel.isAuthenticated, "The user should be authenticated even if the role contains trailing spaces.")
        XCTAssertEqual(viewModel.message, "Registration successful!", "The registration message should be success.")
    }

    func testAuthenticationState_AfterRegistration() {
        viewModel.email = "test@example.com"
        viewModel.password = "Password1!"
        viewModel.role = "Pregnant Woman"

        viewModel.registerUser()

        XCTAssertTrue(viewModel.isAuthenticated, "The user should be authenticated after successful registration.")
    }

    func testPasswordValidation_MinimumLength() {
        viewModel.password = "P@ssw1"
        XCTAssertTrue(viewModel.validatePassword(), "The password should be valid when it's exactly 6 characters long.")
    }

}
