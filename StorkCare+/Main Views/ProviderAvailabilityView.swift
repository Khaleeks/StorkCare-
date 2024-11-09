import SwiftUI
import Firebase
import FirebaseFirestore

struct ProviderAvailabilityView: View {
    
    @State private var selectedProvider: String = ""
    @State private var selectedDate: Date = Date()
    @State private var availableSlot: String = ""
    @State private var confirmationMessage: String = ""
    @State private var showRescheduleOptions: Bool = false
    @State private var availableSlots: [String] = []
    @State private var noSlotsAvailable: Bool = false
    @State private var providerUnavailable: Bool = false
    
    // Mock data for providers and available slots
    private var providers = ["Dr. Smith", "Dr. Johnson", "Dr. Lee"]
    let db = Firestore.firestore() // Initialize Firestore
    
    @State private var allAvailableSlots: [String: [String]] = [
        "Dr. Smith": ["9:00 AM", "10:30 AM", "1:00 PM", "3:00 PM"],
        "Dr. Johnson": ["10:00 AM", "11:30 AM", "2:00 PM"],
        "Dr. Lee": [] // Dr. Lee is unavailable
    ]
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Update Availability")
                .font(.largeTitle)
                .foregroundColor(.white)
                .padding()
                .background(RoundedRectangle(cornerRadius: 20).fill(Color.blue))
            
            // Date Picker for selecting appointment date
            DatePicker("Select Appointment Date:", selection: $selectedDate, displayedComponents: [.date])
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).fill(Color.white))
                .cornerRadius(10)
            
            // Provider Selection
            Text("Select Your Healthcare Provider:")
                .font(.headline)
                .foregroundColor(.pink)
            
            Picker("Select a Provider", selection: $selectedProvider) {
                ForEach(providers, id: \.self) { provider in
                    Text(provider)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .padding()
            .background(RoundedRectangle(cornerRadius: 10).fill(Color.white))
            .cornerRadius(10)
            .onChange(of: selectedProvider) {
                loadAvailableSlots(for: selectedProvider, on: selectedDate)
            }
            
            // Displaying current available slots
            Text("Current Available Slots:")
                .font(.headline)
                .foregroundColor(.black)
            List(availableSlots, id: \.self) { slot in
                Text(slot)
            }
            
            // Slot Input Field
            TextField("Add a Time Slot (e.g., 4:00 PM)", text: $availableSlot)
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).fill(Color.white))
                .cornerRadius(10)
            
            // Add Slot Button
            Button(action: {
                addTimeSlot()
            }) {
                Text("Add Time Slot")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
            .disabled(availableSlot.isEmpty)
            
            // Confirm Button
            Button(action: {
                confirmAvailability(TimeSlot: availableSlot)

            }) {
                Text("Confirm Availability Update")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
            .disabled(selectedProvider.isEmpty || availableSlots.isEmpty)
            
            // Confirmation Message
            if !confirmationMessage.isEmpty {
                Text(confirmationMessage)
                    .foregroundColor(.green)
                    .padding()
            }
            
            // Reschedule Option
            if showRescheduleOptions {
                Button(action: {
                    rescheduleAppointment()
                }) {
                    Text("Reschedule Appointment")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.pink)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
            }
        }
        .padding()
        .background(Color.blue.opacity(0.1))
        .cornerRadius(20)
        .shadow(radius: 5)
        .onAppear {
            selectedProvider = providers.first ?? ""
            loadAvailableSlots(for: selectedProvider, on: selectedDate)
        }
    }
    
    // Load available slots based on selected provider
    private func loadAvailableSlots(for selectedProvider: String, on date: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let formattedDate = dateFormatter.string(from: date)
        
        db.collection("Providers").document(selectedProvider)
            .collection("availability").document(formattedDate)
            .getDocument { document, error in
                if let document = document, document.exists {
                    if let slots = document.data()?["slots"] as? [String] {
                        availableSlots = slots
                        providerUnavailable = slots.isEmpty
                    }
                } else {
                    availableSlots = []
                    providerUnavailable = true
                }
            }
    }
    
    // Add a new time slot locally and to Firestore
    private func addTimeSlot() {
        guard !availableSlot.isEmpty else { return }
        availableSlots.append(availableSlot)
        availableSlot = ""
    }
    
    // Confirm and save the availability to Firestore
    private func confirmAvailability(TimeSlot: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let formattedDate = dateFormatter.string(from: selectedDate)
        
        let db = Firestore.firestore()
        
        // Fetch existing slots before updating
        db.collection("Providers")
            .document(selectedProvider) // Document for the selected provider
            .collection("Availability") // Subcollection for availability on different dates
            .document(formattedDate) // Document for the selected date
            .getDocument { document, error in
                if let error = error {
                    print("Error fetching existing slots: \(error)")
                    return
                }
                
                var updatedSlots: [String] = []
                
                if let document = document, document.exists, let slots = document.data()?["slots"] as? [String] {
                    // If slots exist, append the new time slot
                    updatedSlots = slots
                    if !updatedSlots.contains(TimeSlot) {
                        updatedSlots.append(TimeSlot)
                    }
                } else {
                    // If no slots exist, create a new list with the current time slot
                    updatedSlots = [TimeSlot]
                }
                
                // Update the document with the new list of slots
                db.collection("Providers")
                    .document(selectedProvider)
                    .collection("Availability")
                    .document(formattedDate)
                    .setData(["slots": updatedSlots], merge: true) { error in
                        if let error = error {
                            print("Error updating availability: \(error)")
                        } else {
                            confirmationMessage = "Availability updated for \(selectedProvider) on \(formattedDate) at \(TimeSlot)."
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                confirmationMessage = ""
                            }
                        }
                    }
            }
    }

    
    // Reschedule the appointment
    private func rescheduleAppointment() {
        confirmationMessage = ""
        availableSlot = ""
        showRescheduleOptions = false
    }
}

#Preview {
    ProviderAvailabilityView()
}
