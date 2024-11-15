import XCTest
import SwiftUI
import ViewInspector
@testable import StorkCare_

class PregnantWomanPageTests: XCTestCase {
    
    func testTextFieldsAndButtons() throws {
        let viewModel = PregnantWomanViewModel()
        let pregnantWomanPage = PregnantWomanPage(viewModel: viewModel, uid: "testUID")
        
        // Inspect the title text
        let title = try pregnantWomanPage.inspect().find(text: "Personalized Health Data")
        XCTAssertEqual(try title.string(), "Personalized Health Data")
        
        // Verify the 'Continue' button exists and has correct text
        let continueButton = try pregnantWomanPage.inspect().find(button: "Continue")
        let buttonText = try continueButton.labelView().text().string()
        XCTAssertEqual(buttonText, "Continue")
    }
    
    func testPickerInteractions() throws {
        let viewModel = PregnantWomanViewModel()
        let pregnantWomanPage = PregnantWomanPage(viewModel: viewModel, uid: "testUID")
        
        // Simulate toggling the height picker
        viewModel.showHeightPicker = true
        let heightPickerSheet = try pregnantWomanPage.inspect().find(ViewType.Picker.self, where: { view in
            try view.accessibilityIdentifier() == "HeightPicker"
        })
        XCTAssertNotNil(heightPickerSheet, "Height picker should appear when toggled.")
        
        // Simulate toggling the weight picker
        viewModel.showWeightPicker = true
        let weightPickerSheet = try pregnantWomanPage.inspect().find(ViewType.Picker.self, where: { view in
            try view.accessibilityIdentifier() == "WeightPicker"
        })
        XCTAssertNotNil(weightPickerSheet, "Weight picker should appear when toggled.")
    }


    func testFormFields() throws {
        let viewModel = PregnantWomanViewModel()
        let pregnantWomanPage = PregnantWomanPage(viewModel: viewModel, uid: "testUID")
        
        // Inspect the name TextField
        let nameField = try pregnantWomanPage.inspect().find(viewWithTag: 1).textField()
        XCTAssertNotNil(nameField)
        try nameField.setInput("Test Name")
        XCTAssertEqual(viewModel.name, "Test Name")
        
        // Verify the initial value of Sex field
        XCTAssertEqual(viewModel.selectedSex, "")
    }
    
    func testContinueButtonFunctionality() throws {
        let viewModel = PregnantWomanViewModel()
        let pregnantWomanPage = PregnantWomanPage(viewModel: viewModel, uid: "testUID")
        
        // Set required fields
        viewModel.name = "Alice"
        viewModel.selectedSex = "Female"
        viewModel.selectedHeight = 170
        viewModel.selectedWeight = 65
        
        // Simulate Continue button tap
        let continueButton = try pregnantWomanPage.inspect().find(button: "Continue")
        try continueButton.tap()
        
        // Assert profile creation
        XCTAssertTrue(viewModel.isProfileCreated, "Profile should be created when all fields are filled correctly.")
    }
    
    func testIncompleteProfileData() throws {
        let viewModel = PregnantWomanViewModel()
        let pregnantWomanPage = PregnantWomanPage(viewModel: viewModel, uid: "testUID")
        
        // Leave required fields empty
        viewModel.name = ""
        viewModel.selectedSex = "Female"
        viewModel.selectedHeight = 0
        viewModel.selectedWeight = 65
        
        // Simulate Continue button tap
        let continueButton = try pregnantWomanPage.inspect().find(button: "Continue")
        try continueButton.tap()
        
        // Assert profile creation fails
        XCTAssertFalse(viewModel.isProfileCreated, "Profile creation should fail when required fields are missing.")
    }
    
    func testResetFieldsFunctionality() throws {
        let viewModel = PregnantWomanViewModel()
        
        // Set values
        viewModel.name = "Test Name"
        viewModel.selectedSex = "Female"
        viewModel.selectedHeight = 170
        viewModel.selectedWeight = 65
        
        // Reset fields
        viewModel.resetFields()
        
        // Assert all fields are cleared
        XCTAssertEqual(viewModel.name, "")
        XCTAssertEqual(viewModel.selectedSex, "")
        XCTAssertEqual(viewModel.selectedHeight, 0)
        XCTAssertEqual(viewModel.selectedWeight, 0)
        XCTAssertFalse(viewModel.isProfileCreated, "Profile creation flag should reset to false.")
    }
    
    func testAccessibilityLabels() throws {
        let viewModel = PregnantWomanViewModel()
        let pregnantWomanPage = PregnantWomanPage(viewModel: viewModel, uid: "testUID")
        
        // Locate the text field with the accessibility label "Name"
        let nameTextField = try pregnantWomanPage.inspect().find(ViewType.TextField.self, where: { view in
            let label = try view.accessibilityLabel().string()
            return label == "Name"
        })
        XCTAssertNotNil(nameTextField)
        
        // Locate the button with the accessibility label "Continue"
        let continueButton = try pregnantWomanPage.inspect().find(ViewType.Button.self, where: { view in
            let label = try view.accessibilityLabel().string()
            return label == "Continue"
        })
        XCTAssertNotNil(continueButton)
    }
}
