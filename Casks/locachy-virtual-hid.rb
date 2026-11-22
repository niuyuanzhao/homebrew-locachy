cask "locachy-virtual-hid" do
  version "0.5.0"
  sha256 "3972dc9744f6499f0f9b2dbf76696f2ae7ad8af9b23dde66d6af86c9dfb36986"

  # Verified anchor file from the pinned locachy-companion revision; binaries
  # and LaunchDaemon plists come from the locachy-macos-sender formula.
  url "https://raw.githubusercontent.com/niuyuanzhao/locachy-companion/d42f0b2ec2b87983a66b1f9055fe853dc2bf3b89/LICENSE"
  name "LOCachy Virtual HID Bridge"
  desc "Root LaunchDaemon bridge connecting LOCachy Extended Display to Karabiner DriverKit virtual USB keyboard"
  homepage "https://github.com/niuyuanzhao/locachy-companion"

  depends_on macos: :sonoma
  depends_on cask: "niuyuanzhao/locachy/karabiner-driverkit-virtualhiddevice"
  depends_on formula: "niuyuanzhao/locachy/locachy-macos-sender"

  postflight_steps do
    support_dir = "/Library/Application Support/LOCachy"
    helper_dst = "#{support_dir}/locachy-hid-helper"
    helper_plist_dst = "/Library/LaunchDaemons/org.locachy.hid-helper.plist"
    karabiner_plist_dst = "/Library/LaunchDaemons/org.pqrs.service.daemon.Karabiner-VirtualHIDDevice-Daemon.plist"

    run "/bin/mkdir", args: ["-p", support_dir], sudo: true
    run "/usr/sbin/chown", args: ["root:wheel", support_dir], sudo: true
    run "/bin/chmod", args: ["0755", support_dir], sudo: true

    # Install root-owned helper binary and plists atomically from formula opt prefix.
    run "/usr/bin/install",
        args: ["-o", "root", "-g", "wheel", "-m", "0755", "{{HOMEBREW_PREFIX}}/opt/locachy-macos-sender/libexec/locachy-hid-helper", helper_dst],
        sudo: true
    run "/usr/bin/install",
        args: ["-o", "root", "-g", "wheel", "-m", "0644", "{{HOMEBREW_PREFIX}}/opt/locachy-macos-sender/share/locachy-macos-sender/org.pqrs.service.daemon.Karabiner-VirtualHIDDevice-Daemon.plist", karabiner_plist_dst],
        sudo: true
    run "/usr/bin/install",
        args: ["-o", "root", "-g", "wheel", "-m", "0644", "{{HOMEBREW_PREFIX}}/opt/locachy-macos-sender/share/locachy-macos-sender/org.locachy.hid-helper.plist", helper_plist_dst],
        sudo: true

    # Ensure Karabiner VirtualHIDDevice Daemon is running.
    run "/bin/launchctl", args: ["bootout", "system", karabiner_plist_dst], sudo: true, must_succeed: false
    run "/bin/launchctl", args: ["bootstrap", "system", karabiner_plist_dst], sudo: true
    run "/bin/launchctl", args: ["kickstart", "-k", "system/org.pqrs.service.daemon.Karabiner-VirtualHIDDevice-Daemon"], sudo: true, must_succeed: false

    # Ensure LOCachy root HID helper is running.
    run "/bin/launchctl", args: ["bootout", "system", helper_plist_dst], sudo: true, must_succeed: false
    run "/bin/launchctl", args: ["bootstrap", "system", helper_plist_dst], sudo: true
    run "/bin/launchctl", args: ["kickstart", "-k", "system/org.locachy.hid-helper"], sudo: true, must_succeed: false
  end

  uninstall launchctl: [
              "org.locachy.hid-helper",
              "org.pqrs.service.daemon.Karabiner-VirtualHIDDevice-Daemon",
            ],
            delete:    [
              "/Library/LaunchDaemons/org.locachy.hid-helper.plist",
              "/Library/LaunchDaemons/org.pqrs.service.daemon.Karabiner-VirtualHIDDevice-Daemon.plist",
              "/Library/Application Support/LOCachy/locachy-hid-helper",
              "/var/run/locachy-hid-helper.sock",
            ]

  caveats <<~EOS
    1. Approve the Karabiner DriverKit extension in:
         System Settings -> Login Items & Extensions -> Driver Extensions
    2. Start or restart the user sender service:
         brew services restart locachy-macos-sender
    Until the DriverKit extension is approved, LOCachy automatically falls back to physical 1:1 CGEventPost.
  EOS
end
