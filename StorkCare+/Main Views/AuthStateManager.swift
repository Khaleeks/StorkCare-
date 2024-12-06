//
//  AuthStateManager.swift
//  StorkCare+
//
//  Created by Bamlak T on 12/6/24.
//

import SwiftUI
import FirebaseAuth

class AuthStateManager: ObservableObject {
    @Published var isAuthenticated = false
    private var handle: AuthStateDidChangeListenerHandle?
    
    init() {
        handle = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            DispatchQueue.main.async {
                self?.isAuthenticated = user != nil
            }
        }
    }
    
    deinit {
        if let handle = handle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
}
