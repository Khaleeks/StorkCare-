import SwiftUI

struct IntroductionPage: View {
    @Binding var isAuthenticated: Bool // Binding to update authentication state

    var body: some View {
        VStack(spacing: 40) {
            Spacer() // Slightly pushes the welcome text down
                .frame(height: 20) // Adjust this value for finer control

            Text("Welcome to StorkCare+")
                .font(.largeTitle)
                .bold()
                .foregroundColor(.pink)

            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    Image(systemName: "video.fill")
                        .foregroundColor(.pink)
                        .imageScale(.large) // Makes the icon slightly larger
                    VStack(alignment: .leading) {
                        Text("Schedule Telehealth Consultation")
                            .font(.headline)
                            .bold()
                            .foregroundColor(.black)
                        Text("Conveniently schedule telehealth consultations with your chosen healthcare provider.")
                            .font(.subheadline)
                            .foregroundColor(.black)
                    }
                }
                
                HStack {
                    Image(systemName: "chart.bar.fill")
                        .foregroundColor(.pink)
                        .imageScale(.large) // Makes the icon slightly larger
                    VStack(alignment: .leading) {
                        Text("Track Baby Development")
                            .font(.headline)
                            .bold()
                            .foregroundColor(.black)
                        Text("Monitor your baby's growth week by week.")
                            .font(.subheadline)
                            .foregroundColor(.black)
                    }
                }

                HStack {
                    Image(systemName: "alarm.fill")
                        .foregroundColor(.pink)
                        .imageScale(.large) // Makes the icon slightly larger
                    VStack(alignment: .leading) {
                        Text("Medication Reminder")
                            .font(.headline)
                            .bold()
                            .foregroundColor(.black)
                        Text("Set reminders to take medications on time.")
                            .font(.subheadline)
                            .foregroundColor(.black)
                    }
                }
            }
            .padding(.horizontal)

            Spacer()

            NavigationLink(destination: RegistrationView(isAuthenticated: $isAuthenticated)) {
                Text("Continue")
                    .bold()
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.pink)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
        }
        .padding()
    }
}

#Preview {
    NavigationStack {
        IntroductionPage(isAuthenticated: .constant(false))
    }
}
