import SwiftUI
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        let db = Firestore.firestore()
        
        // Use PersistentCacheSettings without setting sizeBytes`
        let cacheSettings = PersistentCacheSettings() // This enables persistence by default
        db.settings.cacheSettings = cacheSettings // Apply to Firestore settings
        
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
                    ContentView()
                } else {
                    IntroductionPage(isAuthenticated: $isAuthenticated)
                        .onAppear {
                            checkAuthenticationStatus()
                        }
                }
            }
        }
    }
    
    func checkAuthenticationStatus() {
        authListener = Auth.auth().addStateDidChangeListener { auth, user in
            if let user = user {
                print("User is authenticated with UID: \(user.uid)")
                isAuthenticated = true
                
                let db = Firestore.firestore()
                let userRef = db.collection("users").document(user.uid)
                userRef.getDocument { document, error in
                    if let error = error {
                        print("Error checking user document: \(error)")
                        return
                    }
                    
                    if let document = document, !document.exists {
                        userRef.setData([
                            "uid": user.uid,
                            "createdAt": FieldValue.serverTimestamp()
                        ]) { error in
                            if let error = error {
                                print("Error creating user document: \(error)")
                            }
                        }
                    }
                }
            } else {
                print("No user is currently authenticated")
                isAuthenticated = false
            }
        }
    }
    
    func removeAuthListener() {
        if let listener = authListener {
            Auth.auth().removeStateDidChangeListener(listener)
            authListener = nil
        }
    }
}
