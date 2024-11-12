// TrackBabyDevelopmentView.swift
// StorkCare+
//
// Created by Khaleeqa Garrett on 10/23/24.
//

import SwiftUI
import FirebaseFirestore

struct TrackBabyDevelopmentView: View {
    @State private var conceptionDate: Date = Date()
    @State private var currentWeek: Int?
    @State private var developmentInfo: BabyDevelopment?
    @State private var errorMessage: String = ""
    @State private var hasEntry = false
    @State private var userInfo: testPregnantUser?
    @State private var validate = 0
    var body: some View {
        VStack(spacing: 20) {
            Text("Track Baby Development")
                .font(.largeTitle)
                .padding()
            if hasEntry {
                Text("Click the button to calculate the current week of pregnancy and view your weekly baby development updates.")
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
                    .padding()
                Button("Calculate Current Week") {
                    calculateCurrentWeek()
                }
                .buttonStyle(.borderedProminent)
            }
                else {
                    if validate == 2 {
                        Text("Please enter a valid conception date.")
                                .foregroundColor(.red)
                    }
                    Text("Please enter your conception date on the calendar and then click the button to update your start date.")
                        .font(.subheadline)
                        .multilineTextAlignment(.center)
                        .padding()
                    DatePicker("Select Conception Date", selection: $conceptionDate, in: ...Date(), displayedComponents: .date)
                        .datePickerStyle(GraphicalDatePickerStyle())
                        .padding()
                    Button("Update Pregnancy Start Date") {
                        userInfo = testPregnantUser(date: conceptionDate)
                        validateConceptionDate()
                        if validate == 1 {
                            hasEntry = true
                        }
                    }
                    .padding()
                    .buttonStyle(.borderedProminent)
                }
                if let week = currentWeek, let info = developmentInfo {
                    Text("Current Week: \(week)")
                        .font(.headline)
                    Text("Size: \(info.size)")
                    Text("Development: \(info.description)")
                        .multilineTextAlignment(.center)
                        .padding()
                } else if currentWeek != nil {
                    // Handle out of bounds or negative week
                    Text("Please return to your health profile to update a valid conception date.")
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
    private func validateConceptionDate() {
        let calendar = Calendar.current
        let currentDate = Date()
        let components = calendar.dateComponents([.weekOfYear], from: conceptionDate, to: currentDate)
        var currentex: Int
        currentex = components.weekOfYear!
        if currentex > 0 && currentex <= 40 {
            validate = 1
        } else {
            validate = 2
        }
    }
    }
    #Preview {
        TrackBabyDevelopmentView()
    }
