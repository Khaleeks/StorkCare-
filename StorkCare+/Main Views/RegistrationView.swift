//
//  PregnantWomanPage.swift
//  StorkCare+
//
//  Created by Bamlak T on 11/7/24.
//


// RegistrationView.swift
import SwiftUI

struct RegistrationView: View {
    @Binding var isAuthenticated: Bool  // Use @Binding to accept a reference

    @ObservedObject var viewModel = RegistrationViewModel()

    @State private var pregnantWomanViewModel = PregnantWomanViewModel() // Create a PregnantWomanViewModel for navigation

    var body: some View {
        VStack(spacing: 20) {
            Text("Register for StorkCare+")
                .font(.largeTitle)
                .bold()
                .padding()

            TextField("Email", text: $viewModel.email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
                .autocapitalization(.none)
                .keyboardType(.emailAddress)

            SecureField("Password", text: $viewModel.password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

            Picker("Select Your Role", selection: $viewModel.role) {
                Text("Healthcare Provider").tag("Healthcare Provider")
                Text("Pregnant Woman").tag("Pregnant Woman")
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)

            Button("Register") {
                viewModel.registerUser()
            }
            .padding()
            .background(viewModel.role.isEmpty ? Color.gray : Color.pink)
            .foregroundColor(.white)
            .cornerRadius(10)
            .disabled(viewModel.role.isEmpty)

            if let message = viewModel.message {
                Text(message)
                    .foregroundColor(.green)
                    .padding()
            }

            if viewModel.isLoading {
                ProgressView()
            }
        }
        .navigationDestination(isPresented: $viewModel.isAuthenticated) {
            if viewModel.role == "Healthcare Provider" {
                HealthcarePage(uid: "someUID") // Example UID
            } else if viewModel.role == "Pregnant Woman" {
                PregnantWomanPage(viewModel: pregnantWomanViewModel, uid: "someUID") // Pass viewModel to PregnantWomanPage
            }
        }
    }
}
