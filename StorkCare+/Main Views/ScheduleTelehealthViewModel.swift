//
//  ScheduleTelehealthViewModel.swift
//  StorkCare+
//
//  Created by Khaleeqa Garrett on 11/13/24.
//


// ScheduleTelehealthViewModel.swift
import SwiftUI
import Combine

class ScheduleTelehealthViewModel: ObservableObject {
    @Published var selectedSlot: String = ""
    @Published var selectedProvider: String = ""
    @Published var selectedDate: Date = Date()
    @Published var confirmationMessage: String = ""
    @Published var showRescheduleOptions: Bool = false
    @Published var availableSlots: [String] = []
    @Published var noSlotsAvailable: Bool = false
    @Published var providerUnavailable: Bool = false
    
    
    let providers = ["Dr. Smith", "Dr. Johnson", "Dr. Lee"]
    let allAvailableSlots: [String: [String]] = [
        "Dr. Smith": ["9:00 AM", "10:30 AM", "1:00 PM", "3:00 PM"],
        "Dr. Johnson": ["10:00 AM", "11:30 AM", "2:00 PM"],
        "Dr. Lee": []
    ]
    
    func loadAvailableSlots(for provider: String) {
        if let slots = allAvailableSlots[provider] {
            availableSlots = slots
            noSlotsAvailable = slots.isEmpty && provider != "Dr. Lee"
            providerUnavailable = provider == "Dr. Lee" && slots.isEmpty
        }
    }
    
    func confirmAppointment() {
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
    
    func rescheduleAppointment() {
        confirmationMessage = ""
        selectedSlot = ""
        showRescheduleOptions = false
    }
    
    private func sendNotification() {
        print("Notification sent to user and provider.")
    }
}
