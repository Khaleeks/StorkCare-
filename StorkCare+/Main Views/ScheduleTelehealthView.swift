import SwiftUI
import FirebaseFirestore

struct ScheduleTelehealthView: View {
    @ObservedObject var viewModel = ScheduleTelehealthViewModel()
    @State private var shareHealthDataProfile: String = "No"

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                TitleSection()
                AppointmentDateSection(selectedDate: $viewModel.selectedDate, viewModel: viewModel)
                ProviderSection(viewModel: viewModel)
                AvailabilityStatusSection(viewModel: viewModel)
                TimeSlotSection(viewModel: viewModel)
                AppointmentButtonsSection(viewModel: viewModel)
                HealthDataSection(shareHealthDataProfile: $shareHealthDataProfile)
            }
            .padding()
            .background(
                Color(UIColor.systemGroupedBackground)
                    .edgesIgnoringSafeArea(.all)
            )
        }
    }
}

// Title Section
struct TitleSection: View {
    var body: some View {
        VStack(spacing: 8) {
            Text("Schedule Consultation")
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
        .frame(maxWidth: 600)
    }
}

// Date Picker Section
struct AppointmentDateSection: View {
    @Binding var selectedDate: Date
    @ObservedObject var viewModel: ScheduleTelehealthViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Select Appointment Date:")
                .font(.headline)
                .foregroundColor(.secondary)
            
            DatePicker("", selection: $selectedDate, displayedComponents: [.date])
                .labelsHidden()
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.white)
                        .shadow(radius: 5)
                )
                .onChange(of: selectedDate) { _ in
                    viewModel.loadAvailableSlots()  // Reload slots when date changes
                }
        }
        .padding(.horizontal)
        .frame(maxWidth: 600)
    }
}

// Provider Section
struct ProviderSection: View {
    @ObservedObject var viewModel: ScheduleTelehealthViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Select a Healthcare Provider:")
                .font(.headline)
                .foregroundColor(.secondary)
            
            Picker("Select a Provider", selection: $viewModel.selectedProvider) {
                Text("Select Provider").tag(nil as ProviderListItem?)
                ForEach(viewModel.providers) { provider in
                    Text("Dr. \(provider.name) - \(provider.occupation)")  // Show name and occupation
                        .tag(Optional(provider))
                }
            }
            .pickerStyle(MenuPickerStyle())
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.white)
                    .shadow(radius: 5)
            )
            .onChange(of: viewModel.selectedProvider) { _ in
                viewModel.loadAvailableSlots()
            }
        }
        .padding(.horizontal)
        .frame(maxWidth: 600)
    }
}

// Availability Status Section
struct AvailabilityStatusSection: View {
    @ObservedObject var viewModel: ScheduleTelehealthViewModel
    
    var body: some View {
        Group {
            if viewModel.providerUnavailable {
                Text("This provider is currently unavailable.")
                    .foregroundColor(.red)
                    .font(.footnote)
                    .padding()
                    .frame(maxWidth: 600)
            } else if viewModel.noSlotsAvailable {
                Text("No slots available at this time. We'll notify you when slots open up.")
                    .foregroundColor(.red)
                    .font(.footnote)
                    .padding()
                    .frame(maxWidth: 600)
            }
        }
    }
}

// Time Slot Section
struct TimeSlotSection: View {
    @ObservedObject var viewModel: ScheduleTelehealthViewModel
    
    var body: some View {
        Group {
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
                .frame(maxWidth: 600)
            }
        }
    }
}

// Buttons Section
struct AppointmentButtonsSection: View {
    @ObservedObject var viewModel: ScheduleTelehealthViewModel
    
    var body: some View {
        VStack {
            Button(action: viewModel.confirmAppointment) {
                Text("Confirm Appointment")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(20)
                    .shadow(radius: 5)
            }
            .disabled(viewModel.selectedSlot.isEmpty || viewModel.providerUnavailable || viewModel.noSlotsAvailable)
            .padding(.horizontal)
            .frame(maxWidth: 600)
            
            if !viewModel.confirmationMessage.isEmpty {
                Text(viewModel.confirmationMessage)
                    .foregroundColor(.green)
                    .padding()
                    .font(.body)
                    .frame(maxWidth: 600)
            }
            
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
                .frame(maxWidth: 600)
            }
        }
    }
}

// Health Data Section
struct HealthDataSection: View {
    @Binding var shareHealthDataProfile: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Would you like to share your health data profile with the provider?")
                .font(.headline)
                .foregroundColor(.secondary)
            
            Picker("Share Health Data Profile?", selection: $shareHealthDataProfile) {
                Text("Yes").tag("Yes")
                Text("No").tag("No")
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.white)
                    .shadow(radius: 5)
            )
            .padding(.horizontal)
            .frame(maxWidth: 600)
            
            Button(action: {
                print("Health Data Sharing Selected: \(shareHealthDataProfile)")
            }) {
                Text("Confirm Health Data Sharing")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(20)
                    .shadow(radius: 5)
            }
            .padding(.horizontal)
            .frame(maxWidth: 600)
        }
    }
}
