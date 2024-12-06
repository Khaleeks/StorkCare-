import SwiftUI
import FirebaseFirestore
import FirebaseAuth

class LoginViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var message: String? = nil
    @Published var isAuthenticated: Bool = false
    @Published var isLoading: Bool = false
    @Published var role: String = ""
    @Published var uid: String = ""
    
    private let db = Firestore.firestore()
    
    func login() {
        if email.isEmpty || password.isEmpty {
            message = "Please fill in all fields"
            return
        }
        
        isLoading = true
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.isLoading = false
                
                if let error = error {
                    self.message = "Login failed: \(error.localizedDescription)"
                    return
                }
                
                if let user = result?.user {
                    if user.isEmailVerified {
                        self.uid = user.uid
                        print("User ID: \(self.uid)") // Debug print
                        self.fetchUserRole()
                    } else {
                        self.message = "Please verify your email before logging in."
                        do {
                            try Auth.auth().signOut()
                        } catch {
                            print("Error signing out: \(error.localizedDescription)")
                        }
                    }
                }
            }
        }
    }
    
    private func fetchUserRole() {
        print("Fetching user role for UID: \(uid)") // Debug print
        
        db.collection("users").document(uid).getDocument { [weak self] document, error in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                if let error = error {
                    print("Firestore error: \(error.localizedDescription)") // Debug print
                    self.message = "Error fetching user data: \(error.localizedDescription)"
                    return
                }
                
                if let document = document {
                    print("Document exists: \(document.exists)") // Debug print
                    if let data = document.data() {
                        print("Document data: \(data)") // Debug print
                        if let role = data["role"] as? String {
                            self.role = role
                            self.isAuthenticated = true
                            self.message = "Login successful!"
                        } else {
                            self.message = "User role not found"
                            print("Role field missing in document") // Debug print
                        }
                    } else {
                        self.message = "No user data found"
                        print("Document exists but no data") // Debug print
                    }
                } else {
                    self.message = "User document not found"
                    print("Document does not exist") // Debug print
                }
            }
        }
    }
}
