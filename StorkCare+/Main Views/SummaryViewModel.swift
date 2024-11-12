//
//  SummaryViewModel.swift
//  StorkCare+
//
//  Created by Khaleeqa Garrett on 11/12/24.
//


import SwiftUI

class SummaryViewModel: ObservableObject {
    @Published var medications: [Medication]
    @Published var scheduleFrequency: String
    @Published var specificTimes: [String]
    @Published var capsuleQuantity: String
    @Published var startDate: Date
    @Published var endDate: Date

    init(medications: [Medication], scheduleFrequency: String, specificTimes: [String], capsuleQuantity: String, startDate: Date, endDate: Date) {
        self.medications = medications
        self.scheduleFrequency = scheduleFrequency
        self.specificTimes = specificTimes
        self.capsuleQuantity = capsuleQuantity
        self.startDate = startDate
        self.endDate = endDate
    }
}
