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
    
    @Published var popupText: String {
        didSet {
            UserDefaults.standard.set(popupText, forKey: "popupText")
        }
    }
    
    @Published var popupColor: Color {
        didSet {
            if let colorData = try? NSKeyedArchiver.archivedData(withRootObject: NSColor(popupColor), requiringSecureCoding: false) {
                UserDefaults.standard.set(colorData, forKey: "popupColor")
            }
        }
    }
    
    private init() {
        self.launchAtLogin = UserDefaults.standard.bool(forKey: "launchAtLogin")
        self.hotKeyModifiers = UInt(UserDefaults.standard.integer(forKey: "hotKeyModifiers"))
        self.hotKeyKeyCode = UInt16(UserDefaults.standard.integer(forKey: "hotKeyKeyCode"))
        
        // Load popup text
        self.popupText = UserDefaults.standard.string(forKey: "popupText") ?? "STAY AWAY FROM MY SCREEN"
        
        // Load popup color
        if let colorData = UserDefaults.standard.data(forKey: "popupColor"),
           let nsColor = try? NSKeyedUnarchiver.unarchivedObject(ofClass: NSColor.self, from: colorData) {
            self.popupColor = Color(nsColor)
        } else {
            self.popupColor = Color.red
        }
        
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
