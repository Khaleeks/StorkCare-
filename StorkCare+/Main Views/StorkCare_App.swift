import SwiftUI
import FirebaseCore
import FirebaseAuth

// Define the AppDelegate class
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct StorkCare_App: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @State private var isAuthenticated = false
    @State private var authListener: AuthStateDidChangeListenerHandle?
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                if isAuthenticated {
                    ContentRouterView()
                } else {
                    IntroductionPage(isAuthenticated: $isAuthenticated)
                }
            }
            .onAppear {
                authListener = Auth.auth().addStateDidChangeListener { _, user in
                    isAuthenticated = user != nil
                }
            }
        }
    }
}
