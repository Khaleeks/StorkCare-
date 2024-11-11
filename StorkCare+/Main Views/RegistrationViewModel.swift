import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import Combine

class RegistrationViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var role: String = ""
    @Published var message: String? = nil
    @Published var isAuthenticated: Bool = false
    @Published var isLoading: Bool = false

    private let db = Firestore.firestore()

    func validateEmail() -> Bool {
        // Simple email regex validation
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }

    func validatePassword() -> Bool {
        // Password must be at least 8 characters, contain a number, and a special character
        let passwordRegEx = "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[!@#$%^&*])[A-Za-z\\d!@#$%^&*]{8,}$"
        let passwordPred = NSPredicate(format: "SELF MATCHES %@", passwordRegEx)
        return passwordPred.evaluate(with: password)
    }

    func registerUser() {
        guard !role.isEmpty else {
            message = "Please select a role."
            return
        }

        if !validateEmail() {
            message = "Invalid email format."
            return
        }

        if !validatePassword() {
            message = "Password must be at least 8 characters long, contain a number, and a special character."
            return
        }

        isLoading = true
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            self.isLoading = false
            if let error = error {
                self.message = "Registration failed: \(error.localizedDescription)"
                self.isAuthenticated = false
                return
            }

            if let user = authResult?.user {
                self.saveUserData(uid: user.uid, email: self.email, role: self.role)
            }
        }
    }

    private func saveUserData(uid: String, email: String, role: String) {
        db.collection("users").document(uid).setData([
            "email": email,
            "role": role,
            "isOnboarded": false
        ]) { error in
            if let error = error {
                self.message = "Failed to save user data: \(error.localizedDescription)"
                self.isAuthenticated = false
            } else {
                self.message = "Registration successful!"
                self.isAuthenticated = true
            }
        }
    }
}
