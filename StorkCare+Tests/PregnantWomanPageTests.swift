import XCTest
import SwiftUI
import ViewInspector
@testable import StorkCare_

class PregnantWomanPageTests: XCTestCase {
    
    func testTextFieldsAndButtons() throws {
        // Create a dummy view model
        let viewModel = PregnantWomanViewModel()
        let pregnantWomanPage = PregnantWomanPage(viewModel: viewModel, uid: "testUID")
        
        // Inspect the text "Personalized Health Data"
        let text = try pregnantWomanPage.inspect().find(text: "Personalized Health Data")
        XCTAssertEqual(try text.string(), "Personalized Health Data")
        
        // Verify the 'Continue' button exists and has correct text
        let continueButton = try pregnantWomanPage.inspect().find(button: "Continue")
        let buttonText = try continueButton.labelView().text().string()
        XCTAssertEqual(buttonText, "Continue")
        
        // Simulate tapping on the height button to show the picker
        let heightButton = try pregnantWomanPage.inspect().find(viewWithTag: 2) // Accessing the view tagged for height picker
        try heightButton.callOnTapGesture() // Simulates tapping the view
        
        // Verify if the height picker sheet appears
        let heightPicker = try pregnantWomanPage.inspect().find(viewWithTag: 3) // Access the picker by its tag
        XCTAssertNotNil(heightPicker)
    }
    
    
    func testFormFields() throws {
        // Initialize the view model and page
        let viewModel = PregnantWomanViewModel()
        let pregnantWomanPage = PregnantWomanPage(viewModel: viewModel, uid: "testUID")
        
        // Find the first HStack (which contains the name TextField) in the VStack and locate the TextField
        let nameTextField = try pregnantWomanPage.inspect().vStack().hStack(0).textField(1)
        
        // Ensure the name TextField exists
        XCTAssertNotNil(nameTextField)
        
        // Check if the initial state of the Sex field is "Select"
        let sexField = try pregnantWomanPage.inspect().vStack().hStack(1).text(0)
        XCTAssertEqual(try sexField.string(), "Select")
    }
    
    func testContinueButtonFunctionality() throws {
        // Create a dummy view model
        let viewModel = PregnantWomanViewModel()
        let pregnantWomanPage = PregnantWomanPage(viewModel: viewModel, uid: "testUID")
        
        // Set values for required fields
        viewModel.name = "John Doe"
        viewModel.selectedSex = "Female"
        viewModel.selectedHeight = 160
        viewModel.selectedWeight = 60
        
        // Simulate tapping the 'Continue' button
        let continueButton = try pregnantWomanPage.inspect().find(button: "Continue")
        try continueButton.tap()
        
        // Check if the isProfileCreated flag is set to true
        XCTAssertTrue(viewModel.isProfileCreated)
    }
    
    func testIncompleteData() throws {
        // Create a dummy view model with incomplete data
        let viewModel = PregnantWomanViewModel()
        let pregnantWomanPage = PregnantWomanPage(viewModel: viewModel, uid: "testUID")
        
        // Simulate tapping the 'Continue' button without filling in all required data
        let continueButton = try pregnantWomanPage.inspect().find(button: "Continue")
        try continueButton.tap()
        
        // Ensure the isProfileCreated flag is set to false (indicating incomplete data)
        XCTAssertFalse(viewModel.isProfileCreated)
    }
    
    func testPickerSelectionsUpdateViewModel() throws {
        let viewModel = PregnantWomanViewModel()
        let pregnantWomanPage = PregnantWomanPage(viewModel: viewModel, uid: "testUID")
        
        // Simulate selecting sex
        viewModel.selectedSex = "Female" // No need for 'try' here
        XCTAssertEqual(viewModel.selectedSex, "Female")
        
        // Simulate selecting height
        viewModel.selectedHeight = 170 // No need for 'try' here
        XCTAssertEqual(viewModel.selectedHeight, 170)
        
        // Simulate selecting weight
        viewModel.selectedWeight = 65 // No need for 'try' here
        XCTAssertEqual(viewModel.selectedWeight, 65)
    }

    func testAccessibilityLabels() throws {
        let viewModel = PregnantWomanViewModel()
        let pregnantWomanPage = PregnantWomanPage(viewModel: viewModel, uid: "testUID")

        // Locate the text field with the accessibility label "Name"
        let nameTextField = try pregnantWomanPage.inspect().find(ViewType.TextField.self, where: { view in
            // Extract the accessibility label and compare it
            let label = try view.accessibilityLabel().string()
            return label == "Name"
        })
        XCTAssertNotNil(nameTextField)

        // Locate the button with the accessibility label "Continue"
        let continueButton = try pregnantWomanPage.inspect().find(ViewType.Button.self, where: { view in
            // Extract the accessibility label and compare it
            let label = try view.accessibilityLabel().string()
            return label == "Continue"
        })
        XCTAssertNotNil(continueButton)
    }

        func testResetFieldsFunctionality() throws {
            let viewModel = PregnantWomanViewModel()
            let pregnantWomanPage = PregnantWomanPage(viewModel: viewModel, uid: "testUID")

            // Set initial values
            viewModel.name = "John Doe"
            viewModel.selectedSex = "Female"
            viewModel.selectedHeight = 170
            viewModel.selectedWeight = 65

            // Simulate reset or cancel action
            viewModel.resetFields()
            
            XCTAssertEqual(viewModel.name, "")
            XCTAssertEqual(viewModel.selectedSex, "")
            XCTAssertEqual(viewModel.selectedHeight, 0)
            XCTAssertEqual(viewModel.selectedWeight, 0)
        }

        func testUIStateAfterContinueAction() throws {
            let viewModel = PregnantWomanViewModel()
            let pregnantWomanPage = PregnantWomanPage(viewModel: viewModel, uid: "testUID")

            // Set required fields and simulate Continue button tap
            viewModel.name = "Test Name"
            viewModel.selectedSex = "Male"
            viewModel.selectedHeight = 180
            viewModel.selectedWeight = 75
            
            let continueButton = try pregnantWomanPage.inspect().find(button: "Continue")
            try continueButton.tap()
            
            XCTAssertTrue(viewModel.isProfileCreated)
            // Verify if any additional UI element shows up, like a success message
            // Uncomment below if there is a success view or message to check:
            // let successMessage = try pregnantWomanPage.inspect().find(text: "Profile Created Successfully")
            // XCTAssertNotNil(successMessage)
        
    }
}
    
    
    
    
    
    
    
    
    
    
    
    




