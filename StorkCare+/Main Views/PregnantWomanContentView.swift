import SwiftUI
import FirebaseAuth



struct PregnantWomanContentView: View {
    @State private var searchText: String = ""
    @Binding var isAuthenticated: Bool
    @State private var medications: [Medication] = []
    
    let useCases: [(title: String, icon: String, color: Color)] = [
        ("Track Baby Development", "chart.bar.fill", .pink),
        ("Schedule Telehealth Consultation", "video.fill", .purple),
        ("Medication Reminder", "alarm.fill", .blue)
    ]
    
    var filteredUseCases: [(title: String, icon: String, color: Color)] {
        searchText.isEmpty ? useCases : useCases.filter { $0.title.lowercased().contains(searchText.lowercased()) }
    }
    
    var body: some View {
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
            ScrollView {
                VStack(spacing: 15) {
                    ForEach(filteredUseCases, id: \.title) { useCase in
                        NavigationLink(destination: destinationView(for: useCase.title)) {
                            HStack {
                                Image(systemName: useCase.icon)
                                    .foregroundColor(useCase.color)
                                    .font(.title2)
                                Text(useCase.title)
                                    .foregroundColor(.primary)
                                    .font(.body)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.gray)
                            }
                            .padding()
                            .background(Color(.systemBackground))
                            .cornerRadius(10)
                            .shadow(radius: 2)
                        }
                    }
                }
                .padding()
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationTitle("StorkCare+")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Sign Out") {
                    signOut()
                }
                .foregroundColor(.red)
            }
        }
    }
    
    private func signOut() {
        do {
            try Auth.auth().signOut()
            isAuthenticated = false
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
