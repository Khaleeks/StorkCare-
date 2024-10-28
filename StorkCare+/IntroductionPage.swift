// BabyDevelopment.swift
// StorkCare+
//
// Created by Khaleeqa Garrett on 10/23/24.
//
import SwiftUI

struct IntroductionPage: View {
    var body: some View {
        VStack(spacing: 40) {
            Spacer() // Slightly pushes the welcome text down
                .frame(height: 20) // Adjust this value for finer control

            Text("Welcome to StorkCare+")
                .font(.largeTitle)
                .bold()
                .foregroundColor(.pink)

            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    Image(systemName: "video.fill")
                        .foregroundColor(.pink)
                        .imageScale(.large) // Makes the icon slightly larger
                    VStack(alignment: .leading) {
                        Text("Schedule Telehealth Consultation")
                            .font(.headline)
                            .bold()
                            .foregroundColor(.pink)
                        Text("Conveniently schedule telehealth consultations with your choosen healthcare provider.")
                            .font(.subheadline)
                            .foregroundColor(.black)
                    }
                }
                
                HStack {
                    Image(systemName: "chart.bar.fill")
                        .foregroundColor(.pink)
                        .imageScale(.large) // Makes the icon slightly larger
                    VStack(alignment: .leading) {
                        Text("Track Baby Development")
                            .font(.headline)
                            .bold()
                            .foregroundColor(.pink)
                        Text("Monitor your baby's growth week by week.")
                            .font(.subheadline)
                            .foregroundColor(.black)
                    }
                }

                HStack {
                    Image(systemName: "alarm.fill")
                        .foregroundColor(.pink)
                        .imageScale(.large) // Makes the icon slightly larger
                    VStack(alignment: .leading) {
                        Text("Medication Reminder")
                            .font(.headline)
                            .bold()
                            .foregroundColor(.black)
                        Text("Set reminders to take medications on time.")
                            .font(.subheadline)
                            .foregroundColor(.black)
                    }
                }
            }
            .padding(.horizontal)

            Spacer()

            NavigationLink(destination: HealthDataEntryPage()) {
                Text("Continue")
                    .bold()
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.pink)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
        }
        .padding()
    }
}

#Preview {
    IntroductionPage()
}
