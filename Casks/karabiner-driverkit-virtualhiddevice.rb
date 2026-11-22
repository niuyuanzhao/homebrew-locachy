cask "karabiner-driverkit-virtualhiddevice" do
  version "8.8.0"
  sha256 "2b6e323bf690fde05b24ca2648536916a274d01496e3826dc8b050b63f8b9842"

  url "https://github.com/pqrs-org/Karabiner-DriverKit-VirtualHIDDevice/releases/download/v#{version}/Karabiner-DriverKit-VirtualHIDDevice-#{version}.pkg"
  name "Karabiner-DriverKit-VirtualHIDDevice"
  desc "Virtual USB HID keyboard and pointing device DriverKit extension"
  homepage "https://github.com/pqrs-org/Karabiner-DriverKit-VirtualHIDDevice"

  depends_on macos: ">= :sonoma"

  pkg "Karabiner-DriverKit-VirtualHIDDevice-#{version}.pkg"

  postflight do
    # Request DriverKit system extension activation (idempotent if already active).
    system_command "/Applications/.Karabiner-VirtualHIDDevice-Manager.app/Contents/MacOS/Karabiner-VirtualHIDDevice-Manager",
                   args:       ["activate"],
                   must_succeed: false
  end

  uninstall launchctl: "org.pqrs.service.daemon.Karabiner-VirtualHIDDevice-Daemon",
            quit:      "org.pqrs.Karabiner-VirtualHIDDevice-Daemon",
            pkgutil:   "org.pqrs.Karabiner-DriverKit-VirtualHIDDevice",
            delete:    [
              "/Applications/.Karabiner-VirtualHIDDevice-Manager.app",
              "/Library/Application Support/org.pqrs/Karabiner-DriverKit-VirtualHIDDevice",
              "/Library/LaunchDaemons/org.pqrs.service.daemon.Karabiner-VirtualHIDDevice-Daemon.plist",
            ]

  caveats <<~EOS
    Approve the DriverKit system extension once in:
      System Settings -> Login Items & Extensions -> Driver Extensions -> Karabiner-DriverKit-VirtualHIDDevice
    (or System Settings -> Privacy & Security on older macOS).
  EOS
end
