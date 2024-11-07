import SwiftUI

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
            .onChange(of: selectedProvider) { _ in
                loadAvailableSlots(for: selectedProvider)
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
                confirmAvailability()
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
            loadAvailableSlots(for: selectedProvider)
        }
    }

    // Load available slots based on selected provider
    private func loadAvailableSlots(for provider: String) {
        availableSlots = allAvailableSlots[provider, default: []]
        providerUnavailable = availableSlots.isEmpty
    }

    // Add a new time slot to the provider's availability
    private func addTimeSlot() {
        guard !availableSlot.isEmpty else { return }
        allAvailableSlots[selectedProvider]?.append(availableSlot)
        loadAvailableSlots(for: selectedProvider) // Refresh available slots
        availableSlot = "" // Clear the input field
    }

    // Confirm the availability update
    private func confirmAvailability() {
        confirmationMessage = "Availability updated for \(selectedProvider)."
        showRescheduleOptions = true
        sendNotification()
    }

    // Mock function to send a notification
    private func sendNotification() {
        print("Notification sent to user about updated availability.")
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
