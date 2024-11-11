//
//  AddMedicationViewModel.swift
//  StorkCare+
//
//  Created by Khaleeqa Garrett on 11/11/24.
//


import SwiftUI
import Combine

class AddMedicationViewModel: ObservableObject {
    @Published var medications: [Medication]
    @Published var medicationName: String = ""
    @Published var selectedMedicationType: String = "Capsule"
    @Published var showAlert = false
    @Published var alertMessage = ""
    @Published var showingSetSchedule = false
    
    // Adding the medication types to the view model
        let medicationTypes = ["Capsule", "Tablet", "Liquid", "Topical", "Ointment", "Injection", "Spray"]
        
    
    init(medications: [Medication] = []) {
        self.medications = medications
    }
    
    // Handle the 'Next' button tap action
    func onNextButtonTapped() {
        if medicationName.isEmpty {
            showAlert(message: "Please enter the medication name.")
        } else {
            showingSetSchedule = true
        }
    }
    
    // Function to show alert with the given message
    private func showAlert(message: String) {
        alertMessage = message
        showAlert = true
    }
}
