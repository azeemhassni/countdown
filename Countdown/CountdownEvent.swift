import Foundation


struct CountdownEvent: Identifiable, Codable, Equatable {
    let id: UUID
var emoji: String
    var label: String
    var date: Date

    init(id: UUID = UUID(), emoji: String, label: String, date: Date) {
        self.id = id
        self.emoji = emoji
        self.label = label
        self.date = date
    }
}
