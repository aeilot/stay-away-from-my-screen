# Stay Away From My Screen

A lightweight macOS menu bar application that displays a customizable popup overlay when triggered by a global hotkey. Perfect for privacy, focus management, or quick screen blocking.

## Features

- 🎯 **Global Hotkey**: Trigger the popup from anywhere with a customizable keyboard shortcut
- 🎨 **Customizable Appearance**: Change the popup text and background color
- 📍 **Smart Positioning**: Popup appears at mouse cursor location and stays on screen
- 🚀 **Launch at Login**: Optional auto-start with macOS
- 💫 **Floating Panel**: Always-on-top overlay that works across all spaces and fullscreen apps
- ⚙️ **Menu Bar Access**: Quick access to settings and controls from the menu bar

## Requirements

- macOS 13.0 or later
- Accessibility permissions (for global hotkey functionality)

## Installation

### Building from Source

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/stay-away-from-my-screen.git
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
- **Global Hot Key**: Set your preferred keyboard shortcut (e.g., ⌘⇧Space)
- **Popup Text**: Customize the message displayed in the popup
- **Popup Color**: Choose the background color for the popup

### Setting a Hotkey

1. Open Settings
2. Click on the hotkey field under "Global Hot Key"
3. Press your desired key combination (must include at least one modifier: ⌘, ⇧, ⌃, or ⌥)
4. The hotkey is saved automatically

## Default Configuration

- **Default Hotkey**: ⌘⇧Space (Command + Shift + Space)
- **Default Text**: "Stay Away From My Screen"
- **Default Color**: Red

## Project Structure

```
stay-away-from-my-screen/
├── App.swift                 # Main app entry point
├── View/
│   ├── ContentView.swift     # Main window view
│   ├── MenuView.swift        # Menu bar menu
│   ├── PopupView.swift       # Popup overlay panel
│   └── SettingsView.swift    # Settings interface
└── Utils/
    ├── HotKeyManager.swift   # Global hotkey handling
    └── SettingsManager.swift # User preferences persistence
```

## Technologies

- **SwiftUI**: Modern declarative UI framework
- **AppKit**: macOS-specific UI components and window management
- **HotKey**: Third-party library for global hotkey registration

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Author

Created by Chenluo Deng

## Acknowledgments

- [HotKey](https://github.com/soffes/HotKey) - Swift framework for global keyboard shortcuts
