import SwiftUI

struct AddMedicationView: View {
    @Binding var medications: [Medication] // Binding to the medications list
    @StateObject private var viewModel: AddMedicationViewModel

    // Initialize the view model with medications
       init(medications: Binding<[Medication]>) {
           _medications = medications
           _viewModel = StateObject(wrappedValue: AddMedicationViewModel(medications: medications.wrappedValue))
       }
    
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
            TextField("Enter Medication Name", text: $viewModel.medicationName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            // Medication type selection
            Text("Choose the Medication Type:")
                .font(.headline)
                .bold()
                .padding(.top)

            // Access medication types from the view model
            Picker("Medication Type", selection: $viewModel.selectedMedicationType) {
                ForEach(viewModel.medicationTypes, id: \.self) { type in
                    Text(type)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .padding()

            // Next button to navigate to set schedule view
            Button("Next") {
                viewModel.onNextButtonTapped()
            }
            .padding()
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(10)
            .alert(isPresented: $viewModel.showAlert) {
                Alert(title: Text("Error"), message: Text(viewModel.alertMessage), dismissButton: .default(Text("OK")))
            }
            // Navigation to set schedule view
            .navigationDestination(isPresented: $viewModel.showingSetSchedule) {
                SetScheduleView(medications: $viewModel.medications)
            }
        }
        .padding()
    }
}

// Preview
#Preview {
    AddMedicationView(medications: .constant([]))
}
