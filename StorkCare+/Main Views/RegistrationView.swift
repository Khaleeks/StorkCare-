import SwiftUI
import Foundation

struct RegistrationView: View {
    @State private var users: [AppUser] = [] // Change User to AppUser
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var selectedUser: AppUser? = nil // Track selected user for login
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
                    .lineLimit(1)
                    .minimumScaleFactor(0.5) // Scale down to fit within one line if needed

                if users.isEmpty {
                    Text("No registered users. Please register a new user.")
                        .padding()
                        .lineLimit(1)
                        .minimumScaleFactor(0.5) // Adjust text size to fit within one line if needed
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

    private func loadUserDetails(user: AppUser) {
        name = user.name
        email = user.email
        password = user.password
        isRegistered = true // Navigate to next page after selecting user
    }

    private func registerUser(name: String, email: String, password: String) {
        let newUser = AppUser(name: name, email: email, password: password)
        users.append(newUser) // Add the new user to the local array
        message = "Registration successful!" // Confirmation message
        isRegistered = true // Set registration status to true
    }

    private func clearFields() {
        name = ""
        email = ""
        password = ""
    }
}
