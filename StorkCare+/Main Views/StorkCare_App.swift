import SwiftUI
import SwiftData

@main
struct StorkCarePlusApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                RegistrationView() // Your starting view
            }
            .modelContainer(for: AppUser.self) // Register AppUser for persistence
        }
    }
}
