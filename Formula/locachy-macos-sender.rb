class LocachyMacosSender < Formula
  desc "Extended display sender for the LOCachy receiver"
  homepage "https://github.com/niuyuanzhao/locachy-companion"
  url "https://github.com/niuyuanzhao/locachy-companion.git",
      revision: "f8f203e29879b3a52f1b5f4773a59b86baa2c280"
  version "0.3.0"
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
  end

  def caveats
    <<~EOS
      Before the first session, grant Screen Recording and Accessibility in
      System Settings > Privacy & Security to locachy-macos-sender, or to the
      terminal app that starts it, then start it again. The sender never asks
      for these permissions itself. macOS may also ask for Local Network access.
    EOS
  end

  test do
    assert_match "CGVirtualDisplay classes are present",
                 shell_output("#{bin}/locachy-macos-sender --check")
  end
end
