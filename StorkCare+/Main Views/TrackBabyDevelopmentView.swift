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
    
    let uid: String // Pass the authenticated user's UID
    
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
                fetchDate(documentID: uid)
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
    
    private func fetchDate(documentID: String){
        let db = Firestore.firestore()
        let docRef = db.collection("PregnantUsers").document(documentID)
        docRef.getDocument { document, error in
            if let error = error as NSError?{
                self.errorMessage = "Error getting document: \(error.localizedDescription)"
            }
            else {
                if let document = document {
                    _ = document.documentID
                    let data = document.data()
                    _ = data?["pregnancyStartDate"] as? Date??
                }
            }
        }
    }
}
#Preview {
    TrackBabyDevelopmentView(uid: "sampleUID")
}
