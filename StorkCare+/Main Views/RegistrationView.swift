import SwiftUI
import FirebaseAuth

struct RegistrationView: View {
    @Binding var isAuthenticated: Bool
    @ObservedObject var viewModel = RegistrationViewModel()
    
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
                .disabled(viewModel.isEmailVerified)

            SecureField("Password", text: $viewModel.password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
                .disabled(viewModel.isEmailVerified)
            
            
            Picker("Select Your Role", selection: $viewModel.role) {
                Text("Healthcare Provider").tag("Healthcare Provider")
                Text("Pregnant Woman").tag("Pregnant Woman")
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)
            .disabled(viewModel.isEmailVerified)
            
            Button(action: {
                viewModel.registerUser()
            }) {
                if viewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                } else {
                    Text(viewModel.isEmailVerified ? "Continue" : "Register")
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(viewModel.role.isEmpty ? Color.gray : Color.pink)
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding(.horizontal)
            .disabled(viewModel.role.isEmpty || viewModel.isLoading)
            
            if let message = viewModel.message {
                Text(message)
                    .foregroundColor(viewModel.isAuthenticated ? .green : .red)
                    .multilineTextAlignment(.center)
                    .padding()
            }
            
            if viewModel.isEmailVerified {
                Text("✓ Email verified")
                    .foregroundColor(.green)
                    .padding()
            }
        }
        .padding()
        .navigationDestination(isPresented: $viewModel.isAuthenticated) {
            if viewModel.role == "Healthcare Provider" {
                HealthcarePage(uid: viewModel.uid, isAuthenticated: $isAuthenticated)
            } else {
                PregnantWomanPage(uid: viewModel.uid, isAuthenticated: $isAuthenticated)
            }
        }
    }
}
