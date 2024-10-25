//
//  MedicationReminderView.swift
//  StorkCare+
//
//  Created by Khaleeqa Garrett on 10/23/24.
//

import SwiftUI
import UserNotifications

struct MedicationReminderView: View {
    @State private var medicationName: String = ""
    @State private var reminderTime = Date()
    @State private var frequency: Int = 1 // Default to once a day
    @State private var confirmationMessage: String = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        VStack {
            Text("Set Medication Reminder")
                .font(.title)
                .padding()

            // Input for medication name
            TextField("Enter Medication Name", text: $medicationName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            // Input for reminder time using DatePicker
            DatePicker("Select Reminder Time", selection: $reminderTime, displayedComponents: .hourAndMinute)
                .datePickerStyle(WheelDatePickerStyle())
                .padding()

            // Input for frequency of medication dose (e.g., daily, twice daily)
            Stepper(value: $frequency, in: 1...4) {
                Text("Frequency: \(frequency) times a day")
            }
            .padding()

            // Button to set the reminder
            Button("Set Reminder") {
                if medicationName.isEmpty {
                    showAlert(message: "Please enter the medication name.")
                } else {
                    setReminder()
                }
            }
            .padding()

            // Display confirmation message
            Text(confirmationMessage)
                .foregroundColor(.green)
                .padding()
            
            // Alert for missing or conflicting information
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
        .padding()
    }

    // Function to handle the setting of a reminder
    func setReminder() {
        let center = UNUserNotificationCenter.current()

        // Check for notification permissions
        center.getNotificationSettings { settings in
            if settings.authorizationStatus == .denied {
                showAlert(message: "Notifications are disabled. Please enable them in settings.")
                return
            }
        }

        // Create the content for the notification
        let content = UNMutableNotificationContent()
        content.title = "Medication Reminder"
        content.body = "Time to take your \(medicationName)"
        
        // Loop through frequency to set multiple reminders
        for i in 0..<frequency {
            let adjustedTime = Calendar.current.date(byAdding: .hour, value: i * (24 / frequency), to: reminderTime) ?? reminderTime
            let adjustedTrigger = Calendar.current.dateComponents([.hour, .minute], from: adjustedTime)
            
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: UNCalendarNotificationTrigger(dateMatching: adjustedTrigger, repeats: true))
            
            center.add(request) { error in
                if let error = error {
                    showAlert(message: "Error setting reminder: \(error.localizedDescription)")
                }
            }
        }

        // Set confirmation message
        confirmationMessage = "Reminder set for \(medicationName), \(frequency) times a day"
    }

    // Function to handle alert display
    func showAlert(message: String) {
        alertMessage = message
        showAlert = true
    }
}
