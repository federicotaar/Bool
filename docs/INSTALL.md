# Installing Bool

Bool is distributed as an unsigned IPA. You sign it with your own Apple ID and
sideload it, the same way as most apps of this kind.

## What you need

- An iPhone or iPad on a [supported iOS version](../README.md#compatibility)
- The latest `Bool.ipa` from [Releases](https://github.com/federicotaar/Bool/releases)
  (direct link: <https://github.com/federicotaar/Bool/releases/latest/download/Bool.ipa>)
- One of these signing tools:
  - **AltStore** (macOS/Windows + the AltStore app)
  - **SideStore** (like AltStore, refreshes over Wi-Fi / WireGuard)
  - **Sideloadly** (macOS/Windows, simplest one-off installs)

## Steps (AltStore / Sideloadly)

1. Download `Bool.ipa` on the device or computer you sign from.
2. Open the IPA with your signing tool and sign it with your Apple ID.
3. Install it on the device when the tool asks.
4. On first launch, if iOS blocks the app, go to
   **Settings > General > VPN & Device Management**, trust your Apple ID,
   then open Bool again.

## Notes and limits

- **Free Apple ID**: apps expire after 7 days and must be refreshed or
  reinstalled. Paid developer accounts last 1 year.
- Sideloading and refreshing generally need the device on the same Wi-Fi
  network as the computer (AltStore/Sideloadly); mobile data alone does not
  work for refreshes.
- **Enterprise or paid distribution certificates are not recommended**: they
  can break the App Group container Bool relies on, and tweaks will not apply.
- Bool does not auto-update. Watch the repository or check Releases for new
  builds and reinstall over the old one.
