//
//  SummaryViewModel.swift
//  StorkCare+
//
//  Created by Khaleeqa Garrett on 11/12/24.
//


import SwiftUI

class SummaryViewModel: ObservableObject {
    @Binding var medications: [Medication]
    var scheduleFrequency: String
    var specificTimes: [String]
    var capsuleQuantity: String
    var startDate: Date
    var endDate: Date

    init(medications: Binding<[Medication]>, scheduleFrequency: String, specificTimes: [String], capsuleQuantity: String, startDate: Date, endDate: Date) {
        self._medications = medications
        self.scheduleFrequency = scheduleFrequency
        self.specificTimes = specificTimes
        self.capsuleQuantity = capsuleQuantity
        self.startDate = startDate
        self.endDate = endDate
    }
}

