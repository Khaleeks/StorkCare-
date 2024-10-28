//
//  SetScheduleView.swift
//  StorkCare+
//
//  Created by Khaleeqa Garrett on 10/25/24.
//

import SwiftUI

struct SetScheduleView: View {
    @Binding var medications: [Medication] // Binding to medication list
    @State private var scheduleFrequency: String = "Every day"
    @State private var specificTimes: [String] = [] // Holds times added by user
    @State private var capsuleQuantity: String = "1 capsule" // Default quantity
    @State private var startDate: Date = Date() // Start date
    @State private var endDate: Date = Date() // End date
    @State private var showSummary = false // State to show summary view
    @State private var isAddingTime = false // State for time picker
    @State private var newTime = Date() // Holds new time being added

    let frequencyOptions = ["Every day", "On a cyclical schedule", "On specific days of the week", "As needed"]

    var body: some View {
        VStack(spacing: 20) {
            Text("Set a Schedule")
                .font(.title)
                .padding()

            Group {
                // Frequency Section
                Text("When Will You Take This?")
                    .font(.headline)
                Picker("Change Frequency", selection: $scheduleFrequency) {
                    ForEach(frequencyOptions, id: \.self) { option in
                        Text(option)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .padding()

                // Time Section
                Text("At What Time?")
                    .font(.headline)
                VStack(alignment: .leading) {
                    ForEach(specificTimes, id: \.self) { time in
                        HStack {
                            Text(time)
                            Spacer()
                            Text(capsuleQuantity)
                        }
                        .padding(.vertical, 2)
                    }
                    Button("Add Time") {
                        isAddingTime.toggle()
                    }
                }
                .padding()
                .sheet(isPresented: $isAddingTime) {
                    VStack {
                        DatePicker("Select Time", selection: $newTime, displayedComponents: .hourAndMinute)
                            .datePickerStyle(WheelDatePickerStyle())
                        Button("Done") {
                            specificTimes.append(formattedTime(newTime))
                            isAddingTime = false
                        }
                        .padding()
                    }
                }

                // Duration Section
                Text("Duration")
                    .font(.headline)
                HStack {
                    VStack {
                        Text("Start Date")
                        DatePicker("Start Date", selection: $startDate, displayedComponents: .date)
                            .labelsHidden()
                    }
                    VStack {
                        Text("End Date")
                        DatePicker("End Date", selection: $endDate, displayedComponents: .date)
                            .labelsHidden()
                    }
                }
                .padding()
            }

            // Next Button to Summary
            Button("Next") {
                showSummary = true
            }
            .padding()
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(10)

            // Navigation to Summary View
            .navigationDestination(isPresented: $showSummary) {
                SummaryView(medications: $medications, scheduleFrequency: scheduleFrequency, specificTimes: specificTimes, capsuleQuantity: capsuleQuantity, startDate: startDate, endDate: endDate)
            }
        }
        .padding()
    }

    // Helper function to format time
    private func formattedTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

#Preview {
    SetScheduleView(medications: .constant([])) // Preview with empty medication list
}
