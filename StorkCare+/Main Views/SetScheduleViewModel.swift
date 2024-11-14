import SwiftUI

class SetScheduleViewModel: ObservableObject {
    @Published var scheduleFrequency: String = ""
    @Published var specificTimes: [String] = []
    @Published var capsuleQuantity: String = "1 capsule"
    @Published var startDate: Date = Date()
    @Published var endDate: Date = Date()
    @Published var showSummary: Bool = false
    @Published var showErrorMessage: Bool = false
    @Published var isAddingTime: Bool = false
    @Published var newTime: Date = Date() // Assuming newTime is a Date object for new time selection
    
    var frequencyOptions: [String] = ["Once a day", "Twice a day", "Every other day"]
    
    // Initialize DateFormatter
    let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a" // Customize the format as per your requirement
        return formatter
    }()

    func addTime(_ time: Date) {
        // Format the time and append to specificTimes
        let formattedTime = timeFormatter.string(from: time)
        specificTimes.append(formattedTime)
    }

    func onNextButtonTapped() {
        // Example: if no time is added, show error
        if specificTimes.isEmpty {
            showErrorMessage = true
        } else {
            showSummary = true
        }
    }
}
