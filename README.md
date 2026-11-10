# homebrew-locachy

Homebrew tap for the LOCachy macOS extended display sender.

```sh
brew tap niuyuanzhao/locachy
brew trust niuyuanzhao/locachy
brew install niuyuanzhao/locachy/locachy-macos-sender
```

Homebrew asks you to trust a third-party tap before it loads its formulae. `brew trust` covers only this tap.

The formula builds `companion/macos` from the [LOCachy repository](https://github.com/niuyuanzhao/locachy) on your Mac. Nothing prebuilt is downloaded. The pinned OpenDisplay revision is checked by its digest. Building needs macOS 14 or later and the Xcode Command Line Tools; a full Xcode is not needed.

`brew install --HEAD niuyuanzhao/locachy/locachy-macos-sender` builds the newest `main` instead of the release.

## Use

Before the first session, open System Settings > Privacy & Security. Grant Screen Recording and Accessibility to `locachy-macos-sender`, or to the terminal app that starts it. The sender never asks for these permissions itself. macOS may also ask for Local Network access.

Connect the Thunderbolt/USB4 cable, start the extended display on LOCachy, and run:

```sh
locachy-macos-sender --interface <Thunderbolt interface> --address <address shown on LOCachy> --port 27183
```

The interface is the Thunderbolt Bridge, usually `bridge0`; `networksetup -listallhardwareports` lists it. Type the pairing code shown on the LOCachy screen at the prompt. The sender and receiver are described in `companion/macos/README.md` and `src/tools/KVM.md` of the LOCachy repository.

## Releases

The formula fetches `niuyuanzhao/locachy` with git at a fixed commit. A release adds the tag and that tag's commit (`tag:` and `revision:`) and raises `version`. The formula names a commit, not a source archive checksum, because GitHub does not guarantee that its generated archives keep their checksums.

The `opendisplay` resource is a pinned archive. It changes only when `companion/macos/build.sh` pins another upstream revision. Its digest must then match the one in `build.sh`.
