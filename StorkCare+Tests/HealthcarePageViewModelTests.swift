import XCTest
@testable import StorkCare_

// Mock FirestoreService for testing
// Mock FirestoreService for testing
class MockFirestoreService: FirestoreServiceProtocol {
    var result: Result<Void, Error> = .success(()) // Default to success

    func saveHealthcareProviderData(uid: String, gender: String, occupation: String, placeOfWork: String, completion: @escaping (Result<Void, Error>) -> Void) {
        completion(result) // Simulates the result set in tests
    }
}


class HealthcarePageViewModelTests: XCTestCase {

    var viewModel: HealthcarePageViewModel!
    var mockFirestoreService: MockFirestoreService!

    override func setUp() {
        super.setUp()
        mockFirestoreService = MockFirestoreService()
        viewModel = HealthcarePageViewModel(firestoreService: mockFirestoreService)
    }

    override func tearDown() {
        viewModel = nil
        mockFirestoreService = nil
        super.tearDown()
    }

    // 1. Test: Check if initial values are correctly set in ViewModel
    func testInitialValues() {
        XCTAssertEqual(viewModel.gender, "")
        XCTAssertEqual(viewModel.occupation, "")
        XCTAssertEqual(viewModel.placeOfWork, "")
        XCTAssertNil(viewModel.message)
        XCTAssertFalse(viewModel.isOnboardingComplete)
    }

    // 2. Test: Verify that saveHealthcareProviderData handles success correctly
    func testSaveHealthcareProviderDataSuccess() {
        let expectation = self.expectation(description: "Save data succeeds")

        viewModel.gender = "Female"
        viewModel.occupation = "Doctor"
        viewModel.placeOfWork = "StorkCare Hospital"
        
        mockFirestoreService.result = .success(())
        
        viewModel.saveHealthcareProviderData(uid: "testUID")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            XCTAssertEqual(self.viewModel.message, "Onboarding complete!")
            XCTAssertTrue(self.viewModel.isOnboardingComplete)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0, handler: nil)
    }

    // 3. Test: Verify that saveHealthcareProviderData handles failure correctly
    func testSaveHealthcareProviderDataFailure() {
        let expectation = self.expectation(description: "Save data fails")

        viewModel.gender = "Male"
        viewModel.occupation = "Nurse"
        viewModel.placeOfWork = "CareHealth Clinic"
        
        mockFirestoreService.result = .failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Network error"]))
        
        viewModel.saveHealthcareProviderData(uid: "testUID")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            XCTAssertEqual(self.viewModel.message, "Failed to save data: Network error")
            XCTAssertFalse(self.viewModel.isOnboardingComplete)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0, handler: nil)
    }

    // 4. Test: Verify saveHealthcareProviderData when some fields are empty
    func testSaveHealthcareProviderDataWithEmptyFields() {
        let expectation = self.expectation(description: "Missing fields validation")

        viewModel.gender = "" // Empty gender
        viewModel.occupation = "Doctor"
        viewModel.placeOfWork = "StorkCare Hospital"
        
        mockFirestoreService.result = .success(())
        
        viewModel.saveHealthcareProviderData(uid: "testUID")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            XCTAssertEqual(self.viewModel.message, "Please fill in all fields")
            XCTAssertFalse(self.viewModel.isOnboardingComplete)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0, handler: nil)
    }

    // 5. Test: Verify saveHealthcareProviderData with invalid UID (error case)
    func testSaveHealthcareProviderDataWithInvalidUID() {
        let expectation = self.expectation(description: "Invalid UID error")

        viewModel.gender = "Female"
        viewModel.occupation = "Doctor"
        viewModel.placeOfWork = "StorkCare Hospital"
        
        mockFirestoreService.result = .failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid user ID"]))
        
        viewModel.saveHealthcareProviderData(uid: "invalidUID")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            XCTAssertEqual(self.viewModel.message, "Failed to save data: Invalid user ID")
            XCTAssertFalse(self.viewModel.isOnboardingComplete)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0, handler: nil)
    }

    // 6. Test: Verify saveHealthcareProviderData works with different user data
    func testSaveHealthcareProviderDataWithDifferentUserData() {
        let expectation = self.expectation(description: "Save data with different user data")

        viewModel.gender = "Nonbinary"
        viewModel.occupation = "Midwife"
        viewModel.placeOfWork = "City Clinic"
        
        mockFirestoreService.result = .success(())
        
        viewModel.saveHealthcareProviderData(uid: "testUID")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            XCTAssertEqual(self.viewModel.message, "Onboarding complete!")
            XCTAssertTrue(self.viewModel.isOnboardingComplete)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0, handler: nil)
    }
}
