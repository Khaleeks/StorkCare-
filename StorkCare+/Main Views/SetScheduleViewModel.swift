//
//  SetScheduleViewModel.swift
//  StorkCare+
//
//  Created by Khaleeqa Garrett on 11/11/24.
//


import SwiftUI

class SetScheduleViewModel: ObservableObject {
    @Published var scheduleFrequency: String = "Every day"
    @Published var specificTimes: [String] = []
    @Published var capsuleQuantity: String = "1 capsule"
    @Published var startDate: Date = Date()
    @Published var endDate: Date = Date()
    @Published var showSummary = false
    @Published var showErrorMessage = false // New property for error message

    let frequencyOptions = ["Every day", "On a cyclical schedule", "On specific days of the week", "As needed"]
    
    func addTime(_ time: Date) {
        specificTimes.append(formattedTime(time))
        showErrorMessage = false // Hide error when time is added
    }

    func onNextButtonTapped() {
        // If no time is added, show an error message
        if specificTimes.isEmpty {
            showErrorMessage = true
        } else {
            showSummary = true
        }
    }

    private func formattedTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
