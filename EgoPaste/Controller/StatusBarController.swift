//
//  StatusBarController.swift
//  EgoPaste
//
//  Created by CliffLeopard on 2020/11/15.
//

import Foundation
import SwiftUI

class StatusBarController: NSObject,NSMenuDelegate {
    var statusBarItem: NSStatusItem!
    var statusBarMenu: NSMenu!
    
    override init() {
        super.init()
        initStatusBarMenu()
        initStatusBarItem()
    }
    
    // 初始化右击弹出菜单
    func initStatusBarMenu() {
        self.statusBarMenu = NSMenu(title: "CEgoPaste")
        
        statusBarMenu.delegate = self
        statusBarMenu.addItem(
            withTitle: NSLocalizedString("clear_all", comment: "Clear History"),
            action: #selector(AppDelegate.doClear),
            keyEquivalent: "h")
        
        statusBarMenu.addItem(
            withTitle: NSLocalizedString("preferences", comment: "Preferences"),
            action: #selector(AppDelegate.showPreference),
            keyEquivalent: ",")
        
        statusBarMenu.addItem(
            withTitle: NSLocalizedString("about", comment: "About"),
            action: #selector(AppDelegate.showAbout),
            keyEquivalent: "m")
        
        statusBarMenu.addItem(
            withTitle: NSLocalizedString("quit", comment: "Quit"),
            action: #selector(AppDelegate.doExit),
            keyEquivalent: "q")
    }
    
    // 初始化状态栏Button
    func initStatusBarItem() {
        self.statusBarItem = NSStatusBar.system.statusItem(withLength: CGFloat(NSStatusItem.variableLength))
        if let button = self.statusBarItem.button {
            button.image = NSImage(named: "Icon")
            button.action = #selector(AppDelegate.statusBarButtonClicked(_:))
            button.sendAction(on: [.leftMouseUp, .rightMouseUp])
        }
    }
    
    @objc func showMenu(_ sender: Any?) {
        statusBarItem.menu = statusBarMenu
        statusBarItem.button?.performClick(sender)
    }
    
    @objc func menuDidClose(_ menu: NSMenu) {
        statusBarItem.menu = nil
    }
}
