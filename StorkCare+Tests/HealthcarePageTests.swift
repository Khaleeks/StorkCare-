import XCTest
import ViewInspector
import SwiftUI
@testable import StorkCare_

final class HealthcarePageTests: XCTestCase {
    var viewModel: HealthcarePageViewModel!
    var isAuthenticated: Binding<Bool>!
    
    override func setUp() {
        super.setUp()
        viewModel = HealthcarePageViewModel()
        isAuthenticated = Binding.constant(true)
    }
    
    func testViewLoadsCorrectly() throws {
        let uid = "test-uid"
        let healthcarePage = HealthcarePage(uid: uid, isAuthenticated: isAuthenticated)
                    .environmentObject(viewModel)
        let titleText = try healthcarePage.inspect().find(text: "Healthcare Provider Onboarding")
        XCTAssertEqual(try titleText.string(), "Healthcare Provider Onboarding")
        
        let personalInfoSection = try healthcarePage.inspect().find(ViewType.Form.self)
        XCTAssertNotNil(personalInfoSection)
        
        let button = try healthcarePage.inspect().find(button: "Complete Onboarding")
        XCTAssertNotNil(button)
    }

    func testLoadingState() throws {
        let uid = "test-uid"
        viewModel.isLoading = true
        
        let healthcarePage = HealthcarePage(uid: uid, isAuthenticated: isAuthenticated)
            .environmentObject(viewModel)

        let progressView = try healthcarePage.inspect().find(ViewType.ProgressView.self)
        XCTAssertNotNil(progressView)
    }

    func testSaveHealthcareProviderData() throws {
        let uid = "test-uid"
        let healthcarePage = HealthcarePage(uid: uid, isAuthenticated: isAuthenticated)
            .environmentObject(viewModel)

        viewModel.gender = "Female"
        viewModel.occupation = "Doctor"
        viewModel.placeOfWork = "Hospital"

        let completeButton = try healthcarePage.inspect().find(button: "Complete Onboarding")
        try completeButton.tap()
        
        XCTAssertTrue(viewModel.isOnboardingComplete)
    }

    func testMessageDisplay() throws {
        let uid = "test-uid"
        let healthcarePage = HealthcarePage(uid: uid, isAuthenticated: isAuthenticated)
            .environmentObject(viewModel)

        XCTAssertNil(viewModel.message)

        viewModel.message = "Onboarding Complete!"
        viewModel.isOnboardingComplete = true

        let messageText = try healthcarePage.inspect().find(text: "Onboarding Complete!")
        XCTAssertEqual(try messageText.string(), "Onboarding Complete!")
        XCTAssertEqual(try messageText.foregroundColor(), Color.green)

        viewModel.message = "Error: Missing information"
        viewModel.isOnboardingComplete = false

        let errorMessage = try healthcarePage.inspect().find(text: "Error: Missing information")
        XCTAssertEqual(try errorMessage.string(), "Error: Missing information")
        XCTAssertEqual(try errorMessage.foregroundColor(), Color.red)
    }
}
