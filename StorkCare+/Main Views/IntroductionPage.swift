import SwiftUI

struct IntroductionPage: View {
    @State private var isAuthenticated: Bool = false
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
                .frame(height: 20)
            
            Text("Welcome to StorkCare+")
                .font(.largeTitle)
                .bold()
                .foregroundColor(.pink)
            
            VStack(alignment: .leading, spacing: 20) {
                FeatureRow(
                    icon: "video.fill",
                    title: "Schedule Telehealth Consultation",
                    description: "Conveniently schedule telehealth consultations with your chosen healthcare provider."
                )
                
                FeatureRow(
                    icon: "chart.bar.fill",
                    title: "Track Baby Development",
                    description: "Monitor your baby's growth week by week."
                )
                
                FeatureRow(
                    icon: "alarm.fill",
                    title: "Medication Reminder",
                    description: "Set reminders to take medications on time."
                )
            }
            .padding(.horizontal)
            
            Spacer()
            
            VStack(spacing: 15) {
                NavigationLink {
                    LoginView()
                } label: {
                    Text("Login")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.pink)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                NavigationLink {
                    RegistrationView(isAuthenticated: $isAuthenticated)
                } label: {
                    Text("Register")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .padding(.horizontal)
        }
        .padding()
        .navigationBarBackButtonHidden(true)
    }
}

private struct FeatureRow: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.pink)
                .imageScale(.large)
            VStack(alignment: .leading) {
                Text(title)
                    .font(.headline)
                    .bold()
                Text(description)
                    .font(.subheadline)
            }
        }
        .padding()
    }
}
