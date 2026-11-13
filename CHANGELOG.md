# Changelog

All notable changes to Bool are documented here. Release versions use the
`YYYY.MM.DD.N` scheme (date of the build plus a per-day counter).

## [2026.11.13.2] - 2026-11-13

### Corrected
- Removed the free-height slider and animated position preview. ArtworkDeviceSubType
  chooses a system layout profile, not a pixel offset. The earlier preview was not
  connected to SpringBoard and did not predict the actual position. The earlier
  claim that a larger number always moves the island down was incorrect.
- Corrected the iPhone 14 Pro profile from 2436 (iPhone X gestures) to 2556.
- Existing unrecognized profile values are preserved, not silently reset.
- Explicitly copy and reattach nested artwork/cache dictionaries before serialization.
- Read back the saved profile after a write. A mismatch or unreadable cache prevents
  a success message and automatic respring. A read-only Check Saved Profile button
  distinguishes the file value from what SpringBoard displays.

### Limits
- This build does not provide arbitrary positioning under the notch. Profiles may
  affect layout differently by iOS version and Display Zoom. No display-resolution
  edits, new exploits or SpringBoard injection were added; the writer is unchanged.
- Compilation and fixture-plist tests do not validate device behavior. No main-phone
  testing has been performed by the maintainer for this correction.

## [2026.11.13.1] - 2026-11-13

Replaced the numeric input with a slider and illustrative animation. The claimed
continuous positioning fix was not valid: the app only wrote a device profile.
This release is superseded by 2026.11.13.2. See the correction above.

## [2026.11.12.1] - 2026-11-12

### Added
- "Custom Height..." entry in the Dynamic Island subtype picker: the subtype
  value can now be typed in manually instead of being limited to the presets.
  The choice persists in-app and is never applied automatically.
- Warning on the Always-On Display toggle about the documented side effects
  on unsupported (non-LTPO) hardware: unreliable tap to wake and a
  non-responsive lock screen music player.

### Fixed
- Charge Limit and Boot Chime toggles were gated on each other's hardware
  support, so the wrong one could be hidden on devices with only one of them.
- Applying a lock screen footnote no longer discards other keys already
  present in SharedDeviceConfiguration.plist.
- Dialer keys with no cached image no longer stop the remaining keys from
  loading, and applying a theme no longer writes empty images over unedited
  keys (which blanked them in the Phone app).
- Keypad and wallpaper setup no longer mutate view state from a background
  thread.

### Changed
- `GestaltStore.isEnabled` now actually tests every key it is given.
- The ten hardware-capability checks share one lookup helper; device lists
  are unchanged.
- Temporary extraction folders are cleaned up after wallpaper and keypad
  theme imports.

## [2026.11.10.1] - 2026-11-10

First public release.

### Added
- Home-screen rebrand to Bool: display name "Bool" and cloud-and-sky app icon; internal UI and tweak code unchanged from upstream.
- Build Bool IPA GitHub Actions workflow: builds an unsigned IPA on demand and publishes a non-overwriting release with a versioned tag.
- Icon verification workflow: extracts the compiled `AppIcon60x60@2x.png` from the released IPA, decodes Apple's CgBI PNG variant, compares pixels against the source icon, and commits a report to `build-verification/`.
- Rounded README icon and preview assets.

### Changed
- Navigation title and `CFBundleDisplayName` updated from "Erosion" to "Bool".
- README rewritten with feature, compatibility, installation, and warning sections.
- Alert wording for the default App Group detection clarified.

## About this file

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).
