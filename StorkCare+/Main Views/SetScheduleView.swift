import SwiftUI

struct SetScheduleView: View {
    @Binding var medications: [Medication]
    @ObservedObject var viewModel: SetScheduleViewModel

    @State private var navigateToSummary = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("Set a Schedule")
                    .font(.title)
                    .padding()

                Group {
                    Text("When Will You Take This?")
                        .font(.headline)
                    Picker("Change Frequency", selection: $viewModel.scheduleFrequency) {
                        ForEach(viewModel.frequencyOptions, id: \.self) { option in
                            Text(option)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .padding()

                    Text("At What Time?")
                        .font(.headline)
                    VStack(alignment: .leading) {
                        ForEach(viewModel.specificTimes, id: \.self) { time in
                            HStack {
                                Text(time)
                                Spacer()
                                Text(viewModel.capsuleQuantity)
                            }
                            .padding(.vertical, 2)
                        }
                        Button("Add Time") {
                            viewModel.isAddingTime.toggle()
                        }
                    }
                    .padding()
                    .sheet(isPresented: $viewModel.isAddingTime) {
                        VStack {
                            DatePicker("Select Time", selection: $viewModel.newTime, displayedComponents: .hourAndMinute)
                                .datePickerStyle(WheelDatePickerStyle())
                            Button("Done") {
                                viewModel.addTime(viewModel.newTime)
                                viewModel.isAddingTime = false
                            }
                            .padding()
                        }
                    }

                    Text("Duration")
                        .font(.headline)
                    HStack {
                        VStack {
                            Text("Start Date")
                            DatePicker("Start Date", selection: $viewModel.startDate, displayedComponents: .date)
                                .labelsHidden()
                        }
                        VStack {
                            Text("End Date")
                            DatePicker("End Date", selection: $viewModel.endDate, displayedComponents: .date)
                                .labelsHidden()
                        }
                    }
                    .padding()
                }

                Button("Next") {
                    viewModel.onNextButtonTapped()
                    navigateToSummary = true
                }
                .padding()
                .background(viewModel.showErrorMessage ? Color.red : Color.green)
                .foregroundColor(.white)
                .cornerRadius(10)
                .disabled(viewModel.specificTimes.isEmpty)

                if viewModel.showErrorMessage {
                    Text("Please make sure all fields are filled correctly.")
                        .foregroundColor(.red)
                        .padding()
                }

                NavigationLink(
                    destination: SummaryView(
                        medications: $medications,
                        viewModel: SummaryViewModel(
                            medications: $medications,
                            scheduleFrequency: viewModel.scheduleFrequency,
                            specificTimes: viewModel.specificTimes,
                            capsuleQuantity: viewModel.capsuleQuantity,
                            startDate: viewModel.startDate,
                            endDate: viewModel.endDate
                        )
                    ),
                    isActive: $navigateToSummary
                ) {
                    EmptyView()
                }
            }
            .padding()
        }
    }
}
