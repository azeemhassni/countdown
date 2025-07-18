import Foundation

extension Character {
    var isEmoji: Bool {
        unicodeScalars.contains { $0.properties.isEmoji && ($0.value > 0x238C || $0.value == 0x00A9 || $0.value == 0x00AE) }
    }
}
