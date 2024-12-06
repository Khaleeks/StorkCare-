import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct ContentRouterView: View {
    @State private var userRole: String?
    @State private var isLoading = true
    @Binding var isAuthenticated: Bool
    
    var body: some View {
        Group {
            if isLoading {
                ProgressView("Loading...")
            } else {
                switch userRole {
                case "Healthcare Provider":
                    HealthcareContentView(isAuthenticated: $isAuthenticated)
                case "Pregnant Woman":
                    PregnantWomanContentView(isAuthenticated: $isAuthenticated)
                default:
                    Text("Unknown user role")
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            loadUserRole()
        }
    }
    
    private func loadUserRole() {
        guard let userId = Auth.auth().currentUser?.uid else {
            userRole = nil
            isLoading = false
            isAuthenticated = false
            return
        }
        
        let db = Firestore.firestore()
        db.collection("users").document(userId).getDocument { snapshot, error in
            DispatchQueue.main.async {
                if let data = snapshot?.data(),
                   let role = data["role"] as? String {
                    userRole = role
                }
                isLoading = false
            }
        }
    }
}
