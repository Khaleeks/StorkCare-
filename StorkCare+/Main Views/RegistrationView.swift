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
                .accessibilityIdentifier("RegisterTitle") // Accessibility Identifier

            TextField("Email", text: $viewModel.email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
                .autocapitalization(.none)
                .keyboardType(.emailAddress)
                .accessibilityIdentifier("EmailTextField") // Accessibility Identifier

            SecureField("Password", text: $viewModel.password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
                .accessibilityIdentifier("PasswordSecureField") // Accessibility Identifier

            Picker("Select Your Role", selection: $viewModel.role) {
                Text("Healthcare Provider").tag("Healthcare Provider")
                Text("Pregnant Woman").tag("Pregnant Woman")
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)
            .accessibilityIdentifier("RolePicker") // Accessibility Identifier

            Button("Register") {
                viewModel.registerUser()
            }
            .padding()
            .background(viewModel.role.isEmpty ? Color.gray : Color.pink)
            .foregroundColor(.white)
            .cornerRadius(10)
            .disabled(viewModel.role.isEmpty)
            .accessibilityIdentifier("RegisterButton") // Accessibility Identifier

            if let message = viewModel.message {
                Text(message)
                    .foregroundColor(.green)
                    .padding()
                    .accessibilityIdentifier("MessageLabel") // Accessibility Identifier
            }

            if viewModel.isLoading {
                ProgressView()
                    .accessibilityIdentifier("LoadingProgressView") // Accessibility Identifier
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

