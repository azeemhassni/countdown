import SwiftUI

@main
struct CountdownApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        // No default window
        Settings {
            EmptyView()
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem!
    var popover = NSPopover()
    var timer: Timer?

    func applicationDidFinishLaunching(_ notification: Notification) {
        let contentView = ContentView()
        popover.contentSize = NSSize(width: 300, height: 180)
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
        let countdownDate = UserDefaults.standard.double(forKey: "countdownDate")
        let now = Date()
        let future = Date(timeIntervalSince1970: countdownDate)
        let diff = max(Int(future.timeIntervalSince(now)), 0)
        let d = diff / (60*60*24)
        let h = (diff / (60*60)) % 24
        let m = (diff / 60) % 60
        if let button = statusItem.button {
            button.title = "\(d)d \(h)h \(m)m"
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
