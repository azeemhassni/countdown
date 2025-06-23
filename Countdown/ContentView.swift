import SwiftUI

struct ContentView: View {
    @AppStorage("countdownDate") var countdownDate: Double = Date().addingTimeInterval(60*60*24*30).timeIntervalSince1970
    @AppStorage("tripEmoji") var emoji: String = "✈️"

    @State private var now = Date()
    @State private var showDatePicker = false
    @State private var showEmojiPicker = false

    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var timeRemaining: (d: Int, h: Int, m: Int, s: Int) {
        let future = Date(timeIntervalSince1970: countdownDate)
        let diff = max(Int(future.timeIntervalSince(now)), 0)
        let d = diff / (60*60*24)
        let h = (diff / (60*60)) % 24
        let m = (diff / 60) % 60
        let s = diff % 60
        return (d, h, m, s)
    }

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.indigo, Color.blue]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 24) {
                // Title with emoji button
                HStack(spacing: 8) {
                    Button {
                        showEmojiPicker.toggle()
                    } label: {
                        Text(emoji)
                            .font(.system(size: 34))
                            .frame(width: 50, height: 50)
                            .cornerRadius(12)
                    }
                    .buttonStyle(.plain)
                    .background(Color.clear)
                    .popover(isPresented: $showEmojiPicker) {
                        EmojiPickerView(selectedEmoji: $emoji)
                            .frame(width: 300, height: 400)
                            .padding()
                    }

                    Text("2025 Trip")
                        .font(.system(size: 34, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .shadow(radius: 4)
                }

                Text("\(timeRemaining.d) days • \(timeRemaining.h) hrs • \(timeRemaining.m) min • \(timeRemaining.s) sec")
                    .font(.system(size: 16, weight: .semibold, design: .monospaced))
                    .monospacedDigit()
                    .foregroundColor(.white.opacity(0.9))
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 18, style: .continuous)
                            .fill(Color.white.opacity(0.15))
                            .blur(radius: 0.5)
                    )

                Button(showDatePicker ? "Done" : "Set Date") {
                    showDatePicker.toggle()
                }
                .font(.headline)

                if showDatePicker {
                    DatePicker("Countdown to:", selection: Binding(
                        get: { Date(timeIntervalSince1970: countdownDate) },
                        set: { countdownDate = $0.timeIntervalSince1970 }
                    ), displayedComponents: [.date, .hourAndMinute])
                    .datePickerStyle(.graphical)
                }
            }
            .padding()
            .frame(width: 480)
        }
        .onReceive(timer) { input in
            now = input
        }
    }
}

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
