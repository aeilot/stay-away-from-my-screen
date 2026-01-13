//
//  SettingsView.swift
//  stay-away-from-my-screen
//
//  Created by Chenluo Deng on 12/28/25.
//

import SwiftUI
import AppKit
import AVFoundation

struct SettingsView: View {
    @ObservedObject var settings = SettingsManager.shared
    @State private var isRecordingHotKey = false
    @State private var currentHotKeyString = ""
    @State private var cameraPermissionStatus: AVAuthorizationStatus = .notDetermined
    
    var body: some View {
        Form {
            Section(header: Text("General").font(.headline)) {
                Toggle("Launch at Login", isOn: $settings.launchAtLogin)
            }
            
            Section(header: Text("Hot Key").font(.headline)) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Global Hot Key:")
                        .font(.subheadline)
                    
                    HotKeyRecorderView(
                        isRecording: $isRecordingHotKey,
                        hotKeyString: hotKeyDisplayString(),
                        onRecord: { keyCode, modifiers in
                            settings.hotKeyKeyCode = keyCode
                            settings.hotKeyModifiers = modifiers
                        }
                    )
                    
                    Text("Press the key combination you want to use")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Section(header: Text("Popup Appearance").font(.headline)) {
                VStack(alignment: .leading, spacing: 8) {
                    Toggle("Use Cracked Screen Effect", isOn: $settings.useCrackedScreenEffect)
                        .help("Show cracked screen animation instead of text warning")
                    
                    if !settings.useCrackedScreenEffect {
                        Text("Popup Text:")
                            .font(.subheadline)
                            .padding(.top, 8)
                        
                        TextField("Text", text: $settings.popupText)
                            .textFieldStyle(.roundedBorder)
                        
                        Text("Popup Color:")
                            .font(.subheadline)
                            .padding(.top, 8)
                        
                        ColorPicker("Background Color", selection: $settings.popupColor)
                    } else {
                        Text("Cracked screen will appear at cursor position")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .padding(.top, 4)
                    }
                }
            }
            
            Section(header: Text("Hand Tracking").font(.headline)) {
                VStack(alignment: .leading, spacing: 8) {
                    Toggle("Enable Hand Tracking", isOn: $settings.enableHandTracking)
                        .help("Automatically activate warning when fingers stretch toward screen")
                    
                    Text("Uses Vision framework to detect when you're reaching toward the screen. Works alongside the hot key.")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    if cameraPermissionStatus == .authorized {
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                            Text("Camera access granted")
                                .font(.caption)
                                .foregroundColor(.green)
                        }
                    } else {
                        Text("⚠️ Requires camera access")
                            .font(.caption)
                            .foregroundColor(.orange)
                        }
                }
            }
        }.navigationTitle("Settings")
        .formStyle(.grouped)
        .padding(20)
        .frame(width: 450, height: 550, alignment: .topLeading)
        .onAppear {
            checkCameraPermission()
        }
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
        
        let keyName = keyCodeToString(settings.hotKeyKeyCode)
        parts.append(keyName)
        
        return parts.joined()
    }
    
    private func keyCodeToString(_ keyCode: UInt16) -> String {
        let keyMap: [UInt16: String] = [
            0: "A", 1: "S", 2: "D", 3: "F", 4: "H", 5: "G", 6: "Z", 7: "X", 8: "C", 9: "V",
            11: "B", 12: "Q", 13: "W", 14: "E", 15: "R", 16: "Y", 17: "T",
            31: "O", 32: "U", 34: "I", 35: "P",
            37: "L", 38: "J", 40: "K",
            45: "N", 46: "M",
            49: "Space", 36: "Return", 51: "Delete", 53: "Escape",
            123: "←", 124: "→", 125: "↓", 126: "↑"
        ]
        return keyMap[keyCode] ?? "Key \(keyCode)"
    }
    
    private func checkCameraPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            self.cameraPermissionStatus = .authorized
            break
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    self.cameraPermissionStatus = granted ? .authorized : .denied
                }
            }
            break
        case .denied, .restricted:
            cameraPermissionStatus = .denied
        @unknown default:
            break
        }
    }
    
}

struct HotKeyRecorderView: View {
    @Binding var isRecording: Bool
    let hotKeyString: String
    let onRecord: (UInt16, UInt) -> Void
    
    var body: some View {
        Button(action: {
            isRecording = true
        }) {
            HStack {
                Text(isRecording ? "Press key combination..." : hotKeyString)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(8)
                Spacer()
            }
            .frame(height: 30)
            .background(Color(NSColor.controlBackgroundColor))
            .cornerRadius(5)
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(isRecording ? Color.blue : Color.gray.opacity(0.3), lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
        .background(HotKeyEventView(isRecording: $isRecording, onKeyDown: onRecord))
    }
}

struct HotKeyEventView: NSViewRepresentable {
    @Binding var isRecording: Bool
    let onKeyDown: (UInt16, UInt) -> Void
    
    func makeNSView(context: Context) -> NSView {
        let view = HotKeyNSView()
        view.isRecording = isRecording
        view.onKeyDown = onKeyDown
        view.onRecordingChanged = { recording in
            DispatchQueue.main.async {
                isRecording = recording
            }
        }
        return view
    }
    
    func updateNSView(_ nsView: NSView, context: Context) {
        if let view = nsView as? HotKeyNSView {
            view.isRecording = isRecording
        }
    }
    
    class HotKeyNSView: NSView {
        var isRecording = false
        var onKeyDown: ((UInt16, UInt) -> Void)?
        var onRecordingChanged: ((Bool) -> Void)?
        var localMonitor: Any?
        
        override var acceptsFirstResponder: Bool { true }
        
        override func viewDidMoveToWindow() {
            super.viewDidMoveToWindow()
            setupMonitor()
        }
        
        func setupMonitor() {
            HotKeyManager.shared.unregisterHotKey()
            
            localMonitor = NSEvent.addLocalMonitorForEvents(matching: .keyDown) { [weak self] event in
                guard let self = self, self.isRecording else { return event }
                
                let modifiers = event.modifierFlags.intersection(.deviceIndependentFlagsMask)
                let cleanModifiers = UInt(modifiers.rawValue) & UInt(NSEvent.ModifierFlags.command.rawValue | NSEvent.ModifierFlags.shift.rawValue | NSEvent.ModifierFlags.option.rawValue | NSEvent.ModifierFlags.control.rawValue)
                
                if cleanModifiers != 0 {
                    self.onKeyDown?(event.keyCode, cleanModifiers)
                    self.isRecording = false
                    self.onRecordingChanged?(false)
                    HotKeyManager.shared.registerHotKey()
                    return nil
                }
                
                return event
            }
        }
        
        deinit {
            if let monitor = localMonitor {
                NSEvent.removeMonitor(monitor)
            }
            HotKeyManager.shared.registerHotKey()
        }
    }
}

#Preview {
    SettingsView()
}
