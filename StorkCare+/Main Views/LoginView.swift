import SwiftUI

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isLoggedIn = false
    @State private var errorMessage: String?

    var body: some View {
        VStack {
            Text("Login to StorkCare+")
                .font(.largeTitle)
                .padding()

            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }

            Button("Login") {
                // Simple hardcoded credential check instead of using a database
                if email == "test@example.com" && password == "password" {
                    isLoggedIn = true
                    errorMessage = nil
                } else {
                    errorMessage = "Invalid email or password"
                }
            }
            .padding()
            .background(Color.pink)
            .foregroundColor(.white)
            .cornerRadius(10)

            NavigationLink(destination: RegistrationView()) {
                Text("Don't have an account? Register here.")
                    .foregroundColor(.blue)
                    .padding()
            }
        }
        .padding()
        .navigationDestination(isPresented: $isLoggedIn) {
           IntroductionPage() // Your main app view after logging in
        }
    }
}
