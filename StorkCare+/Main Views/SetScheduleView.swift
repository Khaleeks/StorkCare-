//
//  SetScheduleView.swift
//  StorkCare+
//
//  Created by Khaleeqa Garrett on 10/25/24.
//  Updated on 11/11/24.

import SwiftUI

struct SetScheduleView: View {
    @Binding var medications: [Medication]
    @StateObject private var viewModel = SetScheduleViewModel()

    var body: some View {
        VStack(spacing: 20) {
            Text("Set a Schedule")
                .font(.title)
                .padding()

            // Frequency Section
            Text("When Will You Take This?")
                .font(.headline)
            Picker("Change Frequency", selection: $viewModel.scheduleFrequency) {
                ForEach(viewModel.frequencyOptions, id: \.self) { option in
                    Text(option)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .padding()

            // Time Section
            Text("At What Time?")
                .font(.headline)
            VStack(alignment: .leading) {
                ForEach(viewModel.specificTimes, id: \.self) { time in
                    HStack {
                        Text(time)
                        Spacer()
                        Text(viewModel.capsuleQuantity)
                    }
                    .padding(.vertical, 2)
                }
                Button("Add Time") {
                    // Simulate adding time
                    let newTime = Date() // Replace with DatePicker input in real implementation
                    viewModel.addTime(newTime)
                }
            }
            .padding()

            // Show error message if no time is added
            if viewModel.showErrorMessage {
                Text("Please add at least one time.")
                    .foregroundColor(.red)
                    .padding(.top, 10)
            }

            // Duration Section
            Text("Duration")
                .font(.headline)
            HStack {
                VStack {
                    Text("Start Date")
                    DatePicker("Start Date", selection: $viewModel.startDate, displayedComponents: .date)
                        .labelsHidden()
                }
                VStack {
                    Text("End Date")
                    DatePicker("End Date", selection: $viewModel.endDate, displayedComponents: .date)
                        .labelsHidden()
                }
            }
            .padding()

            // Next Button
            Button("Next") {
                viewModel.onNextButtonTapped()
            }
            .padding()
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(10)

            // Navigation to Summary View
            .navigationDestination(isPresented: $viewModel.showSummary) {
                SummaryView(viewModel: SummaryViewModel(
                    medications: medications,
                    scheduleFrequency: viewModel.scheduleFrequency,
                    specificTimes: viewModel.specificTimes,
                    capsuleQuantity: viewModel.capsuleQuantity,
                    startDate: viewModel.startDate,
                    endDate: viewModel.endDate
                ))
            }
        }
        .padding()
    }
}

#Preview {
    SetScheduleView(medications: .constant([]))
}
