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
        @Published var isEmailVerified: Bool = false  

    public let db = Firestore.firestore()

    func registerUser() {
        if !validateEmail() {
            message = "Invalid email format."
            return
        }
        
        if !validatePassword() {
            message = "Password must be 6-30 characters with a number and special character."
            return
        }
        
        if role.isEmpty {
            message = "Please select a role."
            return
        }

        isLoading = true
        
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                if let error = error {
                    self.isLoading = false
                    self.message = "Registration failed: \(error.localizedDescription)"
                    return
                }
                
                if let user = result?.user {
                    self.uid = user.uid
                    // Create initial user document
                    self.createInitialUserDocument(user: user) { success in
                        if success {
                            // Send verification email
                            self.sendVerificationEmail(user: user)
                        } else {
                            self.isLoading = false
                            self.message = "Failed to create user profile"
                        }
                    }
                }
            }
        }
    }
    
    private func sendVerificationEmail(user: User) {
        user.sendEmailVerification { [weak self] error in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                // Sign out the user after sending verification email
                do {
                    try Auth.auth().signOut()
                    self.isAuthenticated = false
                } catch {
                    print("Error signing out: \(error.localizedDescription)")
                }
                
                self.isLoading = false
                
                if let error = error {
                    self.message = "Failed to send verification email: \(error.localizedDescription)"
                } else {
                    self.message = "Verification email sent. Please verify your email before logging in."
                }
            }
        }
    }

    private func createInitialUserDocument(user: User, completion: @escaping (Bool) -> Void) {
        let userData: [String: Any] = [
            "email": email,
            "role": role,
            "isOnboarded": false,
            "createdAt": FieldValue.serverTimestamp()
        ]

        db.collection("users").document(user.uid).setData(userData) { error in
            if let error = error {
                print("Error creating user document: \(error.localizedDescription)")
                completion(false)
            } else {
                completion(true)
            }
        }
    }

    
    func validateEmail() -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    func validatePassword() -> Bool {
        let passwordRegex = "^(?=.*[0-9])(?=.*[!@#$%^&*])[A-Za-z0-9!@#$%^&*]{6,30}$"
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passwordPredicate.evaluate(with: password)
    }
}
