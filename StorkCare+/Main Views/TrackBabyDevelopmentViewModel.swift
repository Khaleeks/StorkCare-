import SwiftUI
import Combine
import FirebaseFirestore
import FirebaseAuth

class TrackBabyDevelopmentViewModel: ObservableObject {
    @Published var conceptionDate: Date = Date()
    @Published var currentWeek: Int?
    @Published var developmentInfo: BabyDevelopment?
    @Published var errorMessage: String = ""
    @Published var hasEntry = false
    @Published var validate = 0
    @Published var message: String? = nil
    @Published var isLoading = false

    // Properties for trimester and progress
    @Published var weeksLeft: Int?
    @Published var trimesterProgress: CGFloat = 0.0
    @Published var currentTrimester: String = ""
    private let totalWeeks = 40 // Standard pregnancy length
    private let db = Firestore.firestore()
    
    init() {
      loadConceptionData()
    }

    func loadConceptionData() {
        guard let uid = Auth.auth().currentUser?.uid else {
            self.message = "No user logged in"
            return
        }
        
        isLoading = true
        let docRef = db.collection("users").document(uid)
        loadPregnantData(uid: uid) { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.isLoading = false
                
                switch result {
                case .success(let data):
                    self.conceptionDate = (data["pregnancyStartDate"] as? Date)!
                    self.validateConceptionDate()
                    if self.validate == 1 {
                        self.hasEntry = true
                    }
                case .failure(let error):
                    self.message = "Error loading provider data: \(error.localizedDescription)"
                }
            }
        }
    }
    
    func loadPregnantData(uid: String, completion: @escaping (Result<[String: Any], Error>) -> Void) {
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
    func updateDatabase() {
        guard let uid = Auth.auth().currentUser?.uid else {
            self.message = "No user logged in"
            return
        }
        let data = [
            "pregnancyStartDate": conceptionDate,
        ]
            db.collection("users").document(uid).updateData(data) { err in
                if let err = err {
                    print("Error updating document: \(err) ")
                }
                else {
                    print("Document successfully updated")
                }
            }
        }
    
    func updateConceptionDate() {
        validateConceptionDate()
        if validate == 1 {
            updateDatabase()
            hasEntry = true
        }
    }

    func calculateCurrentWeek() {
        let calendar = Calendar.current
        let currentDate = Date()
        let components = calendar.dateComponents([.weekOfYear], from: conceptionDate, to: currentDate)
        currentWeek = components.weekOfYear
        
        if let week = currentWeek, week > 0 && week <= 40 {
            developmentInfo = babyDevelopmentData[week - 1]
            calculateProgressAndTrimester(for: week)
        } else {
            developmentInfo = nil // Reset if the week is out of bounds
        }
    }

    private func validateConceptionDate() {
        let calendar = Calendar.current
        let currentDate = Date()
        let components = calendar.dateComponents([.weekOfYear], from: conceptionDate, to: currentDate)
        let currentex = components.weekOfYear ?? 0
        validate = (currentex > 0 && currentex <= 40) ? 1 : 2
    }
    
    // Function to calculate trimester and progress
    private func calculateProgressAndTrimester(for week: Int) {
        weeksLeft = totalWeeks - week

        // Calculate trimester progress (dividing pregnancy into 3 trimesters)
        trimesterProgress = CGFloat(week) / CGFloat(totalWeeks)
        
        // Determine which trimester the current week falls into
        if week <= 12 {
            currentTrimester = "First Trimester"
        } else if week <= 24 {
            currentTrimester = "Second Trimester"
        } else {
            currentTrimester = "Third Trimester"
        }
    }
}

