# homebrew-locachy

LOCachy macOS 扩展屏发送端的 Homebrew tap。

```sh
brew tap niuyuanzhao/locachy
brew trust niuyuanzhao/locachy
brew install niuyuanzhao/locachy/locachy-macos-sender
```

Homebrew 在加载第三方 tap 的配方前，要求先信任它。`brew trust` 只信任这个 tap。

配方在你的 Mac 上从 [LOCachy 仓库](https://github.com/niuyuanzhao/locachy)编译 `companion/macos`，不下载任何预编译文件。固定版本的 OpenDisplay 上游包按校验值核对。编译需要 macOS 14 或更新版本和 Xcode 命令行工具，不需要完整的 Xcode。

`brew install --HEAD niuyuanzhao/locachy/locachy-macos-sender` 编译最新的 `main`，而不是发布版本。

## 使用

第一次使用前，打开"系统设置 → 隐私与安全性"，把"屏幕录制"和"辅助功能"授权给 `locachy-macos-sender`，或者授权给启动它的终端程序。发送端自己从不弹出授权请求。macOS 可能还会要求"本地网络"权限。

接上雷电/USB4 线，在 LOCachy 上打开扩展屏，然后运行：

```sh
locachy-macos-sender --interface <雷电接口> --address <LOCachy 屏幕上显示的地址> --port 27183
```

接口是雷电网桥，通常是 `bridge0`，可以用 `networksetup -listallhardwareports` 查到。在提示处输入 LOCachy 屏幕上显示的配对码。发送端和接收端的说明见 LOCachy 仓库的 `companion/macos/README.zh.md` 和 `src/tools/KVM.zh.md`。

## 发布

配方用 git 按固定提交号获取 `niuyuanzhao/locachy`。每次发布时，在配方里写上 tag 和它对应的提交号（`tag:` 与 `revision:`），并提高 `version`。配方写的是提交号，而不是源码压缩包的校验值，因为 GitHub 不保证它自动生成的压缩包校验值长期不变。

`opendisplay` 资源是一个固定版本的压缩包。只有 `companion/macos/build.sh` 固定了另一个上游版本时才需要改，它的校验值必须和 `build.sh` 里的一致。
