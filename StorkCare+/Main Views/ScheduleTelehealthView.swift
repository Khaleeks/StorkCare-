// BabyDevelopment.swift
// StorkCare+
//
// Created by Cassandra Salazar
import SwiftUI
import FirebaseFirestore

// ScheduleTelehealthView.swift
struct ScheduleTelehealthView: View {
    @StateObject var viewModel = ScheduleTelehealthViewModel()
    var body: some View {
        VStack(spacing: 20) {
            Text("Schedule a Telehealth Consultation")
                .font(.largeTitle)
                .foregroundColor(.white)
                .padding()
                .background(RoundedRectangle(cornerRadius: 20).fill(Color.blue))
            
            DatePicker("Select Appointment Date:", selection: $viewModel.selectedDate, displayedComponents: [.date])
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).fill(Color.white))
                .cornerRadius(10)
            
            Text("Select a Healthcare Provider:")
                .font(.headline)
                .foregroundColor(.pink)
            
            Picker("Select a Provider", selection: $viewModel.selectedProvider) {
                ForEach(viewModel.providers, id: \.self) { provider in
                    Text(provider)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .padding()
            .background(RoundedRectangle(cornerRadius: 10).fill(Color.white))
            .cornerRadius(10)
            .onChange(of: viewModel.selectedProvider) { newProvider in
                viewModel.loadAvailableSlots(for: newProvider)
            }

            if viewModel.providerUnavailable {
                Text("This provider is currently unavailable.")
                    .foregroundColor(.red)
                    .padding()
            } else if viewModel.noSlotsAvailable {
                Text("No slots available at this time. We'll notify you when slots open up.")
                    .foregroundColor(.red)
                    .padding()
            } else if !viewModel.availableSlots.isEmpty {
                Picker("Select a Time Slot", selection: $viewModel.selectedSlot) {
                    ForEach(viewModel.availableSlots, id: \.self) { slot in
                        Text(slot)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).fill(Color.white))
                .cornerRadius(10)
            }
            
            Button(action: viewModel.confirmAppointment) {
                Text("Confirm Appointment")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
            .disabled(viewModel.selectedSlot.isEmpty || viewModel.providerUnavailable || viewModel.noSlotsAvailable)
            
            if !viewModel.confirmationMessage.isEmpty {
                Text(viewModel.confirmationMessage)
                    .foregroundColor(.green)
                    .padding()
            }
            
            if viewModel.showRescheduleOptions {
                Button(action: viewModel.rescheduleAppointment) {
                    Text("Reschedule Appointment")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.pink)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
            }
        }
        .padding()
        .background(Color.blue.opacity(0.1))
        .cornerRadius(20)
        .shadow(radius: 5)
    }
}

#Preview {
    ScheduleTelehealthView()
}
