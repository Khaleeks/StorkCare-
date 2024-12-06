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
                    .accessibilityIdentifier("BabyInTitle") // Accessibility Identifier
            } else {
                Text("Track Baby Development")
                    .font(.title)
                    .bold()
                    .padding()
                    .accessibilityIdentifier("TrackBabyDevelopmentTitle") // Accessibility Identifier
            }
            // Only show the button and the instructions if the progress bar is not shown yet
            if !viewModel.hasEntry || viewModel.currentWeek == nil {
                // Error message for invalid conception date
                if viewModel.validate == 2 {
                    Text("Please enter a valid conception date.")
                        .foregroundColor(.red)
                        .font(.subheadline)
                        .padding()
                        .accessibilityIdentifier("ErrorMessage") // Accessibility Identifier
                }
                
                // Instructions and button to calculate current week
                if !viewModel.hasEntry {
                    Text("Please enter your conception date on the calendar and then click the button to update your start date.")
                        .font(.subheadline)
                        .multilineTextAlignment(.center)
                        .padding()
                        .accessibilityIdentifier("ConceptionDateInstructions") // Accessibility Identifier
                    DatePicker("Select Conception Date", selection: $viewModel.conceptionDate, in: ...Date(), displayedComponents: .date)
                        .datePickerStyle(GraphicalDatePickerStyle())
                        .padding()
                        .accessibilityIdentifier("ConceptionDatePicker") // Accessibility Identifier
                    Button("Update Pregnancy Start Date") {
                        viewModel.updateConceptionDate()
                    }
                    .padding()
                    .buttonStyle(.borderedProminent)
                    .accessibilityIdentifier("UpdateStartDateButton") // Accessibility Identifier
                } else {
                    // Button to calculate current week
                    Text("Click the button to calculate the current week of pregnancy and view your weekly baby development updates.")
                        .font(.subheadline)
                        .multilineTextAlignment(.center)
                        .padding()
                        .accessibilityIdentifier("CalculateWeekInstructions") // Accessibility Identifier
                    Button("Calculate Current Week") {
                        viewModel.calculateCurrentWeek()
                    }
                    .buttonStyle(.borderedProminent)
                    .accessibilityIdentifier("CalculateCurrentWeekButton") // Accessibility Identifier
                }
            }
            
            // Display current week and trimester progress if the progress bar is shown
            if let currentWeek = viewModel.currentWeek, let weeksLeft = viewModel.weeksLeft {
                Text("Current Week: \(currentWeek)")
                    .font(.headline)
                    .accessibilityIdentifier("CurrentWeekLabel") // Accessibility Identifier
                
                // Display current trimester
                Text("Current Trimester: \(viewModel.currentTrimester)")
                    .font(.headline)
                    .accessibilityIdentifier("CurrentTrimesterLabel") // Accessibility Identifier
                
                // Display remaining weeks
                Text("Weeks Left: \(weeksLeft)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(.bottom, 8)
                    .accessibilityIdentifier("WeeksLeftLabel") // Accessibility Identifier
                
                // Progress bar with trimester sections
                VStack(alignment: .leading) {
                    // Progress bar showing trimester progress
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.gray.opacity(0.2))
                            .frame(height: 20)
                            .accessibilityIdentifier("ProgressBarBackground") // Accessibility Identifier
                        
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.blue)
                            .frame(width: viewModel.trimesterProgress * UIScreen.main.bounds.width * 0.9, height: 20) // Progress bar width
                            .accessibilityIdentifier("ProgressBar") // Accessibility Identifier
                    }
                    .padding(.bottom, 8)
                    
                    // Labels for each trimester
                    HStack {
                        Text("First Trimester")
                            .font(.caption)
                            .frame(maxWidth: .infinity)
                            .accessibilityIdentifier("FirstTrimesterLabel") // Accessibility Identifier
                        Text("Second Trimester")
                            .font(.caption)
                            .frame(maxWidth: .infinity)
                            .accessibilityIdentifier("SecondTrimesterLabel") // Accessibility Identifier
                        Text("Third Trimester")
                            .font(.caption)
                            .frame(maxWidth: .infinity)
                            .accessibilityIdentifier("ThirdTrimesterLabel") // Accessibility Identifier
                    }
                }
                .padding()
            }
            
            // Display development info for the current week
            if let _ = viewModel.currentWeek, let info = viewModel.developmentInfo {
                Text("Size: \(info.size)")
                    .accessibilityIdentifier("DevelopmentSizeLabel") // Accessibility Identifier
                Text("Development: \(info.description)")
                    .multilineTextAlignment(.center)
                    .padding()
                    .accessibilityIdentifier("DevelopmentInfoLabel") // Accessibility Identifier
            } else if viewModel.currentWeek != nil {
                Text("Please return to your health profile to update a valid conception date.")
                    .foregroundColor(.red)
                    .accessibilityIdentifier("ConceptionDateErrorMessage") // Accessibility Identifier
            }
        }
        .padding()
        .onAppear{
            viewModel.loadConceptionData()
        }
    }
}
