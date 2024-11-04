//  StorkCarePlusApp.swift
//  StorkCare+
//
//  Created by Khaleeqa Garrett on 10/23/24.
//

import SwiftUI
import SwiftData

@main
struct StorkCarePlusApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                RegistrationView() // Starts from the Registration page
            }
            // Registering the User model with SwiftData for persistence
            .modelContainer(for: User.self)
        }
    }
}
