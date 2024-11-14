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
        let passwordRegex = "^(?=.*[A-Z])(?=.*[a-z])(?=.*\\d)(?=.*[!@#$%^&*]).{6,30}$"
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passwordPredicate.evaluate(with: password)
    }




    func registerUser() {
        if !validateEmail() {
            message = "Invalid email format."
            isAuthenticated = false
            return
        }
        
        if !validatePassword() {
            message = "Password must be at least 6 to 30 characters long, contain a number, and a special character."
            isAuthenticated = false
            return
        }
        
        if role.isEmpty {
            message = "Please select a role."
            isAuthenticated = false
            return
        }

        // Simulate successful registration
        isAuthenticated = true
        message = "Registration successful!"
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
