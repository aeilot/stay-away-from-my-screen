<img width="128" height="128" alt="Icon-iOS-Default-1024x1024@1x" src="https://github.com/user-attachments/assets/fb5ec15e-3002-4f01-9013-c9e3004951ba" />

# Stay Away From My Screen

The instant digital "Do Not Touch" sign for your Mac. Stop fingerprints and protect your expensive display with one keystroke. 

We've all winced when a colleague leans in to jab their finger right onto our pristine screen to "point something out." Stay Away From My Screen is a lightweight macOS menu bar utility designed to stop that mid-motion. With a single global hotkey, deploy a massive, unmissable warning shield that effectively shouts "HANDS OFF." It's the perfect deterrent for greasy fingers, and also doubles as a quick privacy screen when you need to step away for a moment.

<a href="https://www.producthunt.com/products/stay-away-from-my-screen?embed=true&amp;utm_source=badge-featured&amp;utm_medium=badge&amp;utm_campaign=badge-stay-away-from-my-screen" target="_blank" rel="noopener noreferrer"><img alt="STAY AWAY FROM MY SCREEN - The &quot;Don't Touch&quot; sign for your Mac's expensive screen. | Product Hunt" width="250" height="54" src="https://api.producthunt.com/widgets/embed-image/v1/featured.svg?post_id=1060682&amp;theme=light&amp;t=1768010846943"></a>

## Features

- 🎯 **Global Hotkey**: Trigger the popup from anywhere with a customizable keyboard shortcut
- 💥 **Cracked Screen Effect**: Realistic cracking animation at cursor position as an alternative to text warning
- 🖐️ **Hand Tracking Detection**: Vision framework-based automatic activation when fingers stretch toward screen
- 🎨 **Customizable Appearance**: Change the popup text and background color
- 📍 **Smart Positioning**: Popup appears at mouse cursor location and stays on screen
- 🚀 **Launch at Login**: Optional auto-start with macOS
- 💫 **Floating Panel**: Always-on-top overlay that works across all spaces and fullscreen apps
- ⚙️ **Menu Bar Access**: Quick access to settings and controls from the menu bar

## Screenshots

<img width="890" height="677" alt="Screenshot 2026-01-10 at 10 10 12" src="https://github.com/user-attachments/assets/cae580f4-20a4-4f8b-9ae8-3516fb756bdc" />

<img width="589" height="512" alt="image" src="https://github.com/user-attachments/assets/20db8cec-04cc-424a-8f02-144cb84acd82" />

<img width="446" height="346" alt="image" src="https://github.com/user-attachments/assets/2e427223-1e1d-4a40-bccc-583fc9123e6c" />

## Requirements

- macOS 13.0 or later
- Accessibility permissions (for global hotkey functionality)
- Camera permissions (optional, for hand tracking feature)

## Installation

### Building from Source

1. Clone the repository:
   ```bash
   git clone https://github.com/aeilot/stay-away-from-my-screen.git
   cd stay-away-from-my-screen
   ```

2. Open the project in Xcode:
   ```bash
   open stay-away-from-my-screen.xcodeproj
   ```

3. Build and run the project (⌘R)

## Setup

### Granting Accessibility Permissions

For the global hotkey to work, you need to grant Accessibility permissions:

1. Open **System Settings** > **Privacy & Security** > **Accessibility**
2. Click the lock icon to make changes
3. Add and enable "Stay Away From My Screen"

The app will prompt you for these permissions on first launch.

### Granting Camera Permissions (Optional)

For hand tracking to work, you need to grant Camera permissions:

1. Open **System Settings** > **Privacy & Security** > **Camera**
2. Enable "Stay Away From My Screen"

This is only required if you want to use the automatic hand tracking feature.

## Usage

### Basic Usage

1. Launch the app - it will appear in your menu bar with a warning light icon (⚠️)
2. Set up your preferred hotkey in Settings
3. Press your hotkey to show/hide the popup overlay

### Configuring Settings

Access settings through:
- Menu bar icon > Settings
- Or from the main app window

**Available Settings:**

- **Launch at Login**: Automatically start the app when you log in
- **Global Hot Key**: Set your preferred keyboard shortcut (e.g., ⌘⇧S)
- **Use Cracked Screen Effect**: Toggle between text warning and cracked screen animation
- **Popup Text**: Customize the message displayed in the popup (when not using cracked screen)
- **Popup Color**: Choose the background color for the popup (when not using cracked screen)
- **Enable Hand Tracking**: Automatically activate when fingers stretch toward the screen using Vision framework

### Using Cracked Screen Effect

1. Open Settings
2. Enable "Use Cracked Screen Effect"
3. Trigger the popup with your hotkey or hand gesture
4. A realistic cracking animation will appear at your cursor position for 3 seconds

### Using Hand Tracking

1. Open Settings
2. Enable "Enable Hand Tracking"
3. Grant camera permissions when prompted
4. The app will now automatically detect when you or someone else reaches toward the screen
5. The warning will activate automatically when a stretching gesture is detected

### Setting a Hotkey

1. Open Settings
2. Click on the hotkey field under "Global Hot Key"
3. Press your desired key combination (must include at least one modifier: ⌘, ⇧, ⌃, or ⌥)
4. The hotkey is saved automatically

## Default Configuration

- **Default Hotkey**: ⌘⇧S (Command + Shift + S)
- **Default Text**: "STAY AWAY FROM MY SCREEN"
- **Default Color**: Red
- **Default Effect**: Text warning (cracked screen disabled)
- **Default Hand Tracking**: Disabled

## Project Structure

```
stay-away-from-my-screen/
├── App.swift                       # Main app entry point
├── View/
│   ├── ContentView.swift           # Main window view
│   ├── MenuView.swift              # Menu bar menu
│   ├── PopupView.swift             # Popup overlay panel
│   ├── CrackedScreenView.swift     # Cracked screen effect
│   └── SettingsView.swift          # Settings interface
└── Utils/
    ├── HotKeyManager.swift         # Global hotkey handling
    ├── HandTrackingManager.swift   # Vision-based hand tracking
    └── SettingsManager.swift       # User preferences persistence
```

## Technologies

- **SwiftUI**: Modern declarative UI framework
- **AppKit**: macOS-specific UI components and window management
- **Vision**: Apple's framework for hand pose detection and tracking
- **AVFoundation**: Camera capture for hand tracking
- **HotKey**: Third-party library for global hotkey registration

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Author

Created by Chenluo Deng

## Acknowledgments

- [HotKey](https://github.com/soffes/HotKey) - Swift framework for global keyboard shortcuts
