//
//  PregnantWomanContentView.swift
//  StorkCare+
//
//  Created by Bamlak T on 12/5/24.
//
import SwiftUI
import FirebaseAuth

struct PregnantWomanContentView: View {
    @State private var searchText: String = ""
    @State private var medications: [Medication] = []
    @State private var isAuthenticated = true
    @Environment(\.dismiss) private var dismiss
    
    let useCases: [(title: String, icon: String, color: Color)] = [
        ("Track Baby Development", "chart.bar.fill", .pink),
        ("Schedule Telehealth Consultation", "video.fill", .purple),
        ("Medication Reminder", "alarm.fill", .blue)
    ]
    
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
                    .font(.system(size: 36, weight: .bold))
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
                .listStyle(PlainListStyle())
            }
            .navigationTitle("StorkCare+")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: signOut) {
                        Text("Sign Out")
                            .foregroundColor(.red)
                    }
                }
            }
        }
    }
    
    private func signOut() {
        do {
            try Auth.auth().signOut()
            isAuthenticated = false
            // Reset navigation to root view
            dismiss()
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
    
    @ViewBuilder
    private func destinationView(for useCase: String) -> some View {
        switch useCase {
        case "Track Baby Development":
            TrackBabyDevelopmentView()
        case "Schedule Telehealth Consultation":
            ScheduleTelehealthView()
        case "Medication Reminder":
            SetupMedicationView(medications: $medications)
        default:
            Text("Unknown use case")
        }
    }
}

#Preview {
    PregnantWomanContentView()
}
