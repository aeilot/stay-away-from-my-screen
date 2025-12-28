//
//  ContentView.swift
//  stay-away-from-my-screen
//
//  Created by Chenluo Deng on 12/28/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @ObservedObject var settings = SettingsManager.shared
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Stay Away From My Screen")
                .font(.title)
                .padding()
            
            Text("Press \(hotKeyDisplayString()) to activate")
                .font(.subheadline)
                .foregroundColor(.secondary)
                    }
        .frame(minWidth: 200, minHeight: 150)
    }
    
    private func hotKeyDisplayString() -> String {
        var parts: [String] = []
        
        if settings.hotKeyModifiers & UInt(NSEvent.ModifierFlags.control.rawValue) != 0 {
            parts.append("⌃")
        }
        if settings.hotKeyModifiers & UInt(NSEvent.ModifierFlags.option.rawValue) != 0 {
            parts.append("⌥")
        }
        if settings.hotKeyModifiers & UInt(NSEvent.ModifierFlags.shift.rawValue) != 0 {
            parts.append("⇧")
        }
        if settings.hotKeyModifiers & UInt(NSEvent.ModifierFlags.command.rawValue) != 0 {
            parts.append("⌘")
        }
        
        let keyMap: [UInt16: String] = [
            0: "A", 1: "S", 2: "D", 3: "F", 4: "H", 5: "G", 6: "Z", 7: "X", 8: "C", 9: "V",
            11: "B", 12: "Q", 13: "W", 14: "E", 15: "R", 16: "Y", 17: "T",
            31: "O", 32: "U", 34: "I", 35: "P",
            37: "L", 38: "J", 40: "K",
            45: "N", 46: "M",
            49: "Space"
        ]
        let keyName = keyMap[settings.hotKeyKeyCode] ?? "Unknown"
        parts.append(keyName)
        
        return parts.joined()
    }
}

#Preview {
    ContentView()
}
