//
//  RegistrationManager.swift
//  StorkCare+
//
//  Created by Bamlak T on 12/3/24.
//

import FirebaseAuth

class RegistrationManager {
    static let shared = RegistrationManager()
    
    func registerUser(email: String, password: String, role: String, completion: @escaping (Result<UserProfile, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let user = result?.user else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "User creation failed"])))
                return
            }
            
            let profile = UserProfile(
                uid: user.uid,
                email: email,
                role: role,
                isOnboarded: false
            )
            
            UserDatabaseManager.shared.saveUser(profile: profile) { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(profile))
                }
            }
        }
    }
}
