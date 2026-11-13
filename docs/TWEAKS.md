# Tweak categories

Bool groups its tweaks by the system area they touch. This page summarizes
what each category does at a high level; every tweak carries its own in-app
warning, which you should read before enabling it.

## MobileGestalt tweaks (`Erosion/Tweaks/MobileGestalt/`)

Toggles hidden device capabilities reported by MobileGestalt, such as
Dynamic Island (system layout profiles, not manually entered pixel heights), Always-On Display,
the 80% charge limit, the boot chime, and
internal build flags. **iOS 27 only.** The app writes to the MobileGestalt
cache; whether edits persist across a reboot depends on the write mode (the
app offers an "Overwrite Atomically" option) and on iOS version behavior.

- `GestaltStore.swift` - loading and caching of MobileGestalt values
- `GestaltHelpers.swift` - typed accessors and value conversion helpers
- `GestaltView.swift` - the tweak list UI
- `CustomKeyView.swift` - editing arbitrary MobileGestalt keys by hand

## Custom wallpapers (`Erosion/Tweaks/PosterBoard/`)

PosterBoard-based wallpaper collections, including MercuryPoster support.

- `PBHandler.swift` - applying and managing PosterBoard descriptors
- `PosterBoardView.swift` - the wallpaper picker UI

## Dialer themes (`Erosion/Tweaks/Keypads/`)

Custom keypad images for the Phone app.

- `KeypadManager.swift` - installing and removing keypad assets
- `KeypadView.swift` - the keypad theme UI

## Config tweaks (`Erosion/Tweaks/Other/` + `ConfigView.swift`)

Additional system configuration toggles that do not fit the categories above.

## File browser (`Erosion/FileManager/`)

A browser and editor for files inside the app containers reachable through
the sandbox escape, including plist viewing and editing.

> **Warning:** any tool that writes to system caches carries risk. Back up
> your device, and treat "it did not work" as a possible outcome rather than
> proof of a bug.
