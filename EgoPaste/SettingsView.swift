//
//  SettingsView.swift
//  EgoPaste
//
//  Created by CliffLeopard on 2020/11/11.
//

import SwiftUI
import KeyboardShortcuts
import LoginServiceKit

struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    private enum Tabs: Hashable {
        case general, shortcut
    }
    
    var body: some View {
        TabView {
            GeneralSettingsView()
                .tabItem {
                    Label(NSLocalizedString("preferences_general", comment: "General"), systemImage: "gear")
                }
                .tag(Tabs.general)
            PreferencesView()
                .tabItem {
                    Label(NSLocalizedString("preferences_shortcut", comment: "Shortcuts"), systemImage: "keyboard")
                }
                .tag(Tabs.shortcut)
        }
        .padding(20)
        .frame(width: 375, height: 150)
        .font(.headline)
    }
}

struct GeneralSettingsView: View {
    @AppStorage("loginLaunch") private var loginLaunch = false
    @AppStorage("fileSize") private var fileSize = 12.0
    
    let fileCount = NSLocalizedString("preferences_file_size", comment: "File Size")
 
    var body: some View {
        Form {
            Toggle(NSLocalizedString("preferences_login_launch", comment: "LoginLaunch"), isOn: $loginLaunch)
                .onReceive([self.loginLaunch].publisher.first()) { (value) in
                    if(self.loginLaunch){
                        LoginServiceKit.addLoginItems()
                    }else{
                        LoginServiceKit.removeLoginItems()
                    }
                }
            Slider(value: $fileSize, in: 1...200) {
                Text("\(fileCount) : \(fileSize, specifier: "%.0f")")
            }
        }
        .padding(20)
        .frame(width: 350, height: 100)
    }
}

struct PreferencesView: View {
    var body: some View {
        HStack {
            Text(NSLocalizedString("preferences_shortcut", comment: "Shortcuts")+":")
            KeyboardShortcuts.Recorder(for: .showPop)
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
