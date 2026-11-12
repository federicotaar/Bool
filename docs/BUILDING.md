# Building Bool from source

## Requirements

- macOS with **Xcode 26** (the project targets iOS 26+ SDKs)
- `ldid` for re-adding entitlements after stripping the signature:

  ```sh
  brew install ldid
  ```

## Build

```sh
./ipabuild.sh
```

This produces an unsigned `Erosion.ipa` in the repository root (the Xcode
target keeps the upstream name; the release workflow renames it to
`Bool.ipa`). For a debug configuration build:

```sh
./ipabuild.sh --debug
```

which produces `Erosion.debug.ipa`.

What the script does, in order:

1. Cleans any previous `build/` directory and IPA.
2. Builds the `Erosion` scheme with `xcodebuild`, code signing disabled.
3. Strips the (empty) signature and any embedded provisioning profile.
4. Re-attaches `Erosion/Erosion.entitlements` with `ldid`.
5. Packages the `.app` into an IPA and removes build artifacts.

## GitHub Actions

The **Build Bool IPA** workflow (`.github/workflows/build-ipa.yml`) does the
same thing on a `macos-26` runner:

1. Open the **Actions** tab and run **Build Bool IPA** manually.
2. Enter a new version number, e.g. `2026.11.12.1`. Tags are never reused or
   overwritten, so pick one that does not exist yet.
3. The workflow patches the libarchive SDK path for the runner's SDK, builds,
   verifies the packaged bundle and icon, and creates a release with the
   unsigned `Bool.ipa` attached.

The **Verify built icon** workflow downloads a released IPA and confirms the
compiled icon matches the source artwork (see [ICON.md](ICON.md)).
