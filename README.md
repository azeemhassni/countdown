# ⏳ Countdown App

A macOS SwiftUI app for managing multiple countdown events with support for pinning, privacy toggles, and inline editing.

---

## ✨ Features

### 🧷 Pinned Countdown
- One event can be **pinned** and displayed prominently at the top.
- Shows remaining time in **days, hours, minutes, and seconds**.
- Automatically updates every second with a live timer.

### 🗂️ Event List
- Displays all saved countdown events in a scrollable list.
- Each row includes:
  - Emoji
  - Label (can be hidden if marked private)
  - Target date/time
  - 📌 icon if the event is pinned
  - 🙈 / 🐵 icon for privacy toggle

### ➕ Add/Edit Countdown
- Tap "Add New Countdown" to open a sheet for creating a new event.
- Tap "Edit" from the context menu to update an existing event.

### 🗑️ Delete Support
- Right-click or control-click an event to reveal the **Delete** option.
- If the pinned event is deleted, the next available one is pinned automatically.

### 🔐 Privacy Toggle
- Each event has a **private** flag.
- When enabled, the label is replaced with `•••••`.
- Toggle using the 🙈 / 🐵 icon next to each event.

### 💾 Data Persistence
- Events are saved in `UserDefaults` using `@AppStorage`.
- Encoding/decoding done with `Codable`.

### ⏱️ Live Timer
- Uses `Timer.publish` to update countdown every second.
- Keeps the pinned countdown accurate in real time.

---

## 🛠️ Built With

- `SwiftUI`
- `@AppStorage` (UserDefaults)
- `Codable`
- `Timer.publish`
- `ContextMenu` and `Sheets`

---

## 📂 Structure

- `ContentView.swift`: Main screen with pinned countdown and event list.
- `AddCountdownView.swift`: Sheet for adding/editing events.
- `CountdownEvent.swift`: Model struct for individual events.

---

Let me know if you want usage tips, screenshots, or build instructions.
