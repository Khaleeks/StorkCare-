import Foundation
import FirebaseFirestore

// Protocol for Firestore service to make it easier to mock in tests
protocol FirestoreServiceProtocol {
    func saveHealthcareProviderData(uid: String, gender: String, occupation: String, placeOfWork: String, completion: @escaping (Result<Void, Error>) -> Void)
}

// Default FirestoreService that communicates with the Firestore database
class FirestoreService: FirestoreServiceProtocol {
    func saveHealthcareProviderData(uid: String, gender: String, occupation: String, placeOfWork: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let db = Firestore.firestore()
        db.collection("users").document(uid).updateData([
            "gender": gender,
            "occupation": occupation,
            "placeOfWork": placeOfWork,
            "isOnboarded": true
        ]) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
}

// ViewModel for HealthcarePage
class HealthcarePageViewModel: ObservableObject {
    @Published var gender: String = ""
    @Published var occupation: String = ""
    @Published var placeOfWork: String = ""
    @Published var message: String? = nil
    @Published var isOnboardingComplete: Bool = false

    private var firestoreService: FirestoreServiceProtocol

    // Injecting the FirestoreService so that we can mock it in the tests
    init(firestoreService: FirestoreServiceProtocol = FirestoreService()) {
        self.firestoreService = firestoreService
    }

    func saveHealthcareProviderData(uid: String) {
        guard !gender.isEmpty, !occupation.isEmpty, !placeOfWork.isEmpty else {
            self.message = "Please fill in all fields"
            self.isOnboardingComplete = false
            return
        }
        
        firestoreService.saveHealthcareProviderData(uid: uid, gender: gender, occupation: occupation, placeOfWork: placeOfWork) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self.message = "Onboarding complete!"
                    self.isOnboardingComplete = true
                case .failure(let error):
                    self.message = "Failed to save data: \(error.localizedDescription)"
                    self.isOnboardingComplete = false
                }
            }
        }
    }


    
    
}
