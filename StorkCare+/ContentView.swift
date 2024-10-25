// BabyDevelopment.swift
// StorkCare+
//
// Created by Khaleeqa Garrett on 10/23/24.
//
import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            List {
                NavigationLink(destination: TrackBabyDevelopmentView()) {
                    HStack {
                        Image(systemName: "chart.bar.fill")
                            .foregroundColor(.pink)
                        Text("Track Baby Development")
                            .foregroundColor(.pink)
                    }
                    .padding(.vertical, 10)
                }

                NavigationLink(destination: ScheduleTelehealthView()) {
                    HStack {
                        Image(systemName: "video.fill")
                            .foregroundColor(.pink)
                        Text("Schedule Telehealth Consultation")
                            .foregroundColor(.pink)
                    }
                    .padding(.vertical, 10)
                }

                NavigationLink(destination: MedicationReminderView()) {
                    HStack {
                        Image(systemName: "alarm.fill")
                            .foregroundColor(.pink)
                        Text("Medication Reminder")
                            .foregroundColor(.pink)
                    }
                    .padding(.vertical, 10)
                }
            }
            .navigationTitle("StorkCare+")
        }
    }
}

#Preview {
    ContentView()
}
