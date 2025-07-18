import SwiftUI
import Foundation

@main
struct CountdownApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        Settings {
            EmptyView() // No default settings UI
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem!
    var popover = NSPopover()
    var timer: Timer?

    func applicationDidFinishLaunching(_ notification: Notification) {
        let contentView = ContentView()
        popover.contentSize = NSSize(width: 300, height: 480)
        popover.contentViewController = NSHostingController(rootView: contentView)
        popover.behavior = .transient
        

        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        if let button = statusItem.button {
            button.title = "⏳"
            button.action = #selector(togglePopover(_:))
        }

        updateMenuBarTitle()

        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            self.updateMenuBarTitle()
        }
    }

    func updateMenuBarTitle() {
        guard let data = UserDefaults.standard.data(forKey: "events"),
              let events = try? JSONDecoder().decode([CountdownEvent].self, from: data),
              let pinnedIDString = UserDefaults.standard.string(forKey: "pinnedEventID"),
              let pinnedID = UUID(uuidString: pinnedIDString),
              let pinnedEvent = events.first(where: { $0.id == pinnedID })
                  else {
                    if let button = statusItem.button {
                        button.title = "⏳"
                  }
            return
        }

        let now = Date()
        let diff = max(Int(pinnedEvent.date.timeIntervalSince(now)), 0)
        let d = diff / (60*60*24)
        let h = (diff / (60*60)) % 24
        let m = (diff / 60) % 60

        if let button = statusItem.button {
            button.title = "\(pinnedEvent.emoji) \(d)d \(h)h \(m)m"
        }
    }

    @objc func togglePopover(_ sender: AnyObject?) {
        if let button = statusItem.button {
            if popover.isShown {
                popover.performClose(sender)
            } else {
                popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
                popover.contentViewController?.view.window?.makeKey()
            }
        }
    }
}
