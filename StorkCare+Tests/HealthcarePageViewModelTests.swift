import XCTest
@testable import StorkCare_

// Mock FirestoreService for testing
class MockFirestoreService: FirestoreServiceProtocol {
    var result: Result<Void, Error> = .success(())
    
    func saveHealthcareProviderData(uid: String, gender: String, occupation: String, placeOfWork: String, completion: @escaping (Result<Void, Error>) -> Void) {
        completion(result)
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
        // Given
        let expectedGender = ""
        let expectedOccupation = ""
        let expectedPlaceOfWork = ""
        let expectedMessage: String? = nil
        let expectedIsOnboardingComplete = false

        // When
        // No action needed, we're just checking initial values

        // Then
        XCTAssertEqual(viewModel.gender, expectedGender)
        XCTAssertEqual(viewModel.occupation, expectedOccupation)
        XCTAssertEqual(viewModel.placeOfWork, expectedPlaceOfWork)
        XCTAssertEqual(viewModel.message, expectedMessage)
        XCTAssertEqual(viewModel.isOnboardingComplete, expectedIsOnboardingComplete)
    }

    // 2. Test: Verify that saveHealthcareProviderData handles success correctly
    func testSaveHealthcareProviderDataSuccess() {
        // Given
        viewModel.gender = "Female"
        viewModel.occupation = "Doctor"
        viewModel.placeOfWork = "StorkCare Hospital"
        
        // Simulate success
        mockFirestoreService.result = .success(())

        // When
        viewModel.saveHealthcareProviderData(uid: "testUID")

        // Then
        XCTAssertEqual(viewModel.message, "Onboarding complete!")
        XCTAssertTrue(viewModel.isOnboardingComplete)
    }

    // 3. Test: Verify that saveHealthcareProviderData handles failure correctly
    func testSaveHealthcareProviderDataFailure() {
        // Given
        viewModel.gender = "Male"
        viewModel.occupation = "Nurse"
        viewModel.placeOfWork = "CareHealth Clinic"
        
        // Simulate failure
        let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Network error"])
        mockFirestoreService.result = .failure(error)

        // When
        viewModel.saveHealthcareProviderData(uid: "testUID")

        // Then
        XCTAssertEqual(viewModel.message, "Failed to save data: Network error")
        XCTAssertFalse(viewModel.isOnboardingComplete)
    }

    // 4. Test: Check saveHealthcareProviderData when some fields are empty
    func testSaveHealthcareProviderDataWithEmptyFields() {
        // Given
        viewModel.gender = "" // Empty gender
        viewModel.occupation = "Doctor" // Occupation filled
        viewModel.placeOfWork = "" // Empty place of work
        
        // Simulate success
        mockFirestoreService.result = .success(())

        // When
        viewModel.saveHealthcareProviderData(uid: "testUID")

        // Then
        XCTAssertEqual(viewModel.message, "Onboarding complete!")
        XCTAssertTrue(viewModel.isOnboardingComplete)
    }

    // 5. Test: Verify saveHealthcareProviderData with invalid UID (error case)
    func testSaveHealthcareProviderDataWithInvalidUID() {
        // Given
        viewModel.gender = "Female"
        viewModel.occupation = "Doctor"
        viewModel.placeOfWork = "StorkCare Hospital"
        
        // Simulate failure due to invalid UID
        let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid user ID"])
        mockFirestoreService.result = .failure(error)

        // When
        viewModel.saveHealthcareProviderData(uid: "invalidUID")

        // Then
        XCTAssertEqual(viewModel.message, "Failed to save data: Invalid user ID")
        XCTAssertFalse(viewModel.isOnboardingComplete)
    }

    // 6. Test: Verify saveHealthcareProviderData works with different user data
    func testSaveHealthcareProviderDataWithDifferentUserData() {
        // Given
        viewModel.gender = "Nonbinary"
        viewModel.occupation = "Midwife"
        viewModel.placeOfWork = "City Clinic"
        
        // Simulate success
        mockFirestoreService.result = .success(())

        // When
        viewModel.saveHealthcareProviderData(uid: "testUID")

        // Then
        XCTAssertEqual(viewModel.message, "Onboarding complete!")
        XCTAssertTrue(viewModel.isOnboardingComplete)
    }
}
