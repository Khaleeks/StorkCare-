import SwiftUI

struct AddMedicationView: View {
    @Binding var medications: [Medication] // Binding to the list of medications
    @State private var medicationName: String = ""
    @State private var selectedMedicationType: String = "Capsule" // Default selection
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var showingSetSchedule = false // State for navigation to set schedule

    // List of medication types
    let medicationTypes = ["Capsule", "Tablet", "Liquid", "Topical", "Ointment", "Injection", "Spray"]

    var body: some View {
        VStack(spacing: 20) {
            Text("Add Medication")
                .font(.title)
                .padding()

            // Bold label for medication name
            Text("Medication Name:")
                .font(.headline)
                .bold()
                .padding(.top)

            // Input for medication name
            TextField("Enter Medication Name", text: $medicationName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            // Medication type selection
            Text("Choose the Medication Type:")
                .font(.headline)
                .bold()
                .padding(.top)

            Picker("Medication Type", selection: $selectedMedicationType) {
                ForEach(medicationTypes, id: \.self) { type in
                    Text(type)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .padding()

            // Next button to navigate to set schedule view
            Button("Next") {
                if medicationName.isEmpty {
                    showAlert(message: "Please enter the medication name.")
                } else {
                    // Navigate to the set schedule view
                    showingSetSchedule = true
                }
            }
            .padding()
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(10)

            // Alert for missing information
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
            // Navigation to set schedule view
            .navigationDestination(isPresented: $showingSetSchedule) {
                SetScheduleView(medications: $medications)
            }
        }
        .padding()
    }

    // Function to handle alert display
    private func showAlert(message: String) {
        alertMessage = message
        showAlert = true
    }
}

// Preview
#Preview {
    AddMedicationView(medications: .constant([]))
}
