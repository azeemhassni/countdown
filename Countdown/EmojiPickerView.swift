import SwiftUI

struct EmojiPickerView: View {
    @Binding var selectedEmoji: String

    private let emojis = [
        // Travel & Vacation
        "✈️", "🚗", "🛳️", "🏖️", "⛷️", "🎢", "🏝️", "🌋", "🗽",

        // Weddings & Romance
        "💍", "💒", "❤️", "💘", "💐", "💑",

        // Work & Meetings
        "💼", "🧑‍💻", "📅", "📈", "📊", "🧑‍🏫",

        // Events & Celebrations
        "🎉", "🎊", "🎓", "🎂", "🍾", "🥂", "🎁", "🪩",

        // Misc
        "🧘", "🏕️", "🧳", "🏟️", "🎬"
    ]

    let columns = [
        GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()),
        GridItem(.flexible()), GridItem(.flexible())
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Pick an Emoji")
                .font(.headline)
                .foregroundColor(.white)

            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(emojis, id: \.self) { emoji in
                    Button {
                        selectedEmoji = emoji
                    } label: {
                        Text(emoji)
                            .font(.system(size: 28))
                            .frame(width: 30, height: 30)
                            .background(Color.white.opacity(0.15))
                            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .padding()
        .shadow(radius: 10)
    }
}
