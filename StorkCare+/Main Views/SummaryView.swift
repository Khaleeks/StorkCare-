//
//  SetScheduleViewModel.swift
//  StorkCare+
//
//  Created by Khaleeqa Garrett on 12/11/24.
//

import SwiftUI

struct SummaryView: View {
    @StateObject var viewModel: SummaryViewModel

    var body: some View {
        VStack(spacing: 20) {
            Text("Summary")
                .font(.title)
                .padding()

            // Medication Schedule Section
            Text("Schedule Frequency: \(viewModel.scheduleFrequency)")
                .font(.headline)
            Text("Capsule Quantity: \(viewModel.capsuleQuantity)")

            // Specific Times Section
            Text("At What Times?")
                .font(.headline)
            ForEach(viewModel.specificTimes, id: \.self) { time in
                Text(time)
            }

            // Duration Section
            Text("Duration: \(formattedDate(viewModel.startDate)) to \(formattedDate(viewModel.endDate))")
                .font(.headline)

            // Done Button
            Button("Done") {
                // Logic to dismiss or navigate away from the summary screen
            }
            .padding()
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .padding()
    }

    // Helper function to format the dates
    private func formattedDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        return dateFormatter.string(from: date)
    }
}

#Preview {
    SummaryView(viewModel: SummaryViewModel(
        medications: [],
        scheduleFrequency: "Once a day",
        specificTimes: ["8:00 AM", "8:00 PM"],
        capsuleQuantity: "1 capsule",
        startDate: Date(),
        endDate: Date()
    ))
}
