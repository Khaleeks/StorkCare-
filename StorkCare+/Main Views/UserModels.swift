//
//  UserModels.swift
//  StorkCare+
//
//  Created by Bamlak T on 12/3/24.
//

import FirebaseFirestore
import FirebaseAuth

// MARK: - User Data Models
struct UserProfile: Codable {
    let uid: String
    var email: String
    var role: String
    var isOnboarded: Bool
    
    // Common fields for all users
    var name: String?
    var gender: String?
    var dateOfBirth: Date?
    
    // Fields specific to pregnant women
    var pregnancyStartDate: Date?
    var height: Int?
    var weight: Int?
    var medicalHistory: String?
    
    // Fields specific to healthcare providers
    var occupation: String?
    var placeOfWork: String?
}
