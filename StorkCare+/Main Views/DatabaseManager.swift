//
//  DatabaseManager.swift
//  StorkCare+
//
//  Created by Bamlak T on 12/3/24.
//

import FirebaseFirestore
import FirebaseAuth

class UserDatabaseManager {
    static let shared = UserDatabaseManager()
    private let db = Firestore.firestore()
    
    func saveUser(profile: UserProfile, completion: @escaping (Error?) -> Void) {
        let data: [String: Any] = [
            "uid": profile.uid,
            "email": profile.email,
            "role": profile.role,
            "isOnboarded": profile.isOnboarded,
            "name": profile.name ?? "",
            "gender": profile.gender ?? "",
            "dateOfBirth": profile.dateOfBirth ?? Date(),
            "pregnancyStartDate": profile.pregnancyStartDate,
            "height": profile.height ?? 0,
            "weight": profile.weight ?? 0,
            "medicalHistory": profile.medicalHistory ?? "",
            "occupation": profile.occupation ?? "",
            "placeOfWork": profile.placeOfWork ?? "",
            "createdAt": FieldValue.serverTimestamp()
        ]
        
        db.collection("users").document(profile.uid).setData(data) { error in
            completion(error)
        }
    }
    
    func fetchUserProfile(uid: String, completion: @escaping (UserProfile?, Error?) -> Void) {
        db.collection("users").document(uid).getDocument { snapshot, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let data = snapshot?.data() else {
                completion(nil, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data found"]))
                return
            }
            
            // Convert Firestore data to UserProfile
            let profile = UserProfile(
                uid: uid,
                email: data["email"] as? String ?? "",
                role: data["role"] as? String ?? "",
                isOnboarded: data["isOnboarded"] as? Bool ?? false
            )
            
            completion(profile, nil)
        }
    }
    
    func updateUserProfile(uid: String, data: [String: Any], completion: @escaping (Error?) -> Void) {
        db.collection("users").document(uid).updateData(data) { error in
            completion(error)
        }
    }
}
