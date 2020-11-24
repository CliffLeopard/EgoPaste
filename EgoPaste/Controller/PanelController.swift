//
//  PanelController.swift
//  EgoPaste
//
//  Created by CliffLeopard on 2020/11/15.
//

import Foundation
import SwiftUI

class PanelController: MainContentController {
    
    var popover: NSPanel
    
    required init(_ controller: NSViewController) {
        self.popover = NSPanel()
        self.popover.contentViewController = controller
        popover.styleMask = [.borderless]
        popover.level = .mainMenu
        popover.isFloatingPanel = true
        popover.collectionBehavior = [.canJoinAllSpaces]
        
        //        popover.backgroundColor = NSColor(Color.primary.opacity(0.8))
        //        popover.backgroundColor = NSColor(calibratedHue: 0.0, saturation: 0.0, brightness: 0.0, alpha: 0.2)
        popover.backgroundColor = NSColor(calibratedRed: (247.0/255.0),green:(247.0/255.0),blue:(247.0/255.0),alpha:0.9)
    }
    
    func togglePopover(_ sender: Any?) {
        if AppState.shared.appShow() {
            hide(sender)
        } else {
            popUp()
        }
    }
    
    func popUp() {
        self.popover.setContentSize(NSSize(width: NSScreen.main!.frame.width,height: 400))
        let minY = NSScreen.main!.frame.minY
        let minX = NSScreen.main!.frame.minX
        self.popover.setFrameOrigin(NSPoint(x: minX , y: minY ))
        NSApp.activate(ignoringOtherApps: true)
        self.popover.makeKeyAndOrderFront(nil)
    }
    
    func hide(_ sender: Any?) {
        NSApp.hide(sender)
    }
}

extension NSPanel {
    open override var canBecomeKey: Bool{
        return true
    }
}
