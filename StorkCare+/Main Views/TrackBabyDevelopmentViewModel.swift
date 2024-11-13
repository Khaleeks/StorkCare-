//
//  TrackBabyDevelopmentViewModel.swift
//  StorkCare+
//
//  Created by Khaleeqa Garrett on 11/13/24.
//


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
}
