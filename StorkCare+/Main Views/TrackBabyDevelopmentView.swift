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
    @State private var testUser = testPregnantUser(year: 2024, month: 04, day: 03)
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Track Baby Development")
                .font(.largeTitle)
                .padding()
            
            Text("Click the button to calculate the current week of pregnancy and view your weekly baby development updates.")
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .padding()
            
            
            Button("Calculate Current Week") {
                conceptionDate = testUser.getDate()!
                calculateCurrentWeek()
            }
            .padding()
            .buttonStyle(.borderedProminent)
            
            if let week = currentWeek, let info = developmentInfo {
                Text("Current Week: \(week)")
                    .font(.headline)
                Text("Size: \(info.size)")
                Text("Development: \(info.description)")
                    .multilineTextAlignment(.center)
                    .padding()
            } else if currentWeek != nil {
                // Handle out of bounds or negative week
                Text("Please return to the health profile and enter a valid conception date.")
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
}
#Preview {
    TrackBabyDevelopmentView()
}
