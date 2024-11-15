import SwiftUI

struct SummaryView: View {
    @Binding var medications: [Medication]
    @ObservedObject var viewModel: SummaryViewModel
    @Environment(\.dismiss) private var dismiss // Dismiss action

    var body: some View {
        VStack(spacing: 20) {
            Text("Summary")
                .font(.title)
                .padding()

            Text("Schedule Frequency: \(viewModel.scheduleFrequency)")
                .font(.headline)
            Text("Capsule Quantity: \(viewModel.capsuleQuantity)")

            Text("At What Times?")
                .font(.headline)
            ForEach(viewModel.specificTimes, id: \.self) { time in
                Text(time)
            }

            Text("Duration: \(formattedDate(viewModel.startDate)) to \(formattedDate(viewModel.endDate))")
                .font(.headline)

            Button("Done") {
                dismiss() // This will pop back to ContentView
            }
            .padding()
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .padding()
    }

    private func formattedDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        return dateFormatter.string(from: date)
    }
}
