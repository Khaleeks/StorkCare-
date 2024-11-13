//
//  HealthcarePage.swift
//  StorkCare+
//
//  Created by Bamlak T on 11/7/24.
//

import SwiftUI

struct HealthcarePage: View {
    @StateObject private var viewModel = HealthcarePageViewModel()
    
    var uid: String // Pass the authenticated user's UID

    var body: some View {
        VStack {
            Text("Healthcare Provider Onboarding")
                .font(.largeTitle)
                .lineLimit(1)
                .padding()
            
            TextField("Gender", text: $viewModel.gender)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            
            TextField("Occupation", text: $viewModel.occupation)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            
            TextField("Place of Work", text: $viewModel.placeOfWork)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            
            Button("Complete Onboarding") {
                viewModel.saveHealthcareProviderData(uid: uid)
            }
            .padding()
            .background(Color.pink)
            .foregroundColor(.white)
            .cornerRadius(10)
            
            if let message = viewModel.message {
                Text(message)
                    .foregroundColor(viewModel.isOnboardingComplete ? .green : .red)
                    .padding()
            }
        }
        .navigationDestination(isPresented: $viewModel.isOnboardingComplete) {
            ContentView() // Navigate to the main features page when onboarding is complete
        }
    }
}
