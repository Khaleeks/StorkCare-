import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct ProviderAvailabilityView: View {
   @State private var providerData: ProviderData = ProviderData()
   @State private var selectedDate = Date()
   @State private var selectedTimeSlots: Set<String> = []
   @State private var message: String? = nil
   @State private var isLoading = false
   @State private var showingConfirmation = false
   
   let timeSlots = [
       "9:00 AM", "10:00 AM", "11:00 AM", "12:00 PM",
       "1:00 PM", "2:00 PM", "3:00 PM", "4:00 PM", "5:00 PM"
   ]
   
   var body: some View {
       GeometryReader { geometry in
           ScrollView(.vertical, showsIndicators: true) {
               VStack(spacing: 20) {
                   // Provider Info Section
                   if !providerData.occupation.isEmpty {
                       ProviderInfoCard(providerData: providerData)
                   }
                   
                   // Calendar Section
                   VStack(alignment: .leading) {
                       Text("Select Date")
                           .font(.headline)
                           .padding(.horizontal)
                       
                       DatePicker(
                           "Select Date",
                           selection: $selectedDate,
                           in: Date()...,
                           displayedComponents: [.date]
                       )
                       .datePickerStyle(.graphical)
                       .padding()
                   }
                   .background(Color.gray.opacity(0.1))
                   .cornerRadius(10)
                   .padding(.horizontal)
                   
                   // Time Slots Section
                   VStack(alignment: .leading) {
                       Text("Available Time Slots")
                           .font(.headline)
                           .padding(.bottom, 5)
                       
                       LazyVGrid(columns: [
                           GridItem(.flexible()),
                           GridItem(.flexible())
                       ], spacing: 10) {
                           ForEach(timeSlots, id: \.self) { time in
                               TimeSlotButton(
                                   time: time,
                                   isSelected: selectedTimeSlots.contains(time),
                                   action: {
                                       toggleTimeSlot(time)
                                   }
                               )
                           }
                       }
                   }
                   .padding()
                   .background(Color.gray.opacity(0.1))
                   .cornerRadius(10)
                   .padding(.horizontal)
                   
                   // Confirm Button
                   Button(action: {
                       showingConfirmation = true
                   }) {
                       Text("Confirm Selected Times")
                           .padding()
                           .frame(maxWidth: .infinity)
                           .background(selectedTimeSlots.isEmpty ? Color.gray : Color.blue)
                           .foregroundColor(.white)
                           .cornerRadius(10)
                   }
                   .disabled(selectedTimeSlots.isEmpty)
                   .padding(.horizontal)
                   
                   if let message = message {
                       Text(message)
                           .foregroundColor(message.contains("Error") ? .red : .green)
                           .padding()
                   }
                   
                   // Add padding at the bottom to ensure scrollability
                   Spacer()
                       .frame(height: 50)
               }
               .frame(minHeight: geometry.size.height)
           }
       }
       .safeAreaInset(edge: .top) {
           Color.clear.frame(height: 0)
       }
       .onAppear {
           loadProviderData()
           loadExistingAvailability()
       }
       .alert("Confirm Availability", isPresented: $showingConfirmation) {
           Button("Cancel", role: .cancel) { }
           Button("Confirm") {
               saveAvailability()
           }
       } message: {
           Text("Are you sure you want to confirm these time slots for \(formatDateForDisplay(selectedDate))?")
       }
   }
   
   private func toggleTimeSlot(_ time: String) {
       if selectedTimeSlots.contains(time) {
           selectedTimeSlots.remove(time)
       } else {
           selectedTimeSlots.insert(time)
       }
   }
   
   private func loadProviderData() {
       guard let uid = Auth.auth().currentUser?.uid else { return }
       
       let db = Firestore.firestore()
       db.collection("users").document(uid).getDocument { document, error in
           if let document = document, document.exists,
              let data = document.data() {
               DispatchQueue.main.async {
                   providerData = ProviderData(
                       name: data["name"] as? String ?? "",
                       occupation: data["occupation"] as? String ?? "",
                       placeOfWork: data["placeOfWork"] as? String ?? "",
                       gender: data["gender"] as? String ?? ""
                   )
               }
           }
       }
   }
   
   private func loadExistingAvailability() {
       guard let uid = Auth.auth().currentUser?.uid else { return }
       
       let db = Firestore.firestore()
       let dateString = formatDate(selectedDate)
       
       db.collection("users").document(uid)
           .collection("availability")
           .document(dateString)
           .getDocument { document, error in
               if let document = document,
                  document.exists,
                  let times = document.data()?["timeSlots"] as? [String] {
                   DispatchQueue.main.async {
                       selectedTimeSlots = Set(times)
                   }
               }
           }
   }
   
   private func saveAvailability() {
       guard let uid = Auth.auth().currentUser?.uid else { return }
       isLoading = true
       
       let db = Firestore.firestore()
       let dateString = formatDate(selectedDate)
       
       let availabilityData: [String: Any] = [
           "date": selectedDate,
           "timeSlots": Array(selectedTimeSlots),
           "providerId": uid,
           "providerName": providerData.name,
           "occupation": providerData.occupation,
           "placeOfWork": providerData.placeOfWork,
           "updatedAt": FieldValue.serverTimestamp()
       ]
       
       // Save directly to user document
       db.collection("users").document(uid)
           .collection("availability")
           .document(dateString)
           .setData(availabilityData) { error in
               DispatchQueue.main.async {
                   isLoading = false
                   if let error = error {
                       message = "Error: Failed to save availability"
                       print(error.localizedDescription)
                   } else {
                       message = "Availability updated successfully!"
                       selectedTimeSlots.removeAll()  // Clear selections after success
                   }
               }
           }
   }
   
   private func formatDate(_ date: Date) -> String {
       let formatter = DateFormatter()
       formatter.dateFormat = "yyyy-MM-dd"
       return formatter.string(from: date)
   }
   
   private func formatDateForDisplay(_ date: Date) -> String {
       let formatter = DateFormatter()
       formatter.dateStyle = .medium
       return formatter.string(from: date)
   }
}

// Supporting Views and Structures
struct ProviderData {
   var name: String = ""
   var occupation: String = ""
   var placeOfWork: String = ""
   var gender: String = ""
}

struct ProviderInfoCard: View {
   let providerData: ProviderData
   
   var body: some View {
       VStack(alignment: .leading, spacing: 10) {
           Text("Welcome, \(providerData.name)")
               .font(.title)
               .bold()
               .foregroundColor(.pink)
           
           Text(providerData.occupation)
               .font(.title2)
               .bold()
           
           Text(providerData.placeOfWork)
               .font(.subheadline)
               .foregroundColor(.gray)
           
           Text(providerData.gender)
               .font(.subheadline)
               .foregroundColor(.gray)
       }
       .padding()
       .frame(maxWidth: .infinity, alignment: .leading)
       .background(Color.gray.opacity(0.1))
       .cornerRadius(10)
       .padding(.horizontal)
   }
}

struct TimeSlotButton: View {
   let time: String
   let isSelected: Bool
   let action: () -> Void
   
   var body: some View {
       Button(action: action) {
           Text(time)
               .padding()
               .frame(maxWidth: .infinity)
               .background(isSelected ? Color.pink : Color.white)
               .foregroundColor(isSelected ? .white : .black)
               .cornerRadius(8)
               .overlay(
                   RoundedRectangle(cornerRadius: 8)
                       .stroke(Color.pink, lineWidth: 1)
               )
       }
   }
}

struct ProviderAvailabilityView_Previews: PreviewProvider {
   static var previews: some View {
       ProviderAvailabilityView()
   }
}
