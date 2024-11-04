import SwiftUI
import Foundation

struct RegistrationView: View {
    @State private var users: [AppUser] = [] // Update to use AppUser
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var selectedUser: AppUser? = nil // Update to use AppUser
    @State private var isRegistered = false // State to check registration status
    @State private var showRegistrationFields = false // Show registration form
    @State private var message: String? = nil // For displaying registration messages

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("Register for StorkCare+")
                    .font(.largeTitle)
                    .bold()
                    .padding()

                // Display list of existing users
                if users.isEmpty {
                    Text("No registered users. Please register a new user.")
                        .padding()
                } else {
                    Text("Select an existing user:")
                    List(users) { user in
                        Button(action: {
                            selectedUser = user
                            loadUserDetails(user: user)
                        }) {
                            HStack {
                                Text(user.name)
                                Text(user.email).foregroundColor(.gray)
                            }
                        }
                    }
                }

                // Show registration form for new user or updating details
                if showRegistrationFields {
                    TextField("Full Name", text: $name)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)

                    TextField("Email", text: $email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)

                    SecureField("Password", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)

                    Button("Register New User") {
                        registerUser(name: name, email: email, password: password)
                    }
                    .padding()
                    .background(Color.pink)
                    .foregroundColor(.white)
                    .cornerRadius(10)

                    if let message = message {
                        Text(message)
                            .foregroundColor(.green)
                            .padding()
                    }
                }

                Button(showRegistrationFields ? "Cancel" : "Register New User") {
                    showRegistrationFields.toggle()
                    if !showRegistrationFields { clearFields() }
                }
                .padding(.top)
            }
            .padding()
            .navigationDestination(isPresented: $isRegistered) {
                IntroductionPage() // Navigate to IntroductionPage after registration
            }
        }
    }

    // Load selected user's details for autofill
    private func loadUserDetails(user: AppUser) { // Update to use AppUser
        name = user.name
        email = user.email
        password = user.password
        isRegistered = true // Navigate to next page after selecting user
    }

    // Register a new user and add to the local array
    private func registerUser(name: String, email: String, password: String) {
        let newUser = AppUser(name: name, email: email, password: password) // Update to use AppUser
        users.append(newUser) // Add the new user to the local array
        message = "Registration successful!" // Confirmation message
        isRegistered = true // Set registration status to true
    }

    // Clear fields after registration or when canceling registration
    private func clearFields() {
        name = ""
        email = ""
        password = ""
    }
}
