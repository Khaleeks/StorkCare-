import SwiftUI

struct SummaryView: View {
    @Binding var medications: [Medication] // This ensures medications is passed as a binding
    @ObservedObject var viewModel: SummaryViewModel // Use viewModel for business logic and other data handling

    var body: some View {
        VStack(spacing: 20) {
            Text("Summary")
                .font(.title)
                .padding()
                .accessibilityIdentifier("summaryTitle") // Identifier for the title

            // Medication Schedule Section
            Text("Schedule Frequency: \(viewModel.scheduleFrequency)")
                .font(.headline)
                .accessibilityIdentifier("scheduleFrequencyText") // Identifier for schedule frequency
            Text("Capsule Quantity: \(viewModel.capsuleQuantity)")
                .accessibilityIdentifier("capsuleQuantityText") // Identifier for capsule quantity

            // Specific Times Section
            Text("At What Times?")
                .font(.headline)
                .accessibilityIdentifier("specificTimesTitle") // Identifier for specific times title
            ForEach(viewModel.specificTimes, id: \.self) { time in
                Text(time)
                    .accessibilityIdentifier("specificTimeText_\(time)") // Unique identifier for each time
            }

            // Duration Section
            Text("Duration: \(formattedDate(viewModel.startDate)) to \(formattedDate(viewModel.endDate))")
                .font(.headline)
                .accessibilityIdentifier("durationText") // Identifier for duration

            // Done Button
            Button("Done") {
                // Logic to dismiss or navigate away from the summary screen
            }
            .padding()
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(10)
            .accessibilityIdentifier("doneButton") // Identifier for Done button
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
