// BabyDevelopment.swift
// StorkCare+
//
// Created by Khaleeqa Garrett on 10/23/24.
//
import SwiftUI

struct ScheduleTelehealthView: View {
    @State private var selectedSlot: String = ""
    @State private var selectedProvider: String = ""
    @State private var confirmationMessage: String = ""
    @State private var showRescheduleOptions: Bool = false
    @State private var availableSlots: [String] = []
    @State private var noSlotsAvailable: Bool = false
    @State private var providerUnavailable: Bool = false
    @State private var appointmentConfirmed = false
    
    // Mock data for providers and available slots
    let providers = ["Dr. Smith", "Dr. Johnson", "Dr. Lee"]
    let allAvailableSlots: [String: [String]] = [
        "Dr. Smith": ["9:00 AM", "10:30 AM", "1:00 PM", "3:00 PM"],
        "Dr. Johnson": ["10:00 AM", "11:30 AM", "2:00 PM"],
        "Dr. Lee": [] // Dr. Lee is unavailable
    ]

    var body: some View {
        VStack(spacing: 20) {
            Text("Schedule a Telehealth Consultation")
                .font(.largeTitle)
                .padding()

            // Provider Selection
            Text("Select a Healthcare Provider:")
                .font(.headline)

            Picker("Select a Provider", selection: $selectedProvider) {
                ForEach(providers, id: \.self) { provider in
                    Text(provider)
                }
            }
            .pickerStyle(WheelPickerStyle())
            .padding()
            .onChange(of: selectedProvider) { oldValue, newValue in
                loadAvailableSlots(for: newValue)
            }

            // Display available slots or handle no availability
            if providerUnavailable {
                Text("This provider is currently unavailable.")
                    .foregroundColor(.red)
                    .padding()
                Button("Select a Different Provider") {
                    providerUnavailable = false
                    selectedProvider = ""
                }
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
                    .pickerStyle(WheelPickerStyle())
                    .padding()
                }
            }

            // Confirm Button and Message
            Button("Confirm Appointment") {
                confirmAppointment()
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
                Button("Reschedule Appointment") {
                    rescheduleAppointment()
                }
                .padding()
            }
        }
        .padding()
        .onAppear {
            selectedProvider = providers.first ?? ""
            loadAvailableSlots(for: selectedProvider)
        }
    }

    // Function to load available slots based on selected provider
    private func loadAvailableSlots(for provider: String) {
        if let slots = allAvailableSlots[provider] {
            availableSlots = slots
            if slots.isEmpty {
                if provider == "Dr. Lee" {
                    providerUnavailable = true
                    noSlotsAvailable = false
                } else {
                    noSlotsAvailable = true
                    providerUnavailable = false
                }
            } else {
                providerUnavailable = false
                noSlotsAvailable = false
            }
        }
    }

    // Function to confirm the appointment
    private func confirmAppointment() {
        if selectedSlot.isEmpty {
            confirmationMessage = "Please select a time slot."
        } else {
            appointmentConfirmed = true
            confirmationMessage = "Appointment confirmed with \(selectedProvider) for \(selectedSlot)"
            showRescheduleOptions = true
            sendNotification()
        }
    }

    // Mock function to send a notification
    private func sendNotification() {
        // In a real-world scenario, this would integrate with notification services to send reminders
        print("Notification sent to user and provider.")
    }

    // Function to handle rescheduling
    private func rescheduleAppointment() {
        confirmationMessage = ""
        selectedSlot = ""
        showRescheduleOptions = false
    }
}

#Preview {
    ScheduleTelehealthView()
}
