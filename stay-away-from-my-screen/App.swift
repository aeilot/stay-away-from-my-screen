//
//  stay_away_from_my_screenApp.swift
//  stay-away-from-my-screen
//
//  Created by Chenluo Deng on 12/28/25.
//

import SwiftUI
import AppKit

@main
struct SAFMS_App: App {
    @NSApplicationDelegateAdaptor(SAFMS_AppDelegate.self) var appDelegate
    
    var body: some Scene {
        Window("Stay Away From My Screen", id: "mainWindow") {
            ContentView()
        }
        
        MenuBarExtra("", systemImage: "exclamationmark.warninglight") {
            MenuView()
        }.menuBarExtraStyle(.menu)
        
        Settings {
            SettingsView()
        }
    }
}

class SAFMS_AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        HotKeyManager.shared.registerHotKey()
        NSApp.setActivationPolicy(.accessory)
        
        NotificationCenter.default.addObserver(
            forName: .hotKeyPressed,
            object: nil,
            queue: .main
        ) { _ in
            PopupPanel.shared.toggle()
        }
    }
}
