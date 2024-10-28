import SwiftUI

struct SetupMedicationView: View {
    @Binding var medications: [Medication] // Binding to the list of medications
    @State private var showingAddMedication = false // State to control navigation to add medication view

    var body: some View {
        NavigationStack { // Wrap in a NavigationStack for navigation
            ZStack {
                // Background color
                Color(.systemGray6) // Light gray background for the entire screen
                    .ignoresSafeArea()

                // White box in the center
                VStack(spacing: 20) {
                    Text("Set Up Medications")
                        .font(.title)
                        .bold()
                        .padding()

                    // Fun introduction text
                    Text("Let’s keep your health on track! Set reminders and manage your medications effortlessly!")
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal) // Added horizontal padding
                        .foregroundColor(.gray)
                        .lineLimit(nil) // Allow multiple lines
                        .fixedSize(horizontal: false, vertical: true) // Allow vertical expansion

                    // Display features of the medication management
                    VStack(spacing: 10) {
                        featureRow(icon: "checkmark.circle.fill", text: "Track all your medications in one place.", color: .green)
                        featureRow(icon: "bell.fill", text: "Set a schedule and get reminders for each medication.", color: .orange)
                        featureRow(icon: "list.bullet", text: "View a list of your medications.", color: .blue)
                    }
                    .padding(.horizontal) // Added horizontal padding

                    Spacer()

                    // Button to navigate to add medication view
                    Button("Add Medication") {
                        showingAddMedication = true
                    }
                    .padding()
                    .background(Color.pink)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .frame(maxWidth: .infinity) // Make button span the full width of the box
                    .padding(.horizontal) // Added horizontal padding
                    .padding(.bottom, 20) // Add some space at the bottom
                    
                    // Navigation to the add medication view
                    .navigationDestination(isPresented: $showingAddMedication) {
                        AddMedicationView(medications: $medications) // Assuming you have this view defined
                    }
                }
                .padding()
                .background(Color.white) // White background for the box
                .cornerRadius(20) // Rounded corners
                .shadow(radius: 10) // Shadow for better visibility
                .padding() // Add padding around the box
                .frame(maxWidth: 500) // Set a maximum width but allow dynamic height
            }
        }
    }
    
    // Helper function to create a feature row with an icon and text
    private func featureRow(icon: String, text: String, color: Color) -> some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(color)
                .font(.title) // Set icon size
            Text(text)
                .multilineTextAlignment(.leading) // Align text to leading
                .font(.body)
                .padding(.leading, 10) // Add space between icon and text
                .lineLimit(nil) // Allow multiple lines
                .fixedSize(horizontal: false, vertical: true) // Allow vertical expansion
        }
        .frame(maxWidth: .infinity, alignment: .leading) // Left align the entire row
        .padding() // Add padding for the row
    }
}

#Preview {
    SetupMedicationView(medications: .constant([])) // Preview with empty medication list
}
