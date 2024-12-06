import XCTest
import Combine
@testable import StorkCare_


protocol CollectionReferenceProtocol {
    func getDocuments(completion: @escaping ([MockDocument]?, Error?) -> Void)
    func document(_ id: String) -> MockDocumentReference
    func addDocument(data: [String: Any], completion: ((Error?) -> Void)?)
}

protocol FirestoreProtocol {
    func collection(_ collectionPath: String) -> CollectionReferenceProtocol
}

enum MockFirestoreError: Error {
    case genericError
}

class MockFirestore: FirestoreProtocol {
    var mockProviderDocuments: [MockDocument] = []
    var mockSlotDocument: MockDocument?
    var mockAddDocumentSuccess: Bool = true
    var mockError: Error?

    func collection(_ collectionPath: String) -> CollectionReferenceProtocol {
        return MockCollectionReference(
            documents: mockProviderDocuments,
            mockSlotDocument: mockSlotDocument,
            addDocumentSuccess: mockAddDocumentSuccess,
            error: mockError
        )
    }
}

struct MockDocument {
    let data: [String: Any]
}

class MockCollectionReference: CollectionReferenceProtocol {
    var documents: [MockDocument]
    var mockSlotDocument: MockDocument?
    var addDocumentSuccess: Bool
    var error: Error?

    init(documents: [MockDocument], mockSlotDocument: MockDocument?, addDocumentSuccess: Bool, error: Error?) {
        self.documents = documents
        self.mockSlotDocument = mockSlotDocument
        self.addDocumentSuccess = addDocumentSuccess
        self.error = error
    }

    func getDocuments(completion: @escaping ([MockDocument]?, Error?) -> Void) {
        if let error = error {
            completion(nil, error)
        } else {
            completion(documents, nil)
        }
    }

    func document(_ id: String) -> MockDocumentReference {
        // Ensure the initializer exists in MockDocumentReference
        return MockDocumentReference(mockDocument: mockSlotDocument, error: error)
    }

    func addDocument(data: [String: Any], completion: ((Error?) -> Void)?) {
        if addDocumentSuccess {
            completion?(nil)
        } else {
            completion?(MockFirestoreError.genericError)
        }
    }
}

class MockDocumentReference {
    var mockDocument: MockDocument?
    var error: Error?

    // Correct initializer
    init(mockDocument: MockDocument?, error: Error?) {
        self.mockDocument = mockDocument
        self.error = error
    }

    func getDocument(completion: @escaping (MockDocument?, Error?) -> Void) {
        if let error = error {
            completion(nil, error)
        } else {
            completion(mockDocument, nil)
        }
    }

    func updateData(_ data: [String: Any], completion: ((Error?) -> Void)?) {
        completion?(nil)
    }
}


final class ScheduleTelehealthViewModelTests: XCTestCase {
    var viewModel: ScheduleTelehealthViewModel!
    var mockFirestore: MockFirestore!
    var cancellables: Set<AnyCancellable> = []
    
    override func tearDown() {
        viewModel = nil
        mockFirestore = nil
        cancellables.removeAll()
        super.tearDown()
    }

    func testLoadProvidersSuccess() {
        // Mock Firestore documents
        mockFirestore.mockProviderDocuments = [
            MockDocument(data: [
                "name": "Dr. John Doe",
                "gender": "Male",
                "occupation": "Pediatrician",
                "placeOfWork": "Health Clinic",
                "isOnboarded": true
            ])
        ]

        let expectation = self.expectation(description: "Providers loaded")
        viewModel.$providers.dropFirst().sink { providers in
            XCTAssertEqual(providers.count, 1)
            XCTAssertEqual(providers.first?.name, "Dr. John Doe")
            expectation.fulfill()
        }.store(in: &cancellables)

        viewModel.loadProviders()
        wait(for: [expectation], timeout: 2)
    }

    func testLoadProvidersFailure() {
        mockFirestore.mockError = MockFirestoreError.genericError

        let expectation = self.expectation(description: "Providers load failure")
        viewModel.$providers.dropFirst().sink { providers in
            XCTAssertTrue(providers.isEmpty)
            expectation.fulfill()
        }.store(in: &cancellables)

        viewModel.loadProviders()
        wait(for: [expectation], timeout: 2)
    }

    func testLoadAvailableSlotsSuccess() {
        let provider = ProviderListItem(
            id: "provider1",
            name: "Dr. Jane Doe",
            gender: "Female",
            occupation: "Dermatologist",
            placeOfWork: "Skin Center",
            isOnboarded: true,
            lastUpdated: nil
        )
        viewModel.selectedProvider = provider
        viewModel.selectedDate = Date()

        mockFirestore.mockSlotDocument = MockDocument(data: [
            "timeSlots": ["09:00 AM", "10:00 AM", "11:00 AM"]
        ])

        let expectation = self.expectation(description: "Slots loaded")
        viewModel.$availableSlots.dropFirst().sink { slots in
            XCTAssertEqual(slots, ["09:00 AM", "10:00 AM", "11:00 AM"])
            expectation.fulfill()
        }.store(in: &cancellables)

        viewModel.loadAvailableSlots()
        wait(for: [expectation], timeout: 2)
    }

    func testLoadAvailableSlotsFailure() {
        viewModel.selectedProvider = nil

        let expectation = self.expectation(description: "Slots unavailable")
        viewModel.$providerUnavailable.dropFirst().sink { unavailable in
            XCTAssertTrue(unavailable)
            expectation.fulfill()
        }.store(in: &cancellables)

        viewModel.loadAvailableSlots()
        wait(for: [expectation], timeout: 2)
    }

    func testConfirmAppointmentSuccess() {
        let provider = ProviderListItem(
            id: "provider1",
            name: "Dr. Jane Doe",
            gender: "Female",
            occupation: "Dermatologist",
            placeOfWork: "Skin Center",
            isOnboarded: true,
            lastUpdated: nil
        )
        viewModel.selectedProvider = provider
        viewModel.selectedSlot = "09:00 AM"
        viewModel.selectedDate = Date()

        mockFirestore.mockAddDocumentSuccess = true

        let expectation = self.expectation(description: "Appointment confirmed")
        viewModel.$confirmationMessage.dropFirst().sink { message in
            XCTAssertEqual(message, "Your appointment has been scheduled!")
            expectation.fulfill()
        }.store(in: &cancellables)

        viewModel.confirmAppointment()
        wait(for: [expectation], timeout: 2)
    }

    func testConfirmAppointmentFailure() {
        viewModel.selectedProvider = nil
        viewModel.selectedSlot = ""

        let expectation = self.expectation(description: "Appointment failure")
        viewModel.$confirmationMessage.dropFirst().sink { message in
            XCTAssertEqual(message, "Error: Provider or time slot not selected.")
            expectation.fulfill()
        }.store(in: &cancellables)

        viewModel.confirmAppointment()
        wait(for: [expectation], timeout: 2)
    }
}
