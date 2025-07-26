import Foundation


struct CountdownEvent: Identifiable, Codable, Equatable {
    let id: UUID
var emoji: String
    var label: String
    var date: Date
    var isPrivate: Bool

    init(id: UUID = UUID(), emoji: String, label: String, date: Date, isPrivate: Bool = false) {
        self.id = id
        self.emoji = emoji
        self.label = label
        self.date = date
        self.isPrivate = isPrivate
    }
}
