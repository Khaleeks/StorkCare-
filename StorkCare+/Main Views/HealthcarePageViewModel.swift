import Foundation
import FirebaseFirestore

protocol FirestoreServiceProtocol {
    func saveHealthcareProviderData(uid: String, gender: String, occupation: String, placeOfWork: String, completion: @escaping (Result<Void, Error>) -> Void)
    func loadHealthcareProviderData(uid: String, completion: @escaping (Result<[String: Any], Error>) -> Void)
}

class FirestoreService: FirestoreServiceProtocol {
    private let db = Firestore.firestore()
    
    func saveHealthcareProviderData(uid: String, gender: String, occupation: String, placeOfWork: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let data: [String: Any] = [
            "gender": gender,
            "occupation": occupation,
            "placeOfWork": placeOfWork,
            "isOnboarded": true,
            "lastUpdated": FieldValue.serverTimestamp()
        ]
        
        db.collection("users").document(uid).updateData(data) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    func loadHealthcareProviderData(uid: String, completion: @escaping (Result<[String: Any], Error>) -> Void) {
        db.collection("users").document(uid).getDocument { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let data = snapshot?.data() {
                completion(.success(data))
            } else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data found"])))
            }
        }
    }
}

class HealthcarePageViewModel: ObservableObject {
    @Published var gender: String = ""
    @Published var occupation: String = ""
    @Published var placeOfWork: String = ""
    @Published var message: String? = nil
    @Published var isOnboardingComplete: Bool = false
    @Published var isLoading: Bool = false

    private var firestoreService: FirestoreServiceProtocol

    init(firestoreService: FirestoreServiceProtocol = FirestoreService()) {
        self.firestoreService = firestoreService
    }

    func saveHealthcareProviderData(uid: String) {
        guard !gender.isEmpty, !occupation.isEmpty, !placeOfWork.isEmpty else {
            self.message = "Please fill in all fields"
            self.isOnboardingComplete = false
            return
        }
        
        isLoading = true
        
        firestoreService.saveHealthcareProviderData(uid: uid, gender: gender, occupation: occupation, placeOfWork: placeOfWork) { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.isLoading = false
                
                switch result {
                case .success:
                    self.message = "Profile saved successfully!"
                    self.isOnboardingComplete = true
                case .failure(let error):
                    self.message = "Failed to save data: \(error.localizedDescription)"
                    self.isOnboardingComplete = false
                }
            }
        }
    }
    
    func loadHealthcareProviderData(uid: String) {
        isLoading = true
        
        firestoreService.loadHealthcareProviderData(uid: uid) { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.isLoading = false
                
                switch result {
                case .success(let data):
                    self.gender = data["gender"] as? String ?? ""
                    self.occupation = data["occupation"] as? String ?? ""
                    self.placeOfWork = data["placeOfWork"] as? String ?? ""
                    self.isOnboardingComplete = data["isOnboarded"] as? Bool ?? false
                case .failure(let error):
                    self.message = "Failed to load data: \(error.localizedDescription)"
                }
            }
        }
    }
}
