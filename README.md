# homebrew-locachy

[中文](README.zh.md)

Homebrew tap for the LOCachy macOS extended-display sender service.

## Install and Start

```sh
brew tap niuyuanzhao/locachy
brew install niuyuanzhao/locachy/locachy-macos-sender
brew services start locachy-macos-sender
```

On the first run, grant **Screen Recording** and **Accessibility** to `LOCachy Extended Display` in **System Settings → Privacy & Security**.

Once the background service is running, connecting a Thunderbolt/USB4 cable (or hub, dock, or daisy chain) and opening `extdisplay` on LOCachy automatically discovers the receiver and starts the extended display.

## Formula Details

The formula builds `extdisplay-sender/macos` from [`niuyuanzhao/locachy-companion`](https://github.com/niuyuanzhao/locachy-companion) on the local Mac (requires macOS 14 or later and Xcode Command Line Tools) and signs the app bundle in `/opt/homebrew/var/locachy` with a persistent local code-signing identity so macOS privacy permissions survive upgrades.
