import SwiftUI
import FirebaseCore
import FirebaseAuth

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
    @StateObject private var authStateManager = AuthStateManager()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                if authStateManager.isAuthenticated {
                    ContentRouterView(isAuthenticated: $authStateManager.isAuthenticated)
                } else {
                    IntroductionPage()
                }
            }
        }
    }
}
