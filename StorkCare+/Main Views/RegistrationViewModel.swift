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
    @Published var uid: String = ""

    private let db = Firestore.firestore()

    func validateEmail() -> Bool {
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

        isLoading = true
        
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.isLoading = false
                
                if let error = error {
                    self.message = "Registration failed: \(error.localizedDescription)"
                    self.isAuthenticated = false
                    return
                }
                
                if let user = result?.user {
                    self.uid = user.uid
                    self.saveUserData(uid: user.uid, email: self.email, role: self.role)
                }
            }
        }
    }

    private func saveUserData(uid: String, email: String, role: String) {
        let userData: [String: Any] = [
            "email": email,
            "role": role,
            "isOnboarded": false,
            "createdAt": FieldValue.serverTimestamp()
        ]

        db.collection("users").document(uid).setData(userData) { [weak self] error in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
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
}
