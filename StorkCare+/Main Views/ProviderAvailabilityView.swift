import SwiftUI
import Firebase
import FirebaseFirestore


struct ProviderAvailabilityView: View {
    @State private var providerName: String = ""
    @State private var appointmentTime: String = ""
    @State private var appointmentDate: Date = Date()
    @State private var message: String? = nil
    @State private var isOnboardingComplete = false // Navigate to features after completion

    let uid: String // Pass the authenticated user's UID

    var body: some View {
        VStack {
            Text("Healthcare Provider Onboarding")
                .font(.largeTitle)
                .lineLimit(1)
                .padding()
            
            TextField("Provider Name", text: $providerName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            
            DatePicker("Select Appointment Date", selection: $appointmentDate, displayedComponents: [.date])
                .padding(.horizontal)
            
            TextField("Appointment Time (e.g., 3:00 PM)", text: $appointmentTime)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            
            Button("Complete Onboarding") {
                saveProviderData()
            }
            .padding()
            .background(Color.pink)
            .foregroundColor(.white)
            .cornerRadius(10)
            
            if let message = message {
                Text(message)
                    .foregroundColor(isOnboardingComplete ? .green : .red)
                    .padding()
            }
        }
        .navigationDestination(isPresented: $isOnboardingComplete) {
            ContentView() // Navigate to the main features page
        }
    }
    
    func saveProviderData() {
        let db = Firestore.firestore()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let formattedDate = dateFormatter.string(from: appointmentDate)
        
        // Create the data to be saved
        let providerData: [String: Any] = [
            "name": providerName,
            "appointmentTime": appointmentTime,
            "appointmentDate": formattedDate
        ]
        
        // Save the data under the 'providers' collection
        db.collection("providers").document(providerName).setData(providerData) { error in
            if let error = error {
                message = "Failed to save data: \(error.localizedDescription)"
                isOnboardingComplete = false
            } else {
                message = "Onboarding complete!"
                isOnboardingComplete = true
            }
        }
    }
}

#Preview {
    ProviderAvailabilityView(uid: "sample-uid") // Pass a sample UID if needed
}
