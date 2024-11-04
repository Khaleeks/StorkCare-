import SwiftUI

struct SetupMedicationView: View {
    @Binding var medications: [Medication] // Binding to the list of medications
    @State private var showingAddMedication = false // State to control navigation to add medication view

    var body: some View {
        ZStack {
            // Background color
            Color(.systemGray6)
                .ignoresSafeArea()

            // White box in the center
            VStack(spacing: 20) {
                Text("Set Up Medications")
                    .font(.title)
                    .bold()
                    .padding()

                Text("Let’s keep your health on track! Set reminders and manage your medications effortlessly!")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .foregroundColor(.gray)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)

                VStack(spacing: 10) {
                    featureRow(icon: "checkmark.circle.fill", text: "Track all your medications in one place.", color: .green)
                    featureRow(icon: "bell.fill", text: "Set a schedule and get reminders for each medication.", color: .orange)
                    featureRow(icon: "list.bullet", text: "View a list of your medications.", color: .blue)
                }
                .padding(.horizontal)

                Spacer()

                // Button to navigate to add medication view
                Button("Add Medication") {
                    showingAddMedication = true
                }
                .padding()
                .background(Color.pink)
                .foregroundColor(.white)
                .cornerRadius(10)
                .frame(maxWidth: .infinity)
                .padding(.horizontal)
                .padding(.bottom, 20)
                
                // Navigation to the add medication view
                .navigationDestination(isPresented: $showingAddMedication) {
                    AddMedicationView(medications: $medications)
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(20)
            .shadow(radius: 10)
            .padding()
            .frame(maxWidth: 500)
        }
    }
    
    private func featureRow(icon: String, text: String, color: Color) -> some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(color)
                .font(.title)
            Text(text)
                .multilineTextAlignment(.leading)
                .font(.body)
                .padding(.leading, 10)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
    }
}

#Preview {
    SetupMedicationView(medications: .constant([]))
}
