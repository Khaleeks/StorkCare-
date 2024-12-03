import SwiftUI

struct AddMedicationView: View {
    @Binding var medications: [Medication]
    @StateObject private var viewModel = AddMedicationViewModel()
    @State private var medicationName: String = ""
    @State private var selectedMedicationType: String = "Capsule"
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var showingSetSchedule = false // State for navigation
    
    let medicationTypes = ["Capsule", "Tablet", "Liquid", "Topical", "Ointment", "Injection", "Spray"]
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Add Medication")
                .font(.title)
                .padding()
            
            Text("Medication Name:")
                .font(.headline)
                .bold()
                .padding(.top)
            
            TextField("Enter Medication Name", text: $medicationName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
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
            
            Button("Next") {
                if medicationName.isEmpty {
                    showAlert(message: "Please enter the medication name.")
                } else {
                    showingSetSchedule = true
                }
            }
            .padding()
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(10)
            
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Error"),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
        .padding()
        .navigationDestination(isPresented: $showingSetSchedule) {
            SetScheduleView(medications: $medications)
        }
    }
    
    private func showAlert(message: String) {
        alertMessage = message
        showAlert = true
    }
}
