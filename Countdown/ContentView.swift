import SwiftUI

struct ContentView: View {
    @AppStorage("events") private var storedEventsData: Data = Data()
    @AppStorage("pinnedEventID") private var pinnedEventID: String = ""

    @State private var events: [CountdownEvent] = []
    @State private var now = Date()
    @State private var showAddSheet = false
    @State private var editingEvent: CountdownEvent?

    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var pinnedEvent: CountdownEvent? {
        events.first(where: { $0.id.uuidString == pinnedEventID })
    }

    var timeRemaining: (d: Int, h: Int, m: Int, s: Int) {
        guard let pinned = pinnedEvent else { return (0, 0, 0, 0) }
        let diff = max(Int(pinned.date.timeIntervalSince(now)), 0)
        return (
            d: diff / (60*60*24),
            h: (diff / (60*60)) % 24,
            m: (diff / 60) % 60,
            s: diff % 60
        )
    }

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.indigo, Color.purple]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 24) {
                if let pinned = pinnedEvent {
                    HStack(spacing: 8) {
                        Text(pinned.emoji)
                            .font(.system(size: 34))
                            .frame(width: 50, height: 50)

                        Text(pinned.label)
                            .font(.system(size: 34, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .shadow(radius: 4)
                    }

                    Text("\(timeRemaining.d) days • \(timeRemaining.h) hrs • \(timeRemaining.m) min • \(timeRemaining.s) sec")
                        .font(.system(size: 16, weight: .semibold, design: .monospaced))
                        .foregroundColor(.white.opacity(0.9))
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 18)
                                .fill(Color.white.opacity(0.15))
                                .blur(radius: 0.5)
                        )
                } else {
                    Text("No pinned countdown")
                        .foregroundColor(.white.opacity(0.7))
                }

                Button("Add New Countdown") {
                    editingEvent = nil
                    showAddSheet = true
                }
                .font(.headline)
                .sheet(isPresented: $showAddSheet) {
                    AddCountdownView(
                        events: $events,
                        pinnedEventID: $pinnedEventID,
                        editingEvent: editingEvent
                    )
                }

                List {
                    ForEach($events) { $event in
                        HStack {
                            Text(event.emoji)
                            VStack(alignment: .leading) {
                                Text(event.isPrivate ? "•••••" : event.label)
                                Text(event.date.formatted(date: .abbreviated, time: .shortened))
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                            if event.id.uuidString == pinnedEventID {
                                Text("📌")
                            }
                            Text(event.isPrivate ? "🙈" : "🐵")
                                .onTapGesture {
                                    event.isPrivate.toggle()
                                    saveEvents()
                                }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            pinnedEventID = event.id.uuidString
                            saveEvents()
                        }
                        .contextMenu {
                            Button("Edit") {
                                editingEvent = event
                                showAddSheet = true
                            }

                            Button("Delete", role: .destructive) {
                                if let index = events.firstIndex(where: { $0.id == event.id }) {
                                    events.remove(at: index)
                                    if pinnedEventID == event.id.uuidString {
                                        pinnedEventID = events.first?.id.uuidString ?? ""
                                    }
                                    saveEvents()
                                }
                            }
                        }
                    }
                    .onDelete { indexSet in
                        events.remove(atOffsets: indexSet)
                        if !events.contains(where: { $0.id.uuidString == pinnedEventID }) {
                            pinnedEventID = events.first?.id.uuidString ?? ""
                        }
                        saveEvents()
                    }
                    
                }
                .frame(height: 200)
            }
            .padding()
            .frame(width: 480)
        }
        .onAppear {
            loadEvents()
        }
        .onReceive(timer) { now = $0 }
    }

    func saveEvents() {
        if let data = try? JSONEncoder().encode(events) {
            storedEventsData = data
        }
    }

    func loadEvents() {
        if let loaded = try? JSONDecoder().decode([CountdownEvent].self, from: storedEventsData) {
            self.events = loaded
        }
    }
}
