import XCTest
import SwiftUI
import ViewInspector
@testable import StorkCare_

class PregnantWomanPageTests: XCTestCase {
    var viewModel: PregnantWomanViewModel!
    var isAuthenticated: Binding<Bool>!
    
    override func setUp() {
        super.setUp()
        viewModel = PregnantWomanViewModel()
        isAuthenticated = .constant(true)
    }
    
    func testTextFieldsAndButtons() throws {
        let pregnantWomanPage = PregnantWomanPage(uid: "testUID", isAuthenticated: isAuthenticated)
        
        let title = try pregnantWomanPage.inspect().find(text: "Personalized Health Data")
        XCTAssertEqual(try title.string(), "Personalized Health Data")
        
        let continueButton = try pregnantWomanPage.inspect().find(button: "Continue")
        let buttonText = try continueButton.labelView().text().string()
        XCTAssertEqual(buttonText, "Continue")
    }
    
    func testPickerInteractions() throws {
        let pregnantWomanPage = PregnantWomanPage(uid: "testUID", isAuthenticated: isAuthenticated)
        
        viewModel.showHeightPicker = true
        let heightPickerSheet = try pregnantWomanPage.inspect().find(ViewType.Picker.self, where: { view in
            try view.accessibilityIdentifier() == "HeightPicker"
        })
        XCTAssertNotNil(heightPickerSheet)
    }
    
    func testFormFields() throws {
        let pregnantWomanPage = PregnantWomanPage(uid: "testUID", isAuthenticated: isAuthenticated)
        
        let nameField = try pregnantWomanPage.inspect().find(viewWithTag: 1).textField()
        XCTAssertNotNil(nameField)
        try nameField.setInput("Test Name")
        XCTAssertEqual(viewModel.name, "Test Name")
    }
    
    func testContinueButtonFunctionality() throws {
        let pregnantWomanPage = PregnantWomanPage(uid: "testUID", isAuthenticated: isAuthenticated)
        
        viewModel.name = "Alice"
        viewModel.selectedSex = "Female"
        viewModel.selectedHeight = 170
        viewModel.selectedWeight = 65
        
        let continueButton = try pregnantWomanPage.inspect().find(button: "Continue")
        try continueButton.tap()
        
        XCTAssertTrue(viewModel.isProfileCreated)
    }
    
    func testIncompleteProfileData() throws {
        let pregnantWomanPage = PregnantWomanPage(uid: "testUID", isAuthenticated: isAuthenticated)
        
        viewModel.name = ""
        viewModel.selectedSex = "Female"
        viewModel.selectedHeight = 0
        viewModel.selectedWeight = 65
        
        let continueButton = try pregnantWomanPage.inspect().find(button: "Continue")
        try continueButton.tap()
        
        XCTAssertFalse(viewModel.isProfileCreated)
    }
    
    func testAccessibilityLabels() throws {
        let pregnantWomanPage = PregnantWomanPage(uid: "testUID", isAuthenticated: isAuthenticated)
        
        let nameTextField = try pregnantWomanPage.inspect().find(ViewType.TextField.self, where: { view in
            try view.accessibilityLabel().string() == "Name"
        })
        XCTAssertNotNil(nameTextField)
    }
}
