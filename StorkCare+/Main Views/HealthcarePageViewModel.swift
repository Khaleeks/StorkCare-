import Foundation
import FirebaseFirestore
import FirebaseAuth



protocol FirestoreServiceProtocol {
    func saveHealthcareProviderData(uid: String, name:String, gender: String, occupation: String, placeOfWork: String, completion: @escaping (Result<Void, Error>) -> Void)
    func loadHealthcareProviderData(uid: String, completion: @escaping (Result<[String: Any], Error>) -> Void)
    func saveProviderAvailability(uid: String, date: String, timeSlots: [String], providerData: ProviderData, completion: @escaping (Result<Void, Error>) -> Void)
    func loadProviderAvailability(uid: String, date: String, completion: @escaping (Result<[String], Error>) -> Void)
}


class FirestoreService: FirestoreServiceProtocol {
    private let db = Firestore.firestore()

    func saveHealthcareProviderData(uid: String, name: String, gender: String, occupation: String, placeOfWork: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let data: [String: Any] = [
            "name": name,
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

    func saveProviderAvailability(uid: String, date: String, timeSlots: [String], providerData: ProviderData, completion: @escaping (Result<Void, Error>) -> Void) {
        let availabilityData: [String: Any] = [
            
            "date": date,
            "timeSlots": timeSlots,
            "providerId": uid,
            "providerName": providerData.name,
            "occupation": providerData.occupation,
            "placeOfWork": providerData.placeOfWork,
            "updatedAt": FieldValue.serverTimestamp()
        ]
        
        db.collection("users").document(uid).collection("availability").document(date).setData(availabilityData, merge: true) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }

    func loadProviderAvailability(uid: String, date: String, completion: @escaping (Result<[String], Error>) -> Void) {
        db.collection("users").document(uid).collection("availability").document(date).getDocument { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let data = snapshot?.data(), let timeSlots = data["timeSlots"] as? [String] {
                completion(.success(timeSlots))
            } else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data found"])))
            }
        }
    }
}


class HealthcarePageViewModel: ObservableObject {
    @Published var name: String = ""
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
        guard !name.isEmpty && !gender.isEmpty && !occupation.isEmpty && !placeOfWork.isEmpty else {
            self.message = "Please fill in all fields"
            self.isOnboardingComplete = false
            return

        }
        
        isLoading = true
        
        firestoreService.saveHealthcareProviderData(uid: uid, name:name, gender: gender, occupation: occupation, placeOfWork: placeOfWork) { [weak self] result in
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
                    self.name = data["name"] as? String ?? ""
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
