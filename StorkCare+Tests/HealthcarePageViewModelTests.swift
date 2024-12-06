import XCTest
@testable import StorkCare_

// MockFirestoreService for unit tests
class MockFirestoreService: FirestoreServiceProtocol {
    var shouldReturnError = false
    var mockData: [String: Any] = [:]
    var mockTimeSlots: [String] = []
    
    func saveHealthcareProviderData(uid: String, gender: String, occupation: String, placeOfWork: String, completion: @escaping (Result<Void, Error>) -> Void) {
        if shouldReturnError {
            
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Mock error"])))
        } else {
            completion(.success(()))
        }
    }
    
    func loadHealthcareProviderData(uid: String, completion: @escaping (Result<[String: Any], Error>) -> Void) {
        if shouldReturnError {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Mock error"])))
        } else {
            completion(.success(mockData))
        }
    }
    
    func saveProviderAvailability(uid: String, date: String, timeSlots: [String], providerData: ProviderData, completion: @escaping (Result<Void, Error>) -> Void) {
        if shouldReturnError {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Mock error"])))
        } else {
            completion(.success(()))
        }
    }
    
    func loadProviderAvailability(uid: String, date: String, completion: @escaping (Result<[String], Error>) -> Void) {
        if shouldReturnError {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Mock error"])))
        } else {
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
        XCTAssertEqual(viewModel.message, "Failed to save data: Mock error")
        XCTAssertFalse(viewModel.isOnboardingComplete)
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
