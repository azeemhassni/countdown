import SwiftUI


struct AddCountdownView: View {
    @Environment(\.dismiss) private var dismiss

    @Binding var events: [CountdownEvent]
    @Binding var pinnedEventID: String

    var editingEvent: CountdownEvent?

    @State private var emoji: String = ""
    @State private var label: String = ""
    @State private var date: Date = Date()

    var body: some View {
        VStack(spacing: 16) {
            EmojiPickerTextField(emoji: $emoji)
            TextField("Label", text: $label)
            DatePicker("Date", selection: $date)

            Button(editingEvent == nil ? "Add" : "Save Changes") {
                if let editing = editingEvent,
                   let index = events.firstIndex(where: { $0.id == editing.id }) {
                    // Update existing
                    events[index] = CountdownEvent(id: editing.id, emoji: emoji, label: label, date: date, isPrivate: false)
                } else {
                    // Add new
                    let newEvent = CountdownEvent(id: UUID(), emoji: emoji, label: label, date: date)
                    events.append(newEvent)
                    pinnedEventID = newEvent.id.uuidString
                }

                if let data = try? JSONEncoder().encode(events) {
                    UserDefaults.standard.set(data, forKey: "events")
                }

                dismiss()
            }
            .buttonStyle(.borderedProminent)

            Spacer()
        }
        .padding()
        .onAppear {
            if let editing = editingEvent {
                emoji = editing.emoji
                label = editing.label
                date = editing.date
            }
        }
    }
}
