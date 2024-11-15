import SwiftUI

struct ProviderAvailabilityView: View {
    @ObservedObject var viewModel = ProviderAvailabilityViewModel()

    let timeSlots = [
        "9:00 AM", "10:00 AM", "11:00 AM", "12:00 PM",
        "1:00 PM", "2:00 PM", "3:00 PM", "4:00 PM", "5:00 PM"
    ]
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical, showsIndicators: true) {
                VStack(spacing: 20) {
                    
                    // MARK: - Provider Info Section
                    if !viewModel.providerData.occupation.isEmpty {
                        ProviderInfoCard(providerData: viewModel.providerData)
                            .accessibilityIdentifier("ProviderInfoCard") // Accessibility Identifier for provider info card
                    }
                    
                    // MARK: - Calendar Section
                    VStack(alignment: .leading) {
                        Text("Select Date")
                            .font(.headline)
                            .padding(.horizontal)
                            .accessibilityIdentifier("DateLabel") // Accessibility Identifier for Date label
                        
                        DatePicker(
                            "Select Date",
                            selection: $viewModel.selectedDate,
                            in: Date()...,
                            displayedComponents: [.date]
                        )
                        .datePickerStyle(.graphical)
                        .padding()
                        .accessibilityIdentifier("DatePicker") // Accessibility Identifier for DatePicker
                    }
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                    .padding(.horizontal)
                    
                    // MARK: - Time Slots Section
                    VStack(alignment: .leading) {
                        Text("Available Time Slots")
                            .font(.headline)
                            .padding(.bottom, 5)
                            .accessibilityIdentifier("TimeSlotsLabel") // Accessibility Identifier for Time Slots label
                        
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
                                .accessibilityIdentifier("TimeSlotButton-\(time)") // Accessibility Identifier for each time slot button
                            }
                        }
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                    .padding(.horizontal)
                    
                    // MARK: - Confirm Button Section
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
                    .accessibilityIdentifier("ConfirmButton") // Accessibility Identifier for the confirm button
                    
                    // MARK: - Message Section (Success/Error)
                    if let message = viewModel.message {
                        Text(message)
                            .foregroundColor(message.contains("Error") ? .red : .green)
                            .padding()
                            .accessibilityIdentifier("MessageLabel") // Accessibility Identifier for the message label
                    }
                    
                    Spacer()
                        .frame(height: 50)
                }
                .frame(minHeight: geometry.size.height)
            }
        }
        .onAppear {
            // MARK: - ViewModel Data Load
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
    
    // MARK: - Toggle Time Slot Function
    private func toggleTimeSlot(_ time: String) {
        if viewModel.selectedTimeSlots.contains(time) {
            viewModel.selectedTimeSlots.remove(time)
        } else {
            viewModel.selectedTimeSlots.insert(time)
        }
    }
    
    // MARK: - Helper Function to Format Date
    private func formatDateForDisplay(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

struct ProviderInfoCard: View {
    var providerData: ProviderData

    var body: some View {
        VStack {
            Text(providerData.name)
                .font(.title)
                .bold()
                .accessibilityIdentifier("ProviderName") // Accessibility Identifier for provider name
            Text(providerData.occupation)
                .font(.subheadline)
                .foregroundColor(.gray)
                .accessibilityIdentifier("ProviderOccupation") // Accessibility Identifier for provider occupation
            Text(providerData.placeOfWork)
                .font(.subheadline)
                .foregroundColor(.gray)
                .accessibilityIdentifier("ProviderPlaceOfWork") // Accessibility Identifier for provider place of work
            Text(providerData.gender)
                .font(.subheadline)
                .foregroundColor(.gray)
                .accessibilityIdentifier("ProviderGender") // Accessibility Identifier for provider gender
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
        .padding(.horizontal)
    }
}

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
