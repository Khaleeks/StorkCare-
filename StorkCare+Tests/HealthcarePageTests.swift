import XCTest
import ViewInspector
@testable import StorkCare_

final class HealthcarePageTests: XCTestCase {
    
    // Test if the view loads correctly with the initial state
    func testViewLoadsCorrectly() throws {
        let uid = "test-uid"
        let viewModel = HealthcarePageViewModel()

        // Initialize the view with the mock view model
        let healthcarePage = HealthcarePage(uid: uid)
            .environmentObject(viewModel)

        // Check if the title is correct
        let titleText = try healthcarePage.inspect().find(text: "Healthcare Provider Onboarding")
        XCTAssertEqual(try titleText.string(), "Healthcare Provider Onboarding")
        
        // Check if the Personal Information section is present
        let personalInfoSection = try healthcarePage.inspect().find(ViewType.Form.self)
        XCTAssertNotNil(personalInfoSection)
        
        // Check if the "Complete Onboarding" button is present
        let button = try healthcarePage.inspect().find(button: "Complete Onboarding")
        XCTAssertNotNil(button)
    }

    // Test loading state when data is being fetched
    func testLoadingState() throws {
        let uid = "test-uid"
        let viewModel = HealthcarePageViewModel()
        viewModel.isLoading = true  // Set loading state to true

        let healthcarePage = HealthcarePage(uid: uid)
            .environmentObject(viewModel)

        // Check that the ProgressView is showing while loading
        let progressView = try healthcarePage.inspect().find(ViewType.ProgressView.self)
        XCTAssertNotNil(progressView)
    }

    // Test saving healthcare provider data
    func testSaveHealthcareProviderData() throws {
        let uid = "test-uid"
        let viewModel = HealthcarePageViewModel()
        let healthcarePage = HealthcarePage(uid: uid)
            .environmentObject(viewModel)

        // Fill the fields with test data
        viewModel.gender = "Female"
        viewModel.occupation = "Doctor"
        viewModel.placeOfWork = "Hospital"

        // Simulate tapping the "Complete Onboarding" button
        let completeButton = try healthcarePage.inspect().find(button: "Complete Onboarding")
        try completeButton.tap()

        // Check if the view model's saveHealthcareProviderData method is called (you might need to mock this in the view model)
        XCTAssertTrue(viewModel.isOnboardingComplete)
    }

    // Test displaying the error or success message
    func testMessageDisplay() throws {
        let uid = "test-uid"
        let viewModel = HealthcarePageViewModel()
        let healthcarePage = HealthcarePage(uid: uid)
            .environmentObject(viewModel)

        // Test that no message is shown initially
        XCTAssertNil(viewModel.message)

        // Simulate a successful onboarding completion
        viewModel.message = "Onboarding Complete!"
        viewModel.isOnboardingComplete = true

        // Check if success message is shown in green
        let messageText = try healthcarePage.inspect().find(text: "Onboarding Complete!")
        XCTAssertEqual(try messageText.string(), "Onboarding Complete!")
        XCTAssertEqual(try messageText.foregroundColor(), .green)

        // Simulate a failure in onboarding
        viewModel.message = "Error: Missing information"
        viewModel.isOnboardingComplete = false

        // Check if error message is shown in red
        let errorMessage = try healthcarePage.inspect().find(text: "Error: Missing information")
        XCTAssertEqual(try errorMessage.string(), "Error: Missing information")
        XCTAssertEqual(try errorMessage.foregroundColor(), .red)
    }
    
    // Test the view model's loadHealthcareProviderData method
    func testLoadHealthcareProviderData() throws {
        let uid = "test-uid"
        let viewModel = HealthcarePageViewModel()

        // Initially, the fields should be empty
        XCTAssertEqual(viewModel.gender, "")
        XCTAssertEqual(viewModel.occupation, "")
        XCTAssertEqual(viewModel.placeOfWork, "")

        // Simulate the loadHealthcareProviderData function
        viewModel.loadHealthcareProviderData(uid: uid)

        // After loading, the fields should be populated with mock data
        XCTAssertEqual(viewModel.gender, "Female")  // Assuming the mock data is Female
        XCTAssertEqual(viewModel.occupation, "Nurse")
        XCTAssertEqual(viewModel.placeOfWork, "General Hospital")
    }
}
