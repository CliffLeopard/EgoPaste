//
//  PopoverController.swift
//  EgoPaste
//
//  Created by CliffLeopard on 2020/11/15.
//

import Foundation
import SwiftUI

class PopoverController : MainContentController {
    
    let invisibleWindow = NSWindow(contentRect: NSMakeRect(0, 0, 1, 1), styleMask: .borderless, backing: .buffered, defer: false)
    var popover: NSPopover
    
    required init(_ controller: NSViewController) {
        invisibleWindow.level = .mainMenu
        invisibleWindow.collectionBehavior = [.moveToActiveSpace, .fullScreenAuxiliary]
        
        popover = NSPopover()
        popover.contentSize = NSSize(width: NSScreen.main!.frame.width, height: 400)
        popover.behavior = .transient
        popover.contentViewController = controller
    }
    
    func togglePopover(_ sender: Any?) {
        if self.popover.isShown {
            NSApp.hide(sender)
        } else {
            popUp()
        }
    }
    
    func popUp() {
        self.popover.contentSize = NSSize(width: NSScreen.main!.frame.width,height: 400)
        let minY = NSScreen.main!.frame.minY
        let minX = NSScreen.main!.frame.minX
        self.invisibleWindow.setFrameOrigin(NSPoint(x: minX , y: minY ))
        self.invisibleWindow.makeKeyAndOrderFront(self)
        NSApp.activate(ignoringOtherApps: true)
        self.popover.show(
            relativeTo: self.invisibleWindow.contentView!.bounds,
            of: self.invisibleWindow.contentView!,
            preferredEdge: .minY
        )
    }
    
    func hide(_ sender: Any?) {
        NSApp.hide(sender)
    }
}
