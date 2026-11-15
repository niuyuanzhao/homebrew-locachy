# homebrew-locachy

[English](README.md)

LOCachy macOS 扩展屏后台发送端服务的 Homebrew tap。

## 安装与启动

```sh
brew tap niuyuanzhao/locachy
brew install niuyuanzhao/locachy/locachy-macos-sender
brew services start locachy-macos-sender
```

首次使用时，在 **系统设置 → 隐私与安全性** 中为 `LOCachy Extended Display` 授予 **屏幕录制** 和 **辅助功能** 权限。

后台服务启动后，通过雷电／USB4 线缆（或兼容的 Hub、Dock、菊花链）连接并在 LOCachy 上打开 `extdisplay`，即可自动发现接收器并建立扩展屏连接。

## 配方说明

配方在本地从 [`niuyuanzhao/locachy-companion`](https://github.com/niuyuanzhao/locachy-companion) 编译 `extdisplay-sender/macos`（需要 macOS 14 或更新版本与 Xcode 命令行工具），并在 `/opt/homebrew/var/locachy` 中使用持久化本地签名证书签名应用包，确保升级版本后 macOS 隐私权限保持有效。
