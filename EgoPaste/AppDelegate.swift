//
//  AppDelegate.swift
//  EgoPaste
//
//  Created by CliffLeopard on 2020/11/10.
//

import Foundation
import SwiftUI
import KeyboardShortcuts

class AppDelegate: NSObject, NSApplicationDelegate {
    
    var mainController: MainContentController!
    var statusBarController: StatusBarController!
    
    func applicationWillFinishLaunching(_ notification: Notification) {
        PersistenceController.shared.initData()
    }
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        // ContentView()
        // DataBaseTestView().frame(minWidth: NSScreen.main?.frame.width, minHeight: 400, alignment: .topLeading)
        let contentView = ContentView()
            .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
        let controller = NSHostingController(rootView: contentView)
        //        self.mainController = PopoverController(controller)
        self.mainController = PanelController(controller)
        self.statusBarController = StatusBarController()
        KeyboardShortcuts.onKeyUp(for: .showPop) {
            self.mainController.togglePopover(nil)
        }
        ShortcutsController.initShortCut()
    }
    
    func applicationWillBecomeActive(_ notification: Notification) {
        AppState.shared.updateShowState(true)
        ShortcutsController.enableShortCut()
    }
    
    func applicationWillResignActive(_ notification: Notification) {
        AppState.shared.updateShowState(false)
        ShortcutsController.disableShortCut()
    }
    
    @objc func statusBarButtonClicked(_ sender: Any?) {
        let event = NSApp.currentEvent!
        if event.type ==  NSEvent.EventType.rightMouseUp {
            self.statusBarController.showMenu(sender)
        } else if event.type ==  NSEvent.EventType.leftMouseUp {
            mainController.togglePopover(sender)
        }
    }
    
    @objc func doClear(_ sender: NSMenuItem) {
        PersistenceController.shared.clearAll()
    }
    
    @objc func showPreference(_ sender: NSMenuItem) {
        print("showSettings")
    }
    
    @objc func showAbout(_ sender: NSMenuItem) {
        print("showAbout")
    }
    
    @objc func doExit(_ sender: AnyObject?) {
        NSApp.stop(sender)
    }
}
