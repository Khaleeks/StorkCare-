import SwiftUI

class SetScheduleViewModel: ObservableObject {
    @Published var scheduleFrequency: String = "Every day"
    @Published var specificTimes: [String] = []
    @Published var capsuleQuantity: String = "1 capsule"
    @Published var startDate: Date = Date()
    @Published var endDate: Date = Date()
    @Published var showSummary: Bool = false
    @Published var showErrorMessage: Bool = false
    @Published var isAddingTime: Bool = false
    @Published var newTime: Date = Date()
    
    let frequencyOptions = ["Every day", "On a cyclical schedule", "On specific days of the week", "As needed"]
    
    let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        return formatter
    }()
    
    func addTime(_ time: Date) {
        let formattedTime = timeFormatter.string(from: time)
        specificTimes.append(formattedTime)
    }
    
    func validateAndProceed() {
        if specificTimes.isEmpty {
            showErrorMessage = true
        } else {
            showSummary = true
        }
    }
    
    func formattedTime(_ date: Date) -> String {
        timeFormatter.string(from: date)
    }
}
