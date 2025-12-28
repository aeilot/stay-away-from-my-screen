//
//  MenuView.swift
//  stay-away-from-my-screen
//
//  Created by Chenluo Deng on 12/28/25.
//

import SwiftUI

struct MenuView: View {
    @Environment(\.openWindow) private var openWindow
    
    var body: some View {
        Text("Menu View")
    }
    
    func buttonAction(){
        NSApplication.shared.activate(ignoringOtherApps: true)
        openWindow(id: "mainWindow")
    }
}
