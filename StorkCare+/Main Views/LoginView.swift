import SwiftUI
import FirebaseAuth

struct LoginView: View {
    @State private var isAuthenticated: Bool = false
    @StateObject private var viewModel = LoginViewModel()
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Welcome Back to StorkCare+")
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
            
            Button(action: {
                viewModel.login()
            }) {
                if viewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                } else {
                    Text("Login")
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.pink)
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding(.horizontal)
            .disabled(viewModel.isLoading)
            
            if let message = viewModel.message {
                Text(message)
                    .foregroundColor(viewModel.isAuthenticated ? .green : .red)
                    .multilineTextAlignment(.center)
                    .padding()
            }
            
            NavigationLink(destination: RegistrationView(isAuthenticated: $isAuthenticated)) {
                Text("Don't have an account? Register")
                    .foregroundColor(.blue)
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
