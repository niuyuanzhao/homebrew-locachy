# homebrew-locachy

[中文](README.zh.md)

Homebrew tap for the LOCachy macOS extended-display sender service.

## Install and Start

For full kernel-level virtual USB keyboard passthrough (hardware modifier holds, system hotkeys, secure input), install the `locachy-virtual-hid` Cask (which manages the pinned `karabiner-driverkit-virtualhiddevice` DriverKit Cask, the `locachy-macos-sender` Formula, and the root `locachy-hid-helper` LaunchDaemon):

```sh
brew tap niuyuanzhao/locachy
brew install --cask niuyuanzhao/locachy/locachy-virtual-hid
brew services start locachy-macos-sender
```

On the first run:
- Grant **Screen Recording** and **Accessibility** to `LOCachy Extended Display` in **System Settings → Privacy & Security**.
- Approve **Karabiner-DriverKit-VirtualHIDDevice** in **System Settings → Login Items & Extensions → Driver Extensions**.

For user-space-only installation without DriverKit (physical 1:1 `CGEventPost` keyboard fallback):

```sh
brew tap niuyuanzhao/locachy
brew install niuyuanzhao/locachy/locachy-macos-sender
brew services start locachy-macos-sender
```

Once the background service is running, connecting a Thunderbolt/USB4 cable (or hub, dock, or daisy chain) and opening `extdisplay` on LOCachy automatically discovers the receiver and starts the extended display.

## Formula & Cask Details

- `Formula/locachy-macos-sender.rb`: builds `extdisplay-sender/macos` from [`niuyuanzhao/locachy-companion`](https://github.com/niuyuanzhao/locachy-companion) on the local Mac (requires macOS 14 or later and Xcode Command Line Tools) and signs the app bundle and helper in `/opt/homebrew/var/locachy` with a persistent local code-signing identity so macOS privacy permissions survive upgrades.
- `Casks/karabiner-driverkit-virtualhiddevice.rb`: pinned DriverKit virtual HID extension (`v8.8.0`, `client_protocol_version = 7`).
- `Casks/locachy-virtual-hid.rb`: meta Cask depending on both `karabiner-driverkit-virtualhiddevice` and `locachy-macos-sender`, installing and supervising the root `org.locachy.hid-helper` and `org.pqrs.service.daemon.Karabiner-VirtualHIDDevice-Daemon` LaunchDaemons.
