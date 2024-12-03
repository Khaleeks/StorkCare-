import SwiftUI

struct SummaryView: View {
    @Binding var medications: [Medication]
    let scheduleFrequency: String
    let specificTimes: [String]
    let capsuleQuantity: String
    let startDate: Date
    let endDate: Date
    @ObservedObject var viewModel: SummaryViewModel
    @Binding var path: [String] // Use shared NavigationPath to reset navigation

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
                path.removeLast(path.count) // Clear the navigation stack
                path.append("ContentView") // Navigate directly to ContentView
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
