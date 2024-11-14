//
//  PregnantWomanViewModel.swift
//  StorkCare+
//
//  Created by Khaleeqa Garrett on 11/12/24.
//


import SwiftUI
import Combine

class PregnantWomanViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var selectedSex: String = ""
    @Published var dateOfBirth: Date = Date()
    @Published var pregnancyStartDate: Date = Date()
    @Published var medicalHistory: String = ""
    @Published var selectedHeight: Int = 0
    @Published var selectedWeight: Int = 0
    @Published var showSexPicker: Bool = false
    @Published var showHeightPicker: Bool = false
    @Published var showWeightPicker: Bool = false
    @Published var showDatePicker: Bool = false
    @Published var showPregnancyDatePicker: Bool = false
    @Published var isProfileCreated: Bool = false

    func savePregnantWomanData(uid: String) {
        if name.isEmpty || selectedSex.isEmpty || selectedHeight == 0 || selectedWeight == 0 {
            isProfileCreated = false
        } else {
            isProfileCreated = true
        }
    }

    func dateFormatted(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: date)
    }

    // Add the resetFields method to clear all fields
    func resetFields() {
        name = ""
        selectedSex = ""
        dateOfBirth = Date()
        pregnancyStartDate = Date()
        medicalHistory = ""
        selectedHeight = 0
        selectedWeight = 0
        isProfileCreated = false
    }
}
