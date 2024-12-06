import SwiftUI
import FirebaseAuth

struct HealthcareContentView: View {
    @State private var searchText: String = ""
    @Binding var isAuthenticated: Bool
    
    let useCases: [(title: String, icon: String, color: Color)] = [
        ("Set Provider Availability", "calendar", .green),
        ("View Scheduled Consultations", "video.fill", .purple)
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
        .navigationBarBackButtonHidden(true)
        .navigationTitle("Provider Dashboard")
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
    private func providerDestinationView(for useCase: String) -> some View {
        switch useCase {
        case "Set Provider Availability":
            ProviderAvailabilityView()
        case "View Scheduled Consultations":
<<<<<<< Updated upstream
            ProviderAppointmentsListView()
=======
            Text("Consultations View")
>>>>>>> Stashed changes
        default:
            Text("Unknown use case")
        }
    }
}
