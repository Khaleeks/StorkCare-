import SwiftUI
import FirebaseFirestore

class ScheduleTelehealthViewModel: ObservableObject {
    @Published var selectedDate = Date()
    @Published var selectedProvider = ""
    @Published var selectedSlot = ""
    @Published var providers: [String] = ["Dr. Lee", "Dr. Gonzalez", "Dr. Johnson"]
    
    @Published var availableSlots: [String] = []
    @Published var providerUnavailable = false
    @Published var noSlotsAvailable = false
    @Published var confirmationMessage = ""
    @Published var showRescheduleOptions = false

    private var db = Firestore.firestore()

    // Load available slots for a selected provider
    func loadAvailableSlots(for provider: String) {
   
        availableSlots = ["10:00 AM", "2:00 PM", "4:00 PM"]
        providerUnavailable = false
        noSlotsAvailable = availableSlots.isEmpty
    }

    func confirmAppointment() {
        guard !selectedSlot.isEmpty, !selectedProvider.isEmpty else {
            return
        }
        
        let appointmentData: [String: Any] = [
            "date": selectedDate,
            "provider": selectedProvider,
            "timeSlot": selectedSlot,
            "userID": "user123",
            "timestamp": Timestamp(date: Date())
        ]
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.confirmationMessage = "Your appointment has been scheduled!"
            self.showRescheduleOptions = false
        }
    }

    func rescheduleAppointment() {
       
        self.confirmationMessage = "Rescheduled!"
    }
}
