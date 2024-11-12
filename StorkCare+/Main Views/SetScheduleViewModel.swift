//
//  SetScheduleViewModel.swift
//  StorkCare+
//
//  Created by Khaleeqa Garrett on 11/11/24.
//


import SwiftUI

class SetScheduleViewModel: ObservableObject {
    @Published var scheduleFrequency: String = ""
    @Published var specificTimes: [String] = []
    @Published var capsuleQuantity: String = "1 capsule"
    @Published var startDate: Date = Date()
    @Published var endDate: Date = Date()
    @Published var showSummary: Bool = false
    @Published var showErrorMessage: Bool = false
    var frequencyOptions: [String] = ["Once a day", "Twice a day", "Every other day"]

    func addTime(_ time: Date) {
        specificTimes.append("\(time)")
    }

    func onNextButtonTapped() {
        // Example: if no time is added, show error
        if specificTimes.isEmpty {
            showErrorMessage = true
        } else {
            showSummary = true
        }
    }
}
