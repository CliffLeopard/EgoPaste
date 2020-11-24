//
//  EgoPasteApp.swift
//  EgoPaste
//
//  Created by CliffLeopard on 2020/11/10.
//

import SwiftUI
@main
struct EgoPasteApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self)  var appDelegate
    @Environment(\.scenePhase) private var scenePhase
    
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        Settings{
            SettingsView()
        }
    }
}
