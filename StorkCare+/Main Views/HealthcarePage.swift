//
//  HealthcarePage.swift
//  StorkCare+
//
//  Created by Bamlak T on 11/7/24.
//

import SwiftUI
import FirebaseFirestore

struct HealthcarePage: View {
    @State private var gender: String = ""
    @State private var occupation: String = ""
    @State private var placeOfWork: String = ""
    @State private var message: String? = nil
    @State private var isOnboardingComplete = false // Navigate to features after completion

    let uid: String // Pass the authenticated user's UID

    var body: some View {
        VStack {
            Text("Healthcare Provider Onboarding")
                .font(.largeTitle)
                .lineLimit(1)
                .padding()
            
            TextField("Gender", text: $gender)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            
            TextField("Occupation", text: $occupation)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            
            TextField("Place of Work", text: $placeOfWork)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            
            Button("Complete Onboarding") {
                saveHealthcareProviderData()
            }
            .padding()
            .background(Color.pink)
            .foregroundColor(.white)
            .cornerRadius(10)
            
            if let message = message {
                Text(message)
                    .foregroundColor(isOnboardingComplete ? .green : .red)
                    .padding()
            }
        }
        .navigationDestination(isPresented: $isOnboardingComplete) {
            ContentView() // Navigate to the main features page
        }
    }
    
    func saveHealthcareProviderData() {
        let db = Firestore.firestore()
        db.collection("users").document(uid).updateData([
            "gender": gender,
            "occupation": occupation,
            "placeOfWork": placeOfWork,
            "isOnboarded": true // Update onboarding status
        ]) { error in
            if let error = error {
                message = "Failed to save data: \(error.localizedDescription)"
                isOnboardingComplete = false
            } else {
                message = "Onboarding complete!"
                isOnboardingComplete = true
            }
        }
    }
}
