import XCTest
@testable import StorkCare_

// Mock Firestore Service for Testing
class MockFirestoreService: FirestoreServiceProtocol {
    var shouldReturnError: Bool = false
    var mockData: [String: Any] = [:]
    var mockTimeSlots: [String] = []
    
    func saveHealthcareProviderData(uid: String, name: String, gender: String, occupation: String, placeOfWork: String, completion: @escaping (Result<Void, Error>) -> Void) {
        if shouldReturnError {
            completion(.failure(NSError(domain: "MockFirestoreService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Simulated Error"])))
        } else {
            completion(.success(()))
        }
    }

    func loadHealthcareProviderData(uid: String, completion: @escaping (Result<[String: Any], Error>) -> Void) {
        if shouldReturnError {
            completion(.failure(NSError(domain: "MockFirestoreService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Simulated Error"])))
        } else {
            let mockData: [String: Any] = [
                "name": "Test Name",
                "gender": "Test Gender",
                "occupation": "Test Occupation",
                "placeOfWork": "Test Place",
                "isOnboarded": true
            ]
            completion(.success(mockData))
        }
    }

    func saveProviderAvailability(uid: String, date: String, timeSlots: [String], providerData: ProviderData, completion: @escaping (Result<Void, Error>) -> Void) {
        if shouldReturnError {
            completion(.failure(NSError(domain: "MockFirestoreService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Simulated Error"])))
        } else {
            completion(.success(()))
        }
    }

    func loadProviderAvailability(uid: String, date: String, completion: @escaping (Result<[String], Error>) -> Void) {
        if shouldReturnError {
            completion(.failure(NSError(domain: "MockFirestoreService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Simulated Error"])))
        } else {
            let mockTimeSlots: [String] = ["10:00 AM", "11:00 AM", "1:00 PM"]
            completion(.success(mockTimeSlots))
        }
    }
}

// Test Class for HealthcarePageViewModel
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
    
    func testSaveHealthcareProviderDataSuccess() {
        mockFirestoreService.shouldReturnError = false
        viewModel.gender = "Male"
        viewModel.occupation = "Doctor"
        viewModel.placeOfWork = "Hospital"

        let uid = "123"
        viewModel.saveHealthcareProviderData(uid: uid)

        XCTAssertEqual(viewModel.isLoading, true)
        XCTAssertEqual(viewModel.message, "Profile saved successfully!")
        XCTAssertTrue(viewModel.isOnboardingComplete)
    }

    func testSaveHealthcareProviderDataFailure() {
        mockFirestoreService.shouldReturnError = true
        viewModel.gender = "Male"
        viewModel.occupation = "Doctor"
        viewModel.placeOfWork = "Hospital"

        let uid = "123"
        viewModel.saveHealthcareProviderData(uid: uid)

        XCTAssertEqual(viewModel.isLoading, true)
        XCTAssertNotEqual(viewModel.message, "Profile saved successfully!") // Example assertion
    }

    func testSaveHealthcareProviderDataEmptyFields() {
        viewModel.gender = ""
        viewModel.occupation = ""
        viewModel.placeOfWork = ""
        
        let uid = "123"
        
        viewModel.saveHealthcareProviderData(uid: uid)
        
        XCTAssertEqual(viewModel.message, "Please fill in all fields")
        XCTAssertFalse(viewModel.isOnboardingComplete)
    }
}
