# homebrew-locachy

[English](README.md)

LOCachy macOS 扩展屏后台发送端服务的 Homebrew tap。

## 安装与启动

如需内核级虚拟 USB 键盘原装直通（完整支持长按 Command/Meta、跨设备修饰键组合、系统热键与安全密码框），推荐安装 `locachy-virtual-hid` Cask（自动列管固定版本的 `karabiner-driverkit-virtualhiddevice` Cask、`locachy-macos-sender` Formula 以及 root `locachy-hid-helper` LaunchDaemon）：

```sh
brew tap niuyuanzhao/locachy
brew install --cask niuyuanzhao/locachy/locachy-virtual-hid
brew services start locachy-macos-sender
```

首次使用时：
- 在 **系统设置 → 隐私与安全性** 中为 `LOCachy Extended Display` 授予 **屏幕录制** 和 **辅助功能** 权限。
- 在 **系统设置 → 登录项与扩展 → 驱动程序扩展** 中批准 **Karabiner-DriverKit-VirtualHIDDevice** 扩展。

若只需无驱动的用户态发送端（使用物理键码 1:1 直通的 `CGEventPost` 回退路径）：

```sh
brew tap niuyuanzhao/locachy
brew install niuyuanzhao/locachy/locachy-macos-sender
brew services start locachy-macos-sender
```

后台服务启动后，通过雷电／USB4 线缆（或兼容的 Hub、Dock、菊花链）连接并在 LOCachy 上打开 `extdisplay`，即可自动发现接收器并建立扩展屏连接。

## 配方说明

- `Formula/locachy-macos-sender.rb`：在本地从 [`niuyuanzhao/locachy-companion`](https://github.com/niuyuanzhao/locachy-companion) 编译 `extdisplay-sender/macos`（需要 macOS 14 或更新版本与 Xcode 命令行工具），并在 `/opt/homebrew/var/locachy` 中使用持久化本地签名证书签名应用包与 helper，确保升级版本后 macOS 隐私权限保持有效。
- `Casks/karabiner-driverkit-virtualhiddevice.rb`：锁死版本的 DriverKit 虚拟 HID 扩展（`v8.8.0`，`client_protocol_version = 7`）。
- `Casks/locachy-virtual-hid.rb`：同时强制依赖 `karabiner-driverkit-virtualhiddevice` 与 `locachy-macos-sender` 的元 Cask，负责安装并托管 `org.locachy.hid-helper` 与 `org.pqrs.service.daemon.Karabiner-VirtualHIDDevice-Daemon` 两个 root LaunchDaemon。
