//
//  EmojiPickerTextField.swift
//  Countdown
//
//  Created by Azeem Hassni on 26/06/2025.
//


import SwiftUI
import AppKit

struct EmojiPickerTextField: NSViewRepresentable {
    @Binding var emoji: String

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeNSView(context: Context) -> NSTextField {
        let textField = NSTextField()
        textField.isEditable = true
        textField.isBordered = true
        textField.font = NSFont.systemFont(ofSize: 40)
        textField.alignment = .center
        textField.focusRingType = .none
        textField.backgroundColor = NSColor.clear
        textField.delegate = context.coordinator

        // Add click gesture recognizer
        let clickGesture = NSClickGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.didClickTextField))
        textField.addGestureRecognizer(clickGesture)

        return textField
    }

    func updateNSView(_ nsView: NSTextField, context: Context) {
        nsView.stringValue = emoji
    }

    class Coordinator: NSObject, NSTextFieldDelegate {
        var parent: EmojiPickerTextField

        init(_ parent: EmojiPickerTextField) {
            self.parent = parent
        }

        func controlTextDidChange(_ obj: Notification) {
            if let textField = obj.object as? NSTextField {
                let text = textField.stringValue
                if let last = text.last, last.isEmoji {
                    parent.emoji = String(last)
                }
            }
        }

        @objc func didClickTextField() {
            NSApp.orderFrontCharacterPalette(nil)
        }
    }
}


extension Character {
    var isEmoji: Bool {
        unicodeScalars.contains { $0.properties.isEmoji && ($0.value > 0x238C || $0.value == 0x00A9 || $0.value == 0x00AE) }
    }
}
