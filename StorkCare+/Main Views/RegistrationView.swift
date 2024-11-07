import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct RegistrationView: View {
    @Binding var isAuthenticated: Bool // Binding to update the authentication state
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var role: String = "" // Stores selected role
    @State private var message: String? = nil
    @State private var uid: String = "" // State variable to store the user's UID

    let db = Firestore.firestore()
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Register for StorkCare+")
                .font(.largeTitle)
                .bold()
                .padding()
            
            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
                .autocapitalization(.none)
                .keyboardType(.emailAddress)
            
            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            
            // Picker for Role Selection
            Picker("Select Your Role", selection: $role) {
                Text("Healthcare Provider").tag("Healthcare Provider")
                Text("Pregnant Woman").tag("Pregnant Woman")
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)
            
            Button("Register") {
                registerUser(email: email, password: password, role: role)
            }
            .padding()
            .background(role.isEmpty ? Color.gray : Color.pink)
            .foregroundColor(.white)
            .cornerRadius(10)
            .disabled(role.isEmpty) // Disable if role is not selected
            
            if let message = message {
                Text(message)
                    .foregroundColor(isAuthenticated ? .green : .red)
                    .padding()
            }
        }
        .onAppear {
            // Check if user is already authenticated
            if Auth.auth().currentUser != nil {
                isAuthenticated = true
            }
        }
    }
    
    func registerUser(email: String, password: String, role: String) {
        guard !role.isEmpty else {
            message = "Please select a role"
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                message = "Registration failed: \(error.localizedDescription)"
                isAuthenticated = false
                return
            }
            
            // Store the user's UID in the state variable
            if let user = authResult?.user {
                uid = user.uid
                saveUserData(uid: user.uid, email: email, role: role)
            }
        }
    }
    
    func saveUserData(uid: String, email: String, role: String) {
        db.collection("users").document(uid).setData([
            "email": email,
            "role": role,
            "isOnboarded": false // Track onboarding completion
        ]) { error in
            if let error = error {
                message = "Failed to save user data: \(error.localizedDescription)"
                isAuthenticated = false
            } else {
                isAuthenticated = true
                message = "Registration successful!"
            }
        }
    }
}
