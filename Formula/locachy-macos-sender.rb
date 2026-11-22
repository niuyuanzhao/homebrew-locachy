class LocachyMacosSender < Formula
  desc "Extended display sender for the LOCachy receiver"
  homepage "https://github.com/niuyuanzhao/locachy-companion"
  url "https://github.com/niuyuanzhao/locachy-companion.git",
      revision: "a882e9618bbb136ad4c7c213dc0878cec8b4fc97"
  version "0.5.2"
  license "GPL-3.0-or-later"
  head "https://github.com/niuyuanzhao/locachy-companion.git", branch: "main"

  depends_on macos: :sonoma

  # The OpenDisplay revision pinned by extdisplay-sender/macos/build.sh.
  resource "opendisplay" do
    url "https://github.com/peetzweg/opendisplay/archive/0f44853adc5d44646a9e4d74e4516db460efb8bb.tar.gz"
    sha256 "dba0ece10f0d0d810b63f64269d62dd3eaea52058f7566ea1159fb17be0f1a15"
  end

  def install
    out = buildpath/"companion-build"
    out.mkpath
    # Homebrew has already downloaded and verified the resource. build.sh uses
    # an archive already present in its output directory instead of downloading
    # one, and checks that archive's digest itself.
    cp resource("opendisplay").cached_download,
       out/"opendisplay-0f44853adc5d44646a9e4d74e4516db460efb8bb.tar.gz"
    system "sh", "extdisplay-sender/macos/build.sh", out
    bin.install out/"locachy-macos-sender"
    libexec.install out/"locachy-hid-helper"
    prefix.install out/"LOCachy Extended Display.app"
    pkgshare.install "extdisplay-sender/macos/build.sh"
    pkgshare.install "extdisplay-sender/macos/org.locachy.hid-helper.plist"
    pkgshare.install "extdisplay-sender/macos/org.pqrs.service.daemon.Karabiner-VirtualHIDDevice-Daemon.plist"
  end

  def post_install
    (var/"locachy").mkpath
    (var/"log").mkpath
    system "sh", pkgshare/"build.sh", "--sign",
           bin/"locachy-macos-sender",
           prefix/"LOCachy Extended Display.app",
           var/"locachy",
           libexec/"locachy-hid-helper"
  end

  service do
    run [var/"locachy/LOCachy Extended Display.app/Contents/MacOS/locachy-macos-sender"]
    keep_alive true
    process_type :interactive
    log_path var/"log/locachy-macos-sender.log"
    error_log_path var/"log/locachy-macos-sender.log"
  end

  def caveats
    <<~EOS
      Start the background service with:
        brew services start locachy-macos-sender
      Grant Screen Recording and Accessibility once in System Settings > Privacy & Security.
      For kernel-level virtual USB keyboard passthrough, also install the managed Cask:
        brew install --cask niuyuanzhao/locachy/locachy-virtual-hid
    EOS
  end

  test do
    assert_match "CGVirtualDisplay classes are present",
                 shell_output("#{bin}/locachy-macos-sender --check")
    assert_match "locachy-hid-helper ready",
                 shell_output("#{libexec}/locachy-hid-helper --check")
  end
end
