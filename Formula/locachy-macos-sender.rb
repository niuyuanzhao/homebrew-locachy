class LocachyMacosSender < Formula
  desc "Extended display sender for the LOCachy receiver"
  homepage "https://github.com/niuyuanzhao/locachy-companion"
  url "https://github.com/niuyuanzhao/locachy-companion.git",
      revision: "3647e352bccd77a0ad709cc6456b3d4bffbb17d2"
  version "0.4.6"
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
    prefix.install out/"LOCachy Extended Display.app"
    pkgshare.install "extdisplay-sender/macos/build.sh"
  end

  def post_install
    (var/"locachy").mkpath
    (var/"log").mkpath
    system "sh", pkgshare/"build.sh", "--sign",
           bin/"locachy-macos-sender",
           prefix/"LOCachy Extended Display.app",
           var/"locachy"
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
    EOS
  end

  test do
    assert_match "CGVirtualDisplay classes are present",
                 shell_output("#{bin}/locachy-macos-sender --check")
  end
end
