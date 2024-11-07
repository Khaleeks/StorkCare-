import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct RegistrationView: View {
    @Binding var isAuthenticated: Bool
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var role: String = "" // Stores selected role
    @State private var isRegistered = false
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
                    .foregroundColor(isRegistered ? .green : .red)
                    .padding()
            }
        }
        .navigationDestination(isPresented: $isRegistered) {
            // Navigate to role-specific onboarding view
            if role == "Healthcare Provider" {
                HealthcarePage(uid: uid)
            } else if role == "Pregnant Woman" {
                PregnantWomanPage(uid: uid)
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
                isRegistered = false
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
                isRegistered = false
            } else {
                isRegistered = true
                message = "Registration successful!"
            }
        }
    }
}
