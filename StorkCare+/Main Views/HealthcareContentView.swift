//
//  HealthcareContentView.swift
//  StorkCare+
//
//  Created by Bamlak T on 12/5/24.
//

import SwiftUI
import FirebaseAuth

struct HealthcareContentView: View {
    @State private var searchText: String = ""
    @Environment(\.dismiss) private var dismiss
    
    let useCases: [(title: String, icon: String, color: Color)] = [
        ("Set Provider Availability", "calendar", .green),
        ("View Scheduled Consultations", "video.fill", .purple)
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

                // Provider Features Title
                Text("Provider Features")
                    .font(.system(size: 36, weight: .bold))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)

                // Use Case List
                List(filteredUseCases, id: \.title) { useCase in
                    NavigationLink(destination: providerDestinationView(for: useCase.title)) {
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
            .navigationTitle("Provider Dashboard")
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
            dismiss()
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
    
    @ViewBuilder
    private func providerDestinationView(for useCase: String) -> some View {
        switch useCase {
        case "Set Provider Availability":
            ProviderAvailabilityView() // Navigate to the ProviderAvailabilityView
        case "View Scheduled Consultations":
            Text("Consultations View") // Create this view for viewing consultations
        default:
            Text("Unknown use case")
        }
    }
}
