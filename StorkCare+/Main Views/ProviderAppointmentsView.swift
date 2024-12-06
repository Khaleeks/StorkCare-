
import SwiftUI
import FirebaseFirestore
import FirebaseAuth
import Foundation

struct ProviderAppointmentsListView: View {
    @StateObject private var viewModel = AppointmentsViewModel()
    
    var body: some View {
        List(viewModel.appointments) { appointment in
            VStack(alignment: .leading, spacing: 8) {
                Text("Patient: \(appointment.name)")
                    .font(.headline)
                Text(appointment.date.formatted())
                Text("Time: \(appointment.timeSlot)")
            }
            .padding(.vertical, 4)
        }
        .navigationTitle("My Appointments")
        .onAppear {
            viewModel.loadAppointments()
        }
    }
}

class AppointmentsViewModel: ObservableObject {
    @Published var appointments = [UserAppointment]()
    private let db = Firestore.firestore()
    
    func loadAppointments() {
        guard let providerId = Auth.auth().currentUser?.uid else { return }
        
        db.collection("appointments")
            .whereField("providerId", isEqualTo: providerId)
            .addSnapshotListener { [weak self] snapshot, error in
                guard let documents = snapshot?.documents else { return }
                
                self?.appointments = documents.compactMap { doc -> UserAppointment? in
                    let data = doc.data()
                    let userId = data["userID"] as? String ?? ""
                    
                    return UserAppointment(
                        id: doc.documentID,
                        name: userId,
                        date: (data["date"] as? Timestamp)?.dateValue() ?? Date(),
                        timeSlot: data["timeSlot"] as? String ?? ""
                    )
                }
            }
    }
}

struct UserAppointment: Identifiable {
    let id: String
    let name: String
    let date: Date
    let timeSlot: String
}
