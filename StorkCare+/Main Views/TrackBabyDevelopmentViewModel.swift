


import SwiftUI
import Combine
import FirebaseFirestore

class TrackBabyDevelopmentViewModel: ObservableObject {
    @Published var conceptionDate: Date = Date()
    @Published var currentWeek: Int?
    @Published var developmentInfo: BabyDevelopment?
    @Published var errorMessage: String = ""
    @Published var hasEntry = false
    @Published var validate = 0
    private var userInfo: testPregnantUser?

    // Properties for trimester and progress
    @Published var weeksLeft: Int?
    @Published var trimesterProgress: CGFloat = 0.0
    @Published var currentTrimester: String = ""

    private let totalWeeks = 40 // Standard pregnancy length

    func updateConceptionDate() {
        userInfo = testPregnantUser(date: conceptionDate)
        validateConceptionDate()
        if validate == 1 {
            hasEntry = true
        }
    }

    func calculateCurrentWeek() {
        let calendar = Calendar.current
        let currentDate = Date()
        let components = calendar.dateComponents([.weekOfYear], from: conceptionDate, to: currentDate)
        currentWeek = components.weekOfYear
        
        if let week = currentWeek, week > 0 && week <= 40 {
            developmentInfo = babyDevelopmentData[week - 1]
            calculateProgressAndTrimester(for: week)
        } else {
            developmentInfo = nil // Reset if the week is out of bounds
        }
    }

    private func validateConceptionDate() {
        let calendar = Calendar.current
        let currentDate = Date()
        let components = calendar.dateComponents([.weekOfYear], from: conceptionDate, to: currentDate)
        let currentex = components.weekOfYear ?? 0
        validate = (currentex > 0 && currentex <= 40) ? 1 : 2
    }
    
    // Function to calculate trimester and progress
    private func calculateProgressAndTrimester(for week: Int) {
        weeksLeft = totalWeeks - week

        // Calculate trimester progress (dividing pregnancy into 3 trimesters)
        trimesterProgress = CGFloat(week) / CGFloat(totalWeeks)
        
        // Determine which trimester the current week falls into
        if week <= 12 {
            currentTrimester = "First Trimester"
        } else if week <= 24 {
            currentTrimester = "Second Trimester"
        } else {
            currentTrimester = "Third Trimester"
        }
    }
}
