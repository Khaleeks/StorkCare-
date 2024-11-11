//
//  exampleUser.swift
//  StorkCare+
//
//  Created by Aribah Zaman on 11/11/2024.
//
import SwiftUI
import FirebaseFirestore

class makeExampleUser {

    @State private var isProfileCreated = false
    @State private var message: String? = nil
    @State private var dateOfBirth: String = "2000-04-06"
    @State private var pregnancyStartDate: String = "2024-03-05"
    
    
    // Helper function to format date for display
    private func dateFormatted(stringDate: String) -> Date {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withFullDate]
        return formatter.date(from: stringDate)!
    }
  
    
    init () {
        self.saveExamplePregnantWomanData()
    }
  
    func saveExamplePregnantWomanData(){
        let db = Firestore.firestore()
        db.collection("PregnantUsers").document("4567").updateData([
            "name": "Elizabeth",
            "selectedSex": "female",
            "dateOfBirth": dateFormatted(stringDate: dateOfBirth),
            "pregnancyStartDate": dateFormatted(stringDate: pregnancyStartDate),
            "medicalHistory": "allergies",
            "selectedHeight": 160,
            "selectedWeight": 70,
            "isProfileCreated" : true
        ]) { error in
            if let error = error {
                self.message = "Failed to save data: \(error.localizedDescription)"
                self.isProfileCreated = false
            } else {
                self.message = "Health profile has been updated!"
                self.isProfileCreated = true
            }
        }
    }
}
