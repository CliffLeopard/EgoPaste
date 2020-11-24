//
//  ShortcutsController.swift
//  EgoPaste
//
//  Created by CliffLeopard on 2020/11/15.
//

import KeyboardShortcuts
import SwiftUI

class ShortcutsController {
    
    static func initShortCut(){
        KeyboardShortcuts.onKeyUp(for: .quit) {
            NSApp.stop(nil)
        }
        
        KeyboardShortcuts.onKeyDown(for: .clear ) {
            PersistenceController.shared.clearAll()
        }
        
        KeyboardShortcuts.disable(.quit)
        KeyboardShortcuts.disable(.enter)
        KeyboardShortcuts.disable(.escape)
        KeyboardShortcuts.disable(.clear)
    }
    
    static func enableShortCut(){
        
        guard AppState.shared.appShow() else {
            return
        }
        
        KeyboardShortcuts.enable(.quit)
        KeyboardShortcuts.enable(.leftArrow)
        KeyboardShortcuts.enable(.rightArrow)
        KeyboardShortcuts.enable(.upArrow)
        KeyboardShortcuts.enable(.downArrow)
        KeyboardShortcuts.enable(.enter)
        KeyboardShortcuts.enable(.escape)
        KeyboardShortcuts.enable(.clear)
        KeyboardShortcuts.enable(.search)
    }
    
    static func disableShortCut(){
        guard !AppState.shared.appShow() else {
            return
        }
        KeyboardShortcuts.disable(.quit)
        KeyboardShortcuts.disable(.leftArrow)
        KeyboardShortcuts.disable(.rightArrow)
        KeyboardShortcuts.disable(.upArrow)
        KeyboardShortcuts.disable(.downArrow)
        KeyboardShortcuts.disable(.enter)
        KeyboardShortcuts.disable(.escape)
        KeyboardShortcuts.disable(.clear)
        KeyboardShortcuts.disable(.search)
    }
}
