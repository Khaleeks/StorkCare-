import SwiftUI

// Define the ProviderAvailabilityView
struct ProviderAvailabilityView: View {
    @StateObject private var viewModel = ProviderAvailabilityViewModel()

    let timeSlots = [
        "9:00 AM", "10:00 AM", "11:00 AM", "12:00 PM",
        "1:00 PM", "2:00 PM", "3:00 PM", "4:00 PM", "5:00 PM"
    ]
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical, showsIndicators: true) {
                VStack(spacing: 20) {
                    // Provider Info Section
                    if !viewModel.providerData.occupation.isEmpty {
                        ProviderInfoCard(providerData: viewModel.providerData)
                    }
                    
                    // Calendar Section
                    VStack(alignment: .leading) {
                        Text("Select Date")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        DatePicker(
                            "Select Date",
                            selection: $viewModel.selectedDate,
                            in: Date()...,
                            displayedComponents: [.date]
                        )
                        .datePickerStyle(.graphical)
                        .padding()
                    }
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                    .padding(.horizontal)
                    
                    // Time Slots Section
                    VStack(alignment: .leading) {
                        Text("Available Time Slots")
                            .font(.headline)
                            .padding(.bottom, 5)
                        
                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: 10) {
                            ForEach(timeSlots, id: \.self) { time in
                                TimeSlotButton(
                                    time: time,
                                    isSelected: viewModel.selectedTimeSlots.contains(time),
                                    action: {
                                        toggleTimeSlot(time)
                                    }
                                )
                            }
                        }
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                    .padding(.horizontal)
                    
                    // Confirm Button
                    Button(action: {
                        viewModel.showingConfirmation = true
                    }) {
                        Text("Confirm Selected Times")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(viewModel.selectedTimeSlots.isEmpty ? Color.gray : Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .disabled(viewModel.selectedTimeSlots.isEmpty)
                    .padding(.horizontal)
                    
                    if let message = viewModel.message {
                        Text(message)
                            .foregroundColor(message.contains("Error") ? .red : .green)
                            .padding()
                    }
                    
                    Spacer()
                        .frame(height: 50)
                }
                .frame(minHeight: geometry.size.height)
            }
        }
        .onAppear {
            viewModel.loadProviderData()
            viewModel.loadExistingAvailability()
        }
        .alert("Confirm Availability", isPresented: $viewModel.showingConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Confirm") {
                viewModel.saveAvailability()
            }
        } message: {
            Text("Are you sure you want to confirm these time slots for \(formatDateForDisplay(viewModel.selectedDate))?")
        }
    }
    
    private func toggleTimeSlot(_ time: String) {
        if viewModel.selectedTimeSlots.contains(time) {
            viewModel.selectedTimeSlots.remove(time)
        } else {
            viewModel.selectedTimeSlots.insert(time)
        }
    }
    
    private func formatDateForDisplay(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

// Provider Info Card View
struct ProviderInfoCard: View {
    var providerData: ProviderData

    var body: some View {
        VStack {
            Text(providerData.name)
                .font(.title)
                .bold()
            Text(providerData.occupation)
                .font(.subheadline)
                .foregroundColor(.gray)
            Text(providerData.placeOfWork)
                .font(.subheadline)
                .foregroundColor(.gray)
            Text(providerData.gender)
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
        .padding(.horizontal)
    }
}

// Time Slot Button View
struct TimeSlotButton: View {
    var time: String
    var isSelected: Bool
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(time)
                .padding()
                .frame(maxWidth: .infinity)
                .background(isSelected ? Color.blue : Color.white)
                .foregroundColor(isSelected ? .white : .blue)
                .cornerRadius(10)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth: 2))
        }
    }
}
