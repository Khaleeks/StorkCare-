// BabyDevelopment.swift
// StorkCare+
//
// Created by Cassandra Salazar
import SwiftUI
import FirebaseFirestore

struct ScheduleTelehealthView: View {
    @State private var selectedSlot: String = ""
    @State private var selectedProvider: String = ""
    @State private var selectedDate: Date = Date() // New state variable for the selected date
    @State private var confirmationMessage: String = ""
    @State private var showRescheduleOptions: Bool = false
    @State private var availableSlots: [String] = []
    @State private var noSlotsAvailable: Bool = false
    @State private var providerUnavailable: Bool = false
    
    // Mock data for providers and available slots
    private let providers = ["Dr. Smith", "Dr. Johnson", "Dr. Lee"]
    private let allAvailableSlots: [String: [String]] = [
        "Dr. Smith": ["9:00 AM", "10:30 AM", "1:00 PM", "3:00 PM"],
        "Dr. Johnson": ["10:00 AM", "11:30 AM", "2:00 PM"],
        "Dr. Lee": [] // Dr. Lee is unavailable
    ]

    var body: some View {
        VStack(spacing: 20) {
            Text("Schedule a Telehealth Consultation")
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
            Text("Select a Healthcare Provider:")
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

            // Display availability message
            if providerUnavailable {
                Text("This provider is currently unavailable.")
                    .foregroundColor(.red)
                    .padding()
            } else if noSlotsAvailable {
                Text("No slots available at this time. We'll notify you when slots open up.")
                    .foregroundColor(.red)
                    .padding()
            } else {
                // Available Slots Picker
                if !availableSlots.isEmpty {
                    Picker("Select a Time Slot", selection: $selectedSlot) {
                        ForEach(availableSlots, id: \.self) { slot in
                            Text(slot)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.white))
                    .cornerRadius(10)
                }
            }

            // Confirm Button
            Button(action: {
                confirmAppointment()
            }) {
                Text("Confirm Appointment")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
            .disabled(selectedSlot.isEmpty || providerUnavailable || noSlotsAvailable)

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
        .background(Color.blue.opacity(0.1)) // Light blue background
        .cornerRadius(20)
        .shadow(radius: 5) // Add shadow for a lifted effect
        .onAppear {
            selectedProvider = providers.first ?? ""
            loadAvailableSlots(for: selectedProvider)
        }
    }

    // Load available slots based on selected provider
    private func loadAvailableSlots(for provider: String) {
        if let slots = allAvailableSlots[provider] {
            availableSlots = slots
            noSlotsAvailable = slots.isEmpty && provider != "Dr. Lee"
            providerUnavailable = provider == "Dr. Lee" && slots.isEmpty
        }
    }

    // Confirm the appointment
    private func confirmAppointment() {
        if selectedSlot.isEmpty {
            confirmationMessage = "Please select a time slot."
        } else {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            let formattedDate = dateFormatter.string(from: selectedDate)

            confirmationMessage = "Appointment confirmed with \(selectedProvider) on \(formattedDate) at \(selectedSlot)."
            showRescheduleOptions = true
            sendNotification()
        }
    }

    // Mock function to send a notification
    private func sendNotification() {
        // In a real-world scenario, this would integrate with notification services to send reminders
        print("Notification sent to user and provider.")
    }

    // Reset selections
    private func resetSelection() {
        providerUnavailable = false
        selectedProvider = ""
        selectedSlot = ""
    }

    // Reschedule the appointment
    private func rescheduleAppointment() {
        confirmationMessage = ""
        selectedSlot = ""
        showRescheduleOptions = false
    }
}

struct ScheduleTelehealthView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleTelehealthView()
    }
}
