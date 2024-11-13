// Define this at the top of your file or in a separate file
struct ProviderData {
   var name: String = ""
   var occupation: String = ""
   var placeOfWork: String = ""
   var gender: String = ""
}
import SwiftUI
import FirebaseFirestore
import FirebaseAuth

class ProviderAvailabilityViewModel: ObservableObject {
    @Published var providerData: ProviderData = ProviderData()
    @Published var selectedDate = Date()
    @Published var selectedTimeSlots: Set<String> = []
    @Published var message: String? = nil
    @Published var isLoading = false
    @Published var showingConfirmation = false
    
    private var db = Firestore.firestore()
    
    // Fetch provider data from Firestore
    func loadProviderData() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        db.collection("users").document(uid).getDocument { document, error in
            if let document = document, document.exists, let data = document.data() {
                DispatchQueue.main.async {
                    self.providerData = ProviderData(
                        name: data["name"] as? String ?? "",
                        occupation: data["occupation"] as? String ?? "",
                        placeOfWork: data["placeOfWork"] as? String ?? "",
                        gender: data["gender"] as? String ?? ""
                    )
                }
            }
        }
    }
    
    
    // Add the toggleTimeSlot method
      func toggleTimeSlot(_ time: String) {
          if selectedTimeSlots.contains(time) {
              selectedTimeSlots.remove(time)
          } else {
              selectedTimeSlots.insert(time)
          }
      }
    // Load existing availability for the selected date
    func loadExistingAvailability() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let dateString = formatDate(selectedDate)
        
        db.collection("users").document(uid)
            .collection("availability")
            .document(dateString)
            .getDocument { document, error in
                if let document = document, document.exists,
                   let times = document.data()?["timeSlots"] as? [String] {
                    DispatchQueue.main.async {
                        self.selectedTimeSlots = Set(times)
                    }
                }
            }
    }
    
    // Save the availability to Firestore
    func saveAvailability() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        isLoading = true
        
        let dateString = formatDate(selectedDate)
        let availabilityData: [String: Any] = [
            "date": selectedDate,
            "timeSlots": Array(selectedTimeSlots),
            "providerId": uid,
            "providerName": providerData.name,
            "occupation": providerData.occupation,
            "placeOfWork": providerData.placeOfWork,
            "updatedAt": FieldValue.serverTimestamp()
        ]
        
        db.collection("users").document(uid)
            .collection("availability")
            .document(dateString)
            .setData(availabilityData) { error in
                DispatchQueue.main.async {
                    self.isLoading = false
                    if let error = error {
                        self.message = "Error: Failed to save availability"
                        print(error.localizedDescription)
                    } else {
                        self.message = "Availability updated successfully!"
                        self.selectedTimeSlots.removeAll()  // Clear selections after success
                    }
                }
            }
    }
    
    // Helper function to format the date to string
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
}
