//
//  HealthcarePage.swift
//  StorkCare+
//
//  Created by Bamlak T on 11/7/24.
//

import SwiftUI

struct HealthcarePage: View {
    @ObservedObject var viewModel = HealthcarePageViewModel()
    
    var uid: String // Pass the authenticated user's UID

    var body: some View {
        VStack {
            Text("Healthcare Provider Onboarding")
                .font(.largeTitle)
                .lineLimit(1)
                .padding()
                .tag(1) // Tag for title text
            
            TextField("Gender", text: $viewModel.gender)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
                .tag(2) // Tag for gender TextField
            
            TextField("Occupation", text: $viewModel.occupation)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
                .tag(3) // Tag for occupation TextField
            
            TextField("Place of Work", text: $viewModel.placeOfWork)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
                .tag(4) // Tag for place of work TextField
            
            Button("Complete Onboarding") {
                viewModel.saveHealthcareProviderData(uid: uid)
            }
            .padding()
            .background(Color.pink)
            .foregroundColor(.white)
            .cornerRadius(10)
            .tag(5) // Tag for Complete Onboarding button
            
            if let message = viewModel.message {
                Text(message)
                    .foregroundColor(viewModel.isOnboardingComplete ? .green : .red)
                    .padding()
                    .tag(6) // Tag for message text
            }
        }
        .navigationDestination(isPresented: $viewModel.isOnboardingComplete) {
            ContentView() // Navigate to the main features page when onboarding is complete
        }
    }
}
