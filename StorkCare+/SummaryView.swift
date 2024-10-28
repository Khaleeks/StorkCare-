//
//  SummaryView.swift
//  StorkCare+
//
//  Created by Khaleeqa Garrett on 10/25/24.
//

import SwiftUI

struct SummaryView: View {
    @Binding var medications: [Medication]
    var scheduleFrequency: String
    var specificTimes: [String] // Updated to accept list of times
    var capsuleQuantity: String
    var startDate: Date
    var endDate: Date

    var body: some View {
        VStack(spacing: 20) {
            Text("Summary of Your Medication")
                .font(.title)
                .padding()

            Text("Frequency: \(scheduleFrequency)")
            Text("Times and Quantities:")
            ForEach(specificTimes, id: \.self) { time in
                Text("\(time): \(capsuleQuantity)")
            }
            Text("Start Date: \(formattedDate(startDate))")
            Text("End Date: \(formattedDate(endDate))")

            // Done Button
            Button("Done") {
                // Logic to navigate back to StorkCare+ main page
            }
            .padding()
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .padding()
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

#Preview {
    SummaryView(medications: .constant([]), scheduleFrequency: "Every day", specificTimes: ["5 AM", "12 PM"], capsuleQuantity: "1 capsule", startDate: Date(), endDate: Date())
}
