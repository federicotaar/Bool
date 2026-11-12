# Changelog

All notable changes to Bool are documented here. Release versions use the
`YYYY.MM.DD.N` scheme (date of the build plus a per-day counter).

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
