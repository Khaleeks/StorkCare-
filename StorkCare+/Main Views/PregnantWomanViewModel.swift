import SwiftUI
import Combine
import FirebaseFirestore

class PregnantWomanViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var selectedSex: String = ""
    @Published var dateOfBirth: Date = Date()
    @Published var pregnancyStartDate: Date = Date()
    @Published var medicalHistory: String = ""
    @Published var selectedHeight: Int = 0
    @Published var selectedWeight: Int = 0
    @Published var showSexPicker: Bool = false
    @Published var showHeightPicker: Bool = false
    @Published var showWeightPicker: Bool = false
    @Published var showDatePicker: Bool = false
    @Published var showPregnancyDatePicker: Bool = false
    @Published var isProfileCreated: Bool = false
    @Published var message: String? = nil

    private let db = Firestore.firestore()

    func savePregnantWomanData(uid: String) {
        if name.isEmpty || selectedSex.isEmpty || selectedHeight == 0 || selectedWeight == 0 {
            message = "Please fill in all required fields"
            isProfileCreated = false
            return
        }

        let userData: [String: Any] = [
            "name": name,
            "gender": selectedSex,
            "dateOfBirth": dateOfBirth,
            "pregnancyStartDate": pregnancyStartDate,
            "medicalHistory": medicalHistory,
            "height": selectedHeight,
            "weight": selectedWeight,
            "isOnboarded": true,
            "lastUpdated": FieldValue.serverTimestamp()
        ]

        db.collection("users").document(uid).updateData(userData) { [weak self] error in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                if let error = error {
                    self.message = "Failed to save profile: \(error.localizedDescription)"
                    self.isProfileCreated = false
                } else {
                    self.message = "Profile created successfully!"
                    self.isProfileCreated = true
                }
            }
        }
    }

    func dateFormatted(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: date)
    }

    func resetFields() {
        name = ""
        selectedSex = ""
        dateOfBirth = Date()
        pregnancyStartDate = Date()
        medicalHistory = ""
        selectedHeight = 0
        selectedWeight = 0
        isProfileCreated = false
        message = nil
    }

    func loadUserProfile(uid: String) {
        db.collection("users").document(uid).getDocument { [weak self] snapshot, error in
            guard let self = self else { return }
            
            if let error = error {
                self.message = "Error loading profile: \(error.localizedDescription)"
                return
            }
            
            if let data = snapshot?.data() {
                DispatchQueue.main.async {
                    self.name = data["name"] as? String ?? ""
                    self.selectedSex = data["gender"] as? String ?? ""
                    if let dobTimestamp = data["dateOfBirth"] as? Timestamp {
                        self.dateOfBirth = dobTimestamp.dateValue()
                    }
                    if let pregnancyTimestamp = data["pregnancyStartDate"] as? Timestamp {
                        self.pregnancyStartDate = pregnancyTimestamp.dateValue()
                    }
                    self.medicalHistory = data["medicalHistory"] as? String ?? ""
                    self.selectedHeight = data["height"] as? Int ?? 0
                    self.selectedWeight = data["weight"] as? Int ?? 0
                }
            }
        }
    }
}
