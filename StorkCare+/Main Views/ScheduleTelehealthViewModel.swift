import SwiftUI
import FirebaseFirestore

import SwiftUI
import FirebaseFirestore

struct ProviderListItem: Identifiable, Hashable {
    let id: String
    let name: String
    let gender: String
    let occupation: String
    let placeOfWork: String
    let isOnboarded: Bool
    let lastUpdated: Date?
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: ProviderListItem, rhs: ProviderListItem) -> Bool {
        lhs.id == rhs.id
    }
}

class ScheduleTelehealthViewModel: ObservableObject {
    @Published var selectedDate = Date()
    @Published var selectedProvider: ProviderListItem?
    @Published var selectedSlot = ""
    @Published var providers: [ProviderListItem] = []
    @Published var availableSlots: [String] = []
    @Published var providerUnavailable = false
    @Published var noSlotsAvailable = false
    @Published var confirmationMessage = ""
    @Published var showRescheduleOptions = false

    public var db = Firestore.firestore()
    
   
    func loadAvailableSlots() {
        guard let provider = selectedProvider else {
            providerUnavailable = true
            availableSlots = []
            return
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: selectedDate)
        
        print("Fetching slots for Provider ID: \(provider.id) on \(dateString)")
        
        db.collection("users")
            .document(provider.id)
            .collection("availability")
            .document(dateString)
            .getDocument { [weak self] document, error in
                guard let self = self else { return }
                
                if let error = error {
                    print("Error fetching slots: \(error.localizedDescription)")
                    DispatchQueue.main.async {
                        self.providerUnavailable = true
                        self.availableSlots = []
                    }
                    return
                }
                
                if let data = document?.data(),
                   let slots = data["timeSlots"] as? [String] {
                    print("Available slots: \(slots)")
                    DispatchQueue.main.async {
                        self.availableSlots = slots.sorted()
                        self.providerUnavailable = false
                        self.noSlotsAvailable = slots.isEmpty
                    }
                } else {
                    print("No slots or invalid data format.")
                    DispatchQueue.main.async {
                        self.availableSlots = []
                        self.providerUnavailable = true
                        self.noSlotsAvailable = true
                    }
                }
            }
    }



    public func loadProviders() {
        db.collection("users")
            .whereField("role", isEqualTo: "Healthcare Provider")
            .whereField("isOnboarded", isEqualTo: true)
            .getDocuments { [weak self] snapshot, error in
                guard let self = self else { return }
                
                if let error = error {
                    print("Error loading providers: \(error.localizedDescription)")
                    return
                }
                
                if let documents = snapshot?.documents {
                    let loadedProviders = documents.compactMap { document -> ProviderListItem? in
                        let data = document.data()
                        return ProviderListItem(
                            id: document.documentID,
                            name: data["name"] as? String ?? "",
                            gender: data["gender"] as? String ?? "",
                            occupation: data["occupation"] as? String ?? "",
                            placeOfWork: data["placeOfWork"] as? String ?? "",
                            isOnboarded: data["isOnboarded"] as? Bool ?? false,
                            lastUpdated: (data["lastUpdated"] as? Timestamp)?.dateValue()
                        )
                    }
                    
                    DispatchQueue.main.async {
                        self.providers = loadedProviders
                    }
                }
            }
    }
    
    init() {
        loadProviders() // Add this to load providers when ViewModel is initialized
    }
    func confirmAppointment() {
        guard let provider = selectedProvider,
              !selectedSlot.isEmpty else {
            print("Error: Provider or time slot not selected.")
            return
        }
        
        let appointmentData: [String: Any] = [
            "date": selectedDate,
            "providerId": provider.id,
            "providerName": provider.name,
            "occupation": provider.occupation,
            "timeSlot": selectedSlot,
            "userID": "user123",
            "status": "scheduled",
            "timestamp": FieldValue.serverTimestamp()
        ]
        
        print("Saving appointment: \(appointmentData)")
        
        db.collection("appointments").addDocument(data: appointmentData) { [weak self] error in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                if let error = error {
                    print("Failed to save appointment: \(error.localizedDescription)")
                    self.confirmationMessage = "Error: \(error.localizedDescription)"
                } else {
                    print("Appointment successfully saved.")
                    self.confirmationMessage = "Your appointment has been scheduled!"
                    self.showRescheduleOptions = false
                    self.updateProviderAvailability(provider: provider, slot: self.selectedSlot)
                }
            }
        }
    }

    
    private func updateProviderAvailability(provider: ProviderListItem, slot: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: selectedDate)
        
        let docRef = db.collection("users")
            .document(provider.id)
            .collection("availability")
            .document(dateString)
        
        docRef.getDocument { [weak self] document, error in
            guard let document = document,
                  var slots = document.data()?["timeSlots"] as? [String] else { return }
            
            // Remove the booked slot
            slots.removeAll { $0 == slot }
            
            // Update the availability
            docRef.updateData([
                "timeSlots": slots
            ]) { error in
                if let error = error {
                    print("Error updating availability: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func rescheduleAppointment() {
       
        self.confirmationMessage = "Rescheduled!"
    }


}
