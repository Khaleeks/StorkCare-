import Foundation
import SwiftData

@Model
final class AppUser {
    @Attribute(.unique) var id: UUID // Unique identifier
    var name: String
    var email: String
    var password: String // Add password property

    init(name: String, email: String, password: String) {
        self.id = UUID()
        self.name = name
        self.email = email
        self.password = password
    }
}
