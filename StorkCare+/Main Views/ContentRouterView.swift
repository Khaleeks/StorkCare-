//
//  ContentRouterView.swift
//  StorkCare+
//
//  Created by Bamlak T on 12/5/24.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct ContentRouterView: View {
    @State private var userRole: String?
    @State private var isLoading = true
    @Binding var isAuthenticated: Bool
    @Environment(\.dismiss) private var dismiss
    
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
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: signOut) {
                    Text("Sign Out")
                        .foregroundColor(.red)
                }
            }
        }
        .onAppear {
            loadUserRole()
        }
    }
    
    private func signOut() {
        do {
            try Auth.auth().signOut()
            dismiss()
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
    
    private func loadUserRole() {
        guard let userId = Auth.auth().currentUser?.uid else {
            userRole = nil
            isLoading = false
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
