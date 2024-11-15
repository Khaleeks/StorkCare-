import SwiftUI

struct RegistrationView: View {
    @Binding var isAuthenticated: Bool
    @ObservedObject var viewModel = RegistrationViewModel()

    @State private var pregnantWomanViewModel = PregnantWomanViewModel()

    var body: some View {
        VStack(spacing: 20) {
            Text("Register for StorkCare+")
                .font(.largeTitle)
                .bold()
                .padding()
                .accessibilityIdentifier("RegisterTitle")

            TextField("Email", text: $viewModel.email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
                .autocapitalization(.none)
                .keyboardType(.emailAddress)
                .accessibilityIdentifier("EmailTextField")
            
            SecureField("Password", text: $viewModel.password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
                .accessibilityIdentifier("PasswordSecureField")

            Picker("Select Your Role", selection: $viewModel.role) {
                Text("Healthcare Provider").tag("Healthcare Provider")
                Text("Pregnant Woman").tag("Pregnant Woman")
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)
            .accessibilityIdentifier("RolePicker")

            Button("Register") {
                viewModel.registerUser()
            }
            .padding()
            .background(viewModel.role.isEmpty ? Color.gray : Color.pink)
            .foregroundColor(.white)
            .cornerRadius(10)
            .disabled(viewModel.role.isEmpty)
            .accessibilityIdentifier("RegisterButton")

            if let message = viewModel.message {
                Text(message)
                    .foregroundColor(.green)
                    .padding()
                    .accessibilityIdentifier("MessageLabel")
            }

            if viewModel.isLoading {
                ProgressView()
                    .accessibilityIdentifier("LoadingProgressView")
            }
        }
        .navigationDestination(isPresented: $viewModel.isAuthenticated) {
            if viewModel.role == "Healthcare Provider" {
                HealthcarePage(uid: "someUID")
            } else if viewModel.role == "Pregnant Woman" {
                PregnantWomanPage(viewModel: pregnantWomanViewModel, uid: "someUID")
            }
        }
    }
}
