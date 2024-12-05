// Define this at the top of your file or in a separate file
struct ProviderData {
   var name: String = ""
   var occupation: String = ""
   var placeOfWork: String = ""
   var gender: String = ""
}

import Foundation
import FirebaseFirestore
import FirebaseAuth

class ProviderAvailabilityViewModel: ObservableObject {
    @Published var providerData: ProviderData = ProviderData()
    @Published var selectedDate = Date() {
        didSet {
            loadExistingAvailability()
        }
    }
    @Published var selectedTimeSlots: Set<String> = []
    @Published var message: String? = nil
    @Published var isLoading = false
    @Published var showingConfirmation = false
    
    private let firestoreService: FirestoreServiceProtocol
    private let db = Firestore.firestore()
    
    init(firestoreService: FirestoreServiceProtocol = FirestoreService()) {
        self.firestoreService = firestoreService
    }
    
    func saveAvailability() {
        guard let uid = Auth.auth().currentUser?.uid else {
            self.message = "No user logged in"
            return
        }
        
        isLoading = true
        let dateString = formatDate(selectedDate)
        
        // Create provider data object
        let providerData = ProviderData(
            name: self.providerData.name,
            occupation: self.providerData.occupation,
            placeOfWork: self.providerData.placeOfWork,
            gender: self.providerData.gender
        )
        
        // Use FirestoreService instead of direct Firestore access
        firestoreService.saveProviderAvailability(
            uid: uid,
            date: dateString,
            timeSlots: Array(selectedTimeSlots),
            providerData: providerData
        ) { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.isLoading = false
                
                switch result {
                case .success:
                    self.message = "Availability successfully saved!"
                case .failure(let error):
                    self.message = "Error saving availability: \(error.localizedDescription)"
                }
            }
        }
    }
    
    func loadExistingAvailability() {
        guard let uid = Auth.auth().currentUser?.uid else {
            self.message = "No user logged in"
            return
        }
        
        isLoading = true
        let dateString = formatDate(selectedDate)
        
        firestoreService.loadProviderAvailability(uid: uid, date: dateString) { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.isLoading = false
                
                switch result {
                case .success(let timeSlots):
                    self.selectedTimeSlots = Set(timeSlots)
                case .failure(let error):
                    self.message = "Availability Status: \(error.localizedDescription)"
                    self.selectedTimeSlots = []
                }
            }
        }
    }
    
    func loadProviderData() {
        guard let uid = Auth.auth().currentUser?.uid else {
            self.message = "No user logged in"
            return
        }
        
        isLoading = true
        
        firestoreService.loadHealthcareProviderData(uid: uid) { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.isLoading = false
                
                switch result {
                case .success(let data):
                    self.providerData = ProviderData(
                        name: data["name"] as? String ?? "",
                        occupation: data["occupation"] as? String ?? "",
                        placeOfWork: data["placeOfWork"] as? String ?? "",
                        gender: data["gender"] as? String ?? ""
                    )
                case .failure(let error):
                    self.message = "Error loading provider data: \(error.localizedDescription)"
                }
            }
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
    
    func toggleTimeSlot(_ time: String) {
           if selectedTimeSlots.contains(time) {
               selectedTimeSlots.remove(time)
           } else {
               selectedTimeSlots.insert(time)
           }
       }
    

}
