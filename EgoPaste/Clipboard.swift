//
//  Clipboard.swift
//  EgoPaste
//
//  Created by CliffLeopard on 2020/11/13.
//

import Carbon
import AppKit
class Clipboard {
    
    private let vinewContext: NSManagedObjectContext
    
    private let pasteboard = NSPasteboard.general
    private let timerInterval = 1.0
    private var changeCount: Int
    
    private let ignoredTypes: Set = [
        "org.nspasteboard.TransientType",
        "org.nspasteboard.ConcealedType",
        "org.nspasteboard.AutoGeneratedType"
    ]
    
    private let supportedTypes: Set = [
        NSPasteboard.PasteboardType.fileURL.rawValue,
        NSPasteboard.PasteboardType.png.rawValue,
        NSPasteboard.PasteboardType.string.rawValue,
        NSPasteboard.PasteboardType.tiff.rawValue
    ]
    
    init(_ vinewContext: NSManagedObjectContext) {
        self.vinewContext = vinewContext
        changeCount = pasteboard.changeCount
    }
    
    func startListening() {
        Timer.scheduledTimer(timeInterval: timerInterval,
                             target: self,
                             selector: #selector(checkForChangesInPasteboard),
                             userInfo: nil,
                             repeats: true)
    }
    
    @objc
    func checkForChangesInPasteboard() {
        guard pasteboard.changeCount != changeCount else {
            return
        }
        if UserDefaults.standard.ignoreEvents {
            return
        }
        
        pasteboard.pasteboardItems?.forEach({ item in
            if shouldIgnore(item.types) {
                return
            }
            
            if item.types.contains(.string) && isEmptyString(item) {
                return
            }
            
            let contents = item.types.map({ type in
                return PasteContent(type: type.rawValue, value: item.data(forType: type))
            })
            let paste = Paste(contents: contents)
            PersistenceController.shared.onNewCopy(paste)
        })
        changeCount = pasteboard.changeCount
    }
    
    private func shouldIgnore(_ types: [NSPasteboard.PasteboardType]) -> Bool {
        let ignoredTypes = self.ignoredTypes.union(UserDefaults.standard.ignoredPasteboardTypes)
        let passedTypes = Set(types.map({ $0.rawValue }))
        return passedTypes.isDisjoint(with: supportedTypes) || !passedTypes.isDisjoint(with: ignoredTypes)
    }
    
    private func isEmptyString(_ item: NSPasteboardItem) -> Bool {
        guard let string = item.string(forType: .string) else {
            return true
        }
        return string.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    func copy(_ item: Paste, removeFormatting: Bool = false) {
        pasteboard.clearContents()
        var contents = item.getContents()
        
        if removeFormatting {
            contents = contents.filter({
                NSPasteboard.PasteboardType($0.type!) == .string
            })
        }
        
        for content in contents {
            pasteboard.setData(content.value, forType: NSPasteboard.PasteboardType(content.type!))
        }
        
        if UserDefaults.standard.playSounds {
            NSSound(named: NSSound.Name("knock"))?.play()
        }
    }
    
    public func paste() {
        guard accessibilityAllowed else {
            DispatchQueue.main.async(execute: showAccessibilityWindow)
            return
        }
        
        DispatchQueue.main.async {
            let vCode = UInt16(kVK_ANSI_V)
            let source = CGEventSource(stateID: .combinedSessionState)
            source?.setLocalEventsFilterDuringSuppressionState([.permitLocalMouseEvents, .permitSystemDefinedEvents],
                                                               state: .eventSuppressionStateSuppressionInterval)
            
            let keyVDown = CGEvent(keyboardEventSource: source, virtualKey: vCode, keyDown: true)
            let keyVUp = CGEvent(keyboardEventSource: source, virtualKey: vCode, keyDown: false)
            keyVDown?.flags = .maskCommand
            keyVUp?.flags = .maskCommand
            keyVDown?.post(tap: .cgAnnotatedSessionEventTap)
            keyVUp?.post(tap: .cgAnnotatedSessionEventTap)
        }
    }
    private var accessibilityAllowed: Bool { AXIsProcessTrustedWithOptions(nil) }
    private let accessibilityURL = URL(
        string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility"
    )
    private func showAccessibilityWindow() {
        if accessibilityAlert.runModal() == NSApplication.ModalResponse.alertSecondButtonReturn {
            if let url = accessibilityURL {
                NSWorkspace.shared.open(url)
            }
        }
    }
    
    private var accessibilityAlert: NSAlert {
        let alert = NSAlert()
        alert.alertStyle = .warning
        alert.messageText = NSLocalizedString("accessibility_alert_message", comment: "")
        alert.informativeText = NSLocalizedString("accessibility_alert_comment", comment: "")
        alert.addButton(withTitle: NSLocalizedString("accessibility_alert_deny", comment: ""))
        alert.addButton(withTitle: NSLocalizedString("accessibility_alert_open", comment: ""))
        alert.icon = NSImage(named: "NSSecurity")
        return alert
    }
}
