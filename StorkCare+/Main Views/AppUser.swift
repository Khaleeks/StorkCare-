//
//  AppUser.swift
//  StorkCare+
//
//  Created by Khaleeqa Garrett on 11/4/24.
//


import Foundation
import SwiftData

@Observable // Use @Observable or @Persisted instead of @Model
class AppUser: Identifiable { // Rename User to AppUser
    @Attribute(.unique) var id: UUID = UUID() // Unique identifier
    var name: String
    var email: String
    var password: String

    // Initializer for creating a new AppUser instance
    init(name: String, email: String, password: String) {
        self.name = name
        self.email = email
        self.password = password
    }
}
