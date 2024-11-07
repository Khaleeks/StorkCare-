import SwiftUI
import FirebaseCore
import FirebaseAuth

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct StorkCare_App: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    // Track if the user is logged in (or completed introduction)
    @State private var isAuthenticated = false // Set to false initially
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                if isAuthenticated {
                    // Show the main app features
                    ContentView()
                } else {
                    // Show the introduction/registration flow
                    IntroductionPage(isAuthenticated: $isAuthenticated)
                        .onAppear {
                            checkAuthenticationStatus()
                        }
                }
            }
        }
    }
    
    func checkAuthenticationStatus() {
        // Force sign out first (for testing purposes, to ensure we start fresh)
        try? Auth.auth().signOut()
        
        // Check current user status
        if let user = Auth.auth().currentUser {
            print("User is authenticated with UID: \(user.uid)")
            isAuthenticated = true
        } else {
            print("No user is currently authenticated")
            isAuthenticated = false
        }
    }

}
