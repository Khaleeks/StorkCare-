import SwiftUI

struct TrackBabyDevelopmentView: View {
    @StateObject private var viewModel = TrackBabyDevelopmentViewModel()

    var body: some View {
        VStack(spacing: 20) {
            // Conditionally change the title based on whether the progress bar is displayed
            if viewModel.hasEntry, let _ = viewModel.currentWeek {
                Text("Your Baby Is In...")
                    .font(.title)
                    .bold()
                    .padding(.top)
            } else {
                Text("Track Baby Development")
                    .font(.title)
                    .bold()
                    .padding()
            }

            // Only show the button and the instructions if the progress bar is not shown yet
            if !viewModel.hasEntry || viewModel.currentWeek == nil {
                // Error message for invalid conception date
                if viewModel.validate == 2 {
                    Text("Please enter a valid conception date.")
                        .foregroundColor(.red)
                        .font(.subheadline)
                        .padding()
                }
                
                // Instructions and button to calculate current week
                if !viewModel.hasEntry {
                    Text("Please enter your conception date on the calendar and then click the button to update your start date.")
                        .font(.subheadline)
                        .multilineTextAlignment(.center)
                        .padding()
                    DatePicker("Select Conception Date", selection: $viewModel.conceptionDate, in: ...Date(), displayedComponents: .date)
                        .datePickerStyle(GraphicalDatePickerStyle())
                        .padding()
                    Button("Update Pregnancy Start Date") {
                        viewModel.updateConceptionDate()
                    }
                    .padding()
                    .buttonStyle(.borderedProminent)
                } else {
                    // Button to calculate current week
                    Text("Click the button to calculate the current week of pregnancy and view your weekly baby development updates.")
                        .font(.subheadline)
                        .multilineTextAlignment(.center)
                        .padding()
                    Button("Calculate Current Week") {
                        viewModel.calculateCurrentWeek()
                    }
                    .buttonStyle(.borderedProminent)
                }
            }

            // Display current week and trimester progress if the progress bar is shown
            if let currentWeek = viewModel.currentWeek, let weeksLeft = viewModel.weeksLeft {
                Text("Current Week: \(currentWeek)")
                    .font(.headline)
                
                // Display current trimester
                Text("Current Trimester: \(viewModel.currentTrimester)")
                    .font(.headline)
                   

                // Display remaining weeks
                Text("Weeks Left: \(weeksLeft)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(.bottom, 8)
                
               
                // Progress bar with trimester sections
                VStack(alignment: .leading) {
                    // Progress bar showing trimester progress
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.gray.opacity(0.2))
                            .frame(height: 20)

                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.blue)
                            .frame(width: viewModel.trimesterProgress * UIScreen.main.bounds.width * 0.9, height: 20) // Progress bar width
                    }
                    .padding(.bottom, 8)

                    // Labels for each trimester
                    HStack {
                        Text("First Trimester")
                            .font(.caption)
                            .frame(maxWidth: .infinity)
                        Text("Second Trimester")
                            .font(.caption)
                            .frame(maxWidth: .infinity)
                        Text("Third Trimester")
                            .font(.caption)
                            .frame(maxWidth: .infinity)
                    }
                }
                .padding()
            }

            // Display development info for the current week
            if let _ = viewModel.currentWeek, let info = viewModel.developmentInfo {
                Text("Size: \(info.size)")
                Text("Development: \(info.description)")
                    .multilineTextAlignment(.center)
                    .padding()
            } else if viewModel.currentWeek != nil {
                Text("Please return to your health profile to update a valid conception date.")
                    .foregroundColor(.red)
            }
        }
        .padding()
    }
}

#Preview {
    TrackBabyDevelopmentView()
}
