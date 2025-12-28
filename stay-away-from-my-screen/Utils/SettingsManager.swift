//
//  SettingsManager.swift
//  stay-away-from-my-screen
//
//  Created by Chenluo Deng on 12/28/25.
//

import SwiftUI
import ServiceManagement
import Combine

class SettingsManager: ObservableObject {
    static let shared = SettingsManager()
    
    @Published var launchAtLogin: Bool {
        didSet {
            UserDefaults.standard.set(launchAtLogin, forKey: "launchAtLogin")
            updateLoginItem()
        }
    }
    
    @Published var hotKeyModifiers: UInt {
        didSet {
            UserDefaults.standard.set(hotKeyModifiers, forKey: "hotKeyModifiers")
            NotificationCenter.default.post(name: .hotKeyChanged, object: nil)
        }
    }
    
    @Published var hotKeyKeyCode: UInt16 {
        didSet {
            UserDefaults.standard.set(hotKeyKeyCode, forKey: "hotKeyKeyCode")
            NotificationCenter.default.post(name: .hotKeyChanged, object: nil)
        }
    }
    
    private init() {
        self.launchAtLogin = UserDefaults.standard.bool(forKey: "launchAtLogin")
        self.hotKeyModifiers = UInt(UserDefaults.standard.integer(forKey: "hotKeyModifiers"))
        self.hotKeyKeyCode = UInt16(UserDefaults.standard.integer(forKey: "hotKeyKeyCode"))
        
        // Set default hot key: Command + Shift + S (keyCode 1)
        if hotKeyModifiers == 0 {
            hotKeyModifiers = UInt(NSEvent.ModifierFlags.command.rawValue | NSEvent.ModifierFlags.shift.rawValue)
            hotKeyKeyCode = 1
        }
    }
    
    private func updateLoginItem() {
        if #available(macOS 13.0, *) {
            if launchAtLogin {
                try? SMAppService.mainApp.register()
            } else {
                try? SMAppService.mainApp.unregister()
            }
        }
    }
}

extension Notification.Name {
    static let hotKeyChanged = Notification.Name("hotKeyChanged")
}
