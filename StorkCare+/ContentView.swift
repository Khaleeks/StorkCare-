//
// ContentView.swift
// StorkCare+
//
// Created by Khaleeqa Garrett on 10/23/24.
//

import SwiftUI

struct ContentView: View {
    @State private var searchText: String = "" // State variable for the search bar
    
    // Define the use cases with their names, icons, and colors
    let useCases: [(title: String, icon: String, color: Color)] = [
        ("Track Baby Development", "chart.bar.fill", .pink),
        ("Schedule Telehealth Consultation", "video.fill", .purple),
        ("Medication Reminder", "alarm.fill", .blue)
    ]
    
    // Filter use cases based on search text
    var filteredUseCases: [(title: String, icon: String, color: Color)] {
        searchText.isEmpty
            ? useCases
            : useCases.filter { $0.title.lowercased().contains(searchText.lowercased()) }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                // Search Bar
                HStack {
                    TextField("Search...", text: $searchText)
                        .padding(10)
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .padding(.horizontal)

                    Button(action: { /* Optional search action */ }) {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.pink)
                            .padding()
                    }
                }
                .font(.body)

                // Health Categories Title
                Text("Health Categories")
                    .font(.system(size: 36, weight: .bold)) // Adjusted font size for clarity
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)

                // Use Case List
                List(filteredUseCases, id: \.title) { useCase in
                    NavigationLink(destination: destinationView(for: useCase.title)) {
                        HStack {
                            Image(systemName: useCase.icon)
                                .foregroundColor(useCase.color)
                            Text(useCase.title)
                                .foregroundColor(.black)
                                .font(.body)
                        }
                        .padding(.vertical, 10)
                    }
                }
                .listStyle(PlainListStyle()) // Cleaner list style
            }
            .navigationTitle("StorkCare+")
            .navigationBarTitleDisplayMode(.inline)
            .font(.system(size: 24, weight: .bold))
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
        }
    }

    // ViewBuilder for navigating to appropriate views based on selection
    @ViewBuilder
    private func destinationView(for useCase: String) -> some View {
        switch useCase {
        case "Track Baby Development":
            TrackBabyDevelopmentView()
        case "Schedule Telehealth Consultation":
            ScheduleTelehealthView()
        case "Medication Reminder":
            SetupMedicationView(medications: .constant([]))
        default:
            Text("Unknown use case")
        }
    }
}

// Previews
#Preview {
    ContentView()
}
