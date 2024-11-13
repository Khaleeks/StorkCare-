// TrackBabyDevelopmentView.swift
// StorkCare+
//
// Created by Khaleeqa Garrett on 10/23/24.
//

import SwiftUI
import FirebaseFirestore

struct TrackBabyDevelopmentView: View {
    @StateObject private var viewModel = TrackBabyDevelopmentViewModel()
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Track Baby Development")
                .font(.largeTitle)
                .padding()
            
            if viewModel.hasEntry {
                Text("Click the button to calculate the current week of pregnancy and view your weekly baby development updates.")
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
                    .padding()
                Button("Calculate Current Week") {
                    viewModel.calculateCurrentWeek()
                }
                .buttonStyle(.borderedProminent)
            } else {
                if viewModel.validate == 2 {
                    Text("Please enter a valid conception date.")
                        .foregroundColor(.red)
                }
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
            }
            
            if let week = viewModel.currentWeek, let info = viewModel.developmentInfo {
                Text("Current Week: \(week)")
                    .font(.headline)
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
