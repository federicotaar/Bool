# Releasing a new build

Bool uses **date-based versions**: `YYYY.MM.DD.N`, where `N` is a per-day
counter starting at 1. Example: `2026.11.10.1` is the first build of
November 10, 2026. This matches the versioning used across the other
Fredrich Labs apps (NOVA, Mike), so every build is identifiable by its tag
alone.

## Cutting a release

1. Go to **Actions > Build Bool IPA > Run workflow**.
2. Enter the new version number. Releases never overwrite existing tags - if
   the tag exists, the workflow fails instead of replacing it, so increment
   the counter.
3. Wait for the macOS runner to build, verify, and publish the release with
   `Bool.ipa` attached.

The direct "latest build" link always points at the newest release:

```
https://github.com/federicotaar/Bool/releases/latest/download/Bool.ipa
```

## After releasing

- Update the Releases badge version in `README.md`.
- Add a section to `CHANGELOG.md`.
- Optionally run **Verify built icon** to confirm the compiled icon in the
  new IPA.
