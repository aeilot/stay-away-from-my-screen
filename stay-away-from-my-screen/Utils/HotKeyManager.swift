//
//  HotKeyManager.swift
//  stay-away-from-my-screen
//
//  Created by Chenluo Deng on 12/28/25.
//

import AppKit
import HotKey

class HotKeyManager {
    static let shared = HotKeyManager()
    
    private var hotKey: HotKey?
    
    private init() {
        setupNotificationObserver()
    }
    
    private func setupNotificationObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateHotKey),
            name: .hotKeyChanged,
            object: nil
        )
    }
    
    func registerHotKey() {
        unregisterHotKey()
        
        let settings = SettingsManager.shared
        let modifiers = settings.hotKeyModifiers
        let keyCode = settings.hotKeyKeyCode
        
        var hotKeyModifiers: NSEvent.ModifierFlags = []
        
        if modifiers & UInt(NSEvent.ModifierFlags.command.rawValue) != 0 {
            hotKeyModifiers.insert(.command)
        }
        if modifiers & UInt(NSEvent.ModifierFlags.shift.rawValue) != 0 {
            hotKeyModifiers.insert(.shift)
        }
        if modifiers & UInt(NSEvent.ModifierFlags.option.rawValue) != 0 {
            hotKeyModifiers.insert(.option)
        }
        if modifiers & UInt(NSEvent.ModifierFlags.control.rawValue) != 0 {
            hotKeyModifiers.insert(.control)
        }
        
        guard let key = Key(carbonKeyCode: UInt32(keyCode)) else { return }
        
        hotKey = HotKey(key: key, modifiers: hotKeyModifiers)
        hotKey?.keyDownHandler = {
            NotificationCenter.default.post(name: .hotKeyPressed, object: nil)
        }
    }
    
    func unregisterHotKey() {
        hotKey = nil
    }
    
    @objc private func updateHotKey() {
        registerHotKey()
    }
}

extension Notification.Name {
    static let hotKeyPressed = Notification.Name("hotKeyPressed")
}
