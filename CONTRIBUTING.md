# Contributing to Bool

Thanks for considering a contribution. A few ground rules specific to this
project:

## Home-screen rebrand boundary

Bool is a home-screen rebrand: the display name and icon say Bool, and
everything inside (target names, bundle structure, tweak code, labels) stays
identical to the upstream project so the tweak logic keeps working. Pull
requests must respect that boundary - do not rename internal identifiers,
targets, or files.

## What makes a good PR

- **Bug fixes** with a description of the device and iOS version tested.
- **Documentation** improvements (always welcome).
- **Compatibility reports** confirming which iOS versions a tweak works on.

## What to expect

- Code must build with `./ipabuild.sh` on Xcode 26 before review.
- The project is GPLv3 licensed; by contributing you agree your changes are
  under the same license. Keep existing copyright and license notices.
- Tweak behavior differs across devices and iOS versions, so "works on my
  phone" reports should name the exact version and build.

## Issues

Bug reports are most useful with: iOS version and build number, device
model, which tweak or screen, expected vs actual behavior, and whether a
reboot changes anything.
