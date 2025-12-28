//
//  PopupPanel.swift
//  stay-away-from-my-screen
//
//  Created by Chenluo Deng on 12/28/25.
//

import AppKit
import SwiftUI

class PopupPanel: NSPanel {
    static let shared = PopupPanel()
    
    private init() {
        super.init(
            contentRect: NSRect(x: 0, y: 0, width: 400, height: 300),
            styleMask: [.borderless, .nonactivatingPanel],
            backing: .buffered,
            defer: false
        )
        
        self.level = .floating
        self.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
        self.isFloatingPanel = true
        self.hidesOnDeactivate = false
        self.backgroundColor = .clear
        self.hasShadow = true
        self.isMovableByWindowBackground = true
        
        let popupView = PopupContentView()
        self.contentView = NSHostingView(rootView: popupView)
    }
    
    func toggle() {
        if self.isVisible {
            self.orderOut(nil)
        } else {
            showAtMouseLocation()
        }
    }
    
    func showAtMouseLocation() {
        let mouseLocation = NSEvent.mouseLocation
        
        let screenFrame = NSScreen.main?.visibleFrame ?? NSRect.zero
        var origin = mouseLocation
        
        // Adjust position to keep panel on screen
        if origin.x + self.frame.width > screenFrame.maxX {
            origin.x = screenFrame.maxX - self.frame.width
        }
        if origin.y - self.frame.height < screenFrame.minY {
            origin.y = screenFrame.minY + self.frame.height
        }
        
        self.setFrameOrigin(origin)
        self.makeKeyAndOrderFront(nil)
        
        // Enable key events
        self.makeFirstResponder(self.contentView)
    }
    
    override var canBecomeKey: Bool {
        return true
    }
    
    override var canBecomeMain: Bool {
        return true
    }
}

struct PopupContentView: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("Stay Away From My Screen")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Panel opened at mouse location")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            HStack(spacing: 15) {
                Button("Action 1") {
                    print("Action 1 triggered")
                }
                .buttonStyle(.borderedProminent)
                
                Button("Action 2") {
                    print("Action 2 triggered")
                }
                .buttonStyle(.bordered)
                
                Button("Close") {
                    PopupPanel.shared.close()
                }
                .buttonStyle(.bordered)
            }
            
            Spacer()
        }
        .padding(20)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(NSColor.windowBackgroundColor))
                .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 5)
        )
        .padding(1)
    }
}
