import SwiftUI

struct SummaryView: View {
    @Binding var medications: [Medication]
    var scheduleFrequency: String
    var specificTimes: [String]
    var capsuleQuantity: String
    var startDate: Date
    var endDate: Date

    @State private var showingContentView = false // State to control navigation to ContentView
    @State private var showConfirmation = false // State to show confirmation message
    @Environment(\.presentationMode) var presentationMode // To handle navigation

    var body: some View {
        VStack(spacing: 20) {
            Text("Summary of Medication")
                .font(.title)
                .bold()
                .padding()
                .frame(maxWidth: .infinity) // Keeps it within screen bounds
                .multilineTextAlignment(.center) // Center text within the frame
                .lineLimit(1) // Keeps it on one line
            Text("Frequency: ").bold() + Text("\(scheduleFrequency)")
            Text("Times and Quantities:").bold()
            ForEach(specificTimes, id: \.self) { time in
                Text("\(time): ").bold() + Text("\(capsuleQuantity)")
            }
            Text("Start Date: ").bold() + Text(formattedDate(startDate))
            Text("End Date: ").bold() + Text(formattedDate(endDate))

            // Done Button to navigate back to ContentView
            Button("Done") {
                showConfirmation = true // Show confirmation message
            }
            .padding()
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(10)
            .alert(isPresented: $showConfirmation) {
                Alert(
                    title: Text("Confirmation"),
                    message: Text("You will be reminded 10 minutes before your scheduled time."),
                    primaryButton: .default(Text("OK"), action: {
                        // After confirmation, navigate back to ContentView
                        showingContentView = true
                    }),
                    secondaryButton: .cancel(Text("Cancel"))
                )
            }
        }
        .padding()
        .navigationDestination(isPresented: $showingContentView) {
            ContentView() // Navigate to ContentView
        }
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

// Previews
#Preview {
    SummaryView(medications: .constant([]), scheduleFrequency: "Every day", specificTimes: ["5 AM", "12 PM"], capsuleQuantity: "1 capsule", startDate: Date(), endDate: Date())
}
