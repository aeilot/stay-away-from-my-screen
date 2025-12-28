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
        WindowGroup {
            ContentView()
        }
    }
}

class SAFMS_AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        // Set up any necessary configurations here
    }
}
