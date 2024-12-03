import SwiftUI
import FirebaseFirestore

struct ScheduleTelehealthView: View {
    @StateObject var viewModel = ScheduleTelehealthViewModel()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Title Section
                VStack(spacing: 8) {
                    Text("Schedule a Telehealth Consultation")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text("Choose a date, provider, and time slot for your consultation.")
                        .font(.body)
                        .foregroundColor(.white.opacity(0.8))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .fill(Color.blue)
                )
                .padding(.bottom, 20)
                .frame(maxWidth: 600) // Set a max width to center the header
                
                // Appointment Date Picker
                VStack(alignment: .leading, spacing: 10) {
                    Text("Select Appointment Date:")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    
                    DatePicker("", selection: $viewModel.selectedDate, displayedComponents: [.date])
                        .labelsHidden()
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color.white)
                                .shadow(radius: 5)
                        )
                }
                .padding(.horizontal)
                .frame(maxWidth: 600) // Center the picker
                
                // Provider Picker
                VStack(alignment: .leading, spacing: 10) {
                    Text("Select a Healthcare Provider:")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    
                    Picker("Select a Provider", selection: $viewModel.selectedProvider) {
                        ForEach(viewModel.providers, id: \.self) { provider in
                            Text(provider)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.white)
                            .shadow(radius: 5)
                    )
                    .onChange(of: viewModel.selectedProvider) { newProvider in
                        viewModel.loadAvailableSlots(for: newProvider)
                    }
                }
                .padding(.horizontal)
                .frame(maxWidth: 600) // Center the picker
                
                // Availability Status
                if viewModel.providerUnavailable {
                    Text("This provider is currently unavailable.")
                        .foregroundColor(.red)
                        .font(.footnote)
                        .padding()
                        .frame(maxWidth: 600) // Center the text
                } else if viewModel.noSlotsAvailable {
                    Text("No slots available at this time. We'll notify you when slots open up.")
                        .foregroundColor(.red)
                        .font(.footnote)
                        .padding()
                        .frame(maxWidth: 600) // Center the text
                }
                
                // Time Slot Picker
                if !viewModel.availableSlots.isEmpty {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Select a Time Slot:")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        
                        Picker("Select a Time Slot", selection: $viewModel.selectedSlot) {
                            ForEach(viewModel.availableSlots, id: \.self) { slot in
                                Text(slot)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color.white)
                                .shadow(radius: 5)
                        )
                    }
                    .padding(.horizontal)
                    .frame(maxWidth: 600) // Center the picker
                }
                
                // Confirm Button
                Button(action: viewModel.confirmAppointment) {
                    Text("Confirm Appointment")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            Color.blue
                        )
                        .foregroundColor(.white)
                        .cornerRadius(20)
                        .shadow(radius: 5)
                }
                .disabled(viewModel.selectedSlot.isEmpty || viewModel.providerUnavailable || viewModel.noSlotsAvailable)
                .padding(.horizontal)
                .frame(maxWidth: 600) // Center the button
                
                // Confirmation Message
                if !viewModel.confirmationMessage.isEmpty {
                    Text(viewModel.confirmationMessage)
                        .foregroundColor(.green)
                        .padding()
                        .font(.body)
                        .frame(maxWidth: 600) // Center the text
                }
                
                // Reschedule Button
                if viewModel.showRescheduleOptions {
                    Button(action: viewModel.rescheduleAppointment) {
                        Text("Reschedule Appointment")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(20)
                            .shadow(radius: 5)
                    }
                    .padding(.horizontal)
                    .frame(maxWidth: 600) // Center the button
                }
            }
            .padding()
            .background(
                Color(UIColor.systemGroupedBackground)
                    .edgesIgnoringSafeArea(.all)
            )
        }
    }
}
