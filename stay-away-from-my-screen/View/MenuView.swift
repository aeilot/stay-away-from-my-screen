//
//  MenuView.swift
//  stay-away-from-my-screen
//
//  Created by Chenluo Deng on 12/28/25.
//

import SwiftUI

struct MenuView: View {
    @Environment(\.openWindow) private var openWindow
    @Environment(\.openSettings) private var openSettings
    
    var body: some View {
        Button("Open Main Window") {
            NSApplication.shared.activate(ignoringOtherApps: true)
            openWindow(id: "mainWindow")
        }
        
        Button("Settings...") {
            NSApplication.shared.activate(ignoringOtherApps: true)
            openSettings()
        }
        
        Divider()
        
        Button("Quit") {
            NSApplication.shared.terminate(nil)
        }
    }
}
