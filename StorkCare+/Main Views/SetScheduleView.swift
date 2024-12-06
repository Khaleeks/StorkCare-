import SwiftUI

struct SetScheduleView: View {
    @Binding var medications: [Medication]
    @ObservedObject var viewModel: SetScheduleViewModel
    @State private var scheduleFrequency: String = "Every day"
    @State private var specificTimes: [String] = []
    @State private var capsuleQuantity: String = "1 capsule"
    @State private var startDate: Date = Date()
    @State private var endDate: Date = Date()
    @State private var showSummary = false
    @State private var isAddingTime = false
    @State private var newTime = Date()
    @State private var path: [String] = [] // Add navigation path state
    
    let frequencyOptions = ["Every day", "On a cyclical schedule", "On specific days of the week", "As needed"]
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Set a Schedule")
                .font(.title)
                .padding()
            
            Group {
                // Frequency Section
                Text("When Will You Take This?")
                    .font(.headline)
                Picker("Change Frequency", selection: $scheduleFrequency) {
                    ForEach(frequencyOptions, id: \.self) { option in
                        Text(option)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .padding()
                
                // Time Section
                Text("At What Time?")
                    .font(.headline)
                VStack(alignment: .leading) {
                    ForEach(specificTimes, id: \.self) { time in
                        HStack {
                            Text(time)
                            Spacer()
                            Text(capsuleQuantity)
                        }
                        .padding(.vertical, 2)
                    }
                    Button("Add Time") {
                        isAddingTime.toggle()
                    }
                }
                .padding()
                
                // Duration Section
                Text("Duration")
                    .font(.headline)
                HStack {
                    VStack {
                        Text("Start Date")
                        DatePicker("Start Date", selection: $startDate, displayedComponents: .date)
                            .labelsHidden()
                    }
                    VStack {
                        Text("End Date")
                        DatePicker("End Date", selection: $endDate, displayedComponents: .date)
                            .labelsHidden()
                    }
                }
                .padding()
            }
            
            // Next Button to Summary
            Button("Next") {
                showSummary = true
            }
            .padding()
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .padding()
        .navigationDestination(isPresented: $showSummary) {
            let summaryViewModel = SummaryViewModel(
                medications: $medications,
                scheduleFrequency: scheduleFrequency,
                specificTimes: specificTimes,
                capsuleQuantity: capsuleQuantity,
                startDate: startDate,
                endDate: endDate
            )
            
            SummaryView(
                medications: $medications,
                scheduleFrequency: scheduleFrequency,
                specificTimes: specificTimes,
                capsuleQuantity: capsuleQuantity,
                startDate: startDate,
                endDate: endDate,
                viewModel: summaryViewModel,
                path: $path
            )
        }
        .sheet(isPresented: $isAddingTime) {
            VStack {
                DatePicker("Select Time", selection: $newTime, displayedComponents: .hourAndMinute)
                    .datePickerStyle(WheelDatePickerStyle())
                Button("Done") {
                    specificTimes.append(formattedTime(newTime))
                    isAddingTime = false
                }
                .padding()
            }
        }
    }
    
    private func formattedTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
