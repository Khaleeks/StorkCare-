// TrackBabyDevelopmentView.swift
// StorkCare+
//
// Created by Khaleeqa Garrett on 10/23/24.
//

import SwiftUI

struct TrackBabyDevelopmentView: View {
    @State private var conceptionDate: Date = Date()
    @State private var currentWeek: Int?
    @State private var developmentInfo: BabyDevelopment?

    var body: some View {
        VStack(spacing: 20) {
            Text("Track Baby Development")
                .font(.largeTitle)
                .padding()

            Text("Enter your conception date on the calendar and then click the button to calculate the current week of pregnancy.")
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .padding()

            DatePicker("Select Conception Date", selection: $conceptionDate, in: ...Date(), displayedComponents: .date)
                .datePickerStyle(GraphicalDatePickerStyle())
                .padding()

            Button("Calculate Current Week") {
                calculateCurrentWeek()
            }
            .padding()
            .buttonStyle(.borderedProminent)

            if let week = currentWeek, let info = developmentInfo {
                Text("Current Week: \(week)")
                    .font(.headline)
                Text("Size: \(info.size)")
                Text("Development: \(info.description)")
                    .multilineTextAlignment(.center)
                    .padding()
            } else if currentWeek != nil {
                // Handle out of bounds or negative week
                Text("Please enter a valid conception date.")
                    .foregroundColor(.red)
            }
        }
        .padding()
    }

    private func calculateCurrentWeek() {
        let calendar = Calendar.current
        let currentDate = Date()
        let components = calendar.dateComponents([.weekOfYear], from: conceptionDate, to: currentDate)
        currentWeek = components.weekOfYear

        if let week = currentWeek, week > 0 && week <= 40 {
            developmentInfo = babyDevelopmentData[week - 1]
        } else {
            developmentInfo = nil // Reset if the week is out of bounds
        }
    }
}

#Preview {
    TrackBabyDevelopmentView()
}
