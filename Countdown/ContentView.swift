import SwiftUI

struct ContentView: View {
    @AppStorage("countdownDate") var countdownDate: Double = Date().addingTimeInterval(60*60*24*30).timeIntervalSince1970 // Default: 30 days from now
    @State private var now = Date()
    @State private var showDatePicker = false

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
        VStack(spacing: 16) {
            LinearGradient(
                            gradient: Gradient(colors: [Color.indigo, Color.blue]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                        .ignoresSafeArea()

                        // Glass-style card
                        VStack(spacing: 24) {
                            // Title
                            Text("✈️  2025 Trip")
                                .font(.system(size: 34, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                                .shadow(radius: 4)

                            // Countdown string
                            Text("\(timeRemaining.d) days • \(timeRemaining.h) hrs • \(timeRemaining.m) min • \(timeRemaining.s) sec")
                                .font(.system(size: 16, weight: .semibold, design: .monospaced))
                                .monospacedDigit()
                                .foregroundColor(.white.opacity(0.9))
                                .padding(.horizontal, 24)
                                .padding(.vertical, 12)
                                .background(
                                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                                        .fill(Color.white.opacity(0.15))
                                        .blur(radius: 0.5)        // subtle “frosted” look
                                )
                        }
                        .padding()

            Button(showDatePicker ? "Done" : "Set Date") {
                showDatePicker.toggle()
            }

            if showDatePicker {
                DatePicker("Countdown to:", selection: Binding(
                    get: { Date(timeIntervalSince1970: countdownDate) },
                    set: { countdownDate = $0.timeIntervalSince1970 }
                ), displayedComponents: [.date, .hourAndMinute])
                .datePickerStyle(.graphical)
            }
        }
        .padding()
        .onReceive(timer) { input in
            now = input
        }
        .frame(width: 280)
    }
}
