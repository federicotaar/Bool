# build-verification

Artifacts produced by the **Verify built icon** GitHub Actions workflow.
They record what the icon compiled into a released `Bool.ipa` actually looks
like, so icon regressions are visible in git history.

- `AppIcon60x60@2x.cgbi.png` - the icon exactly as extracted from the IPA
  (Apple's CgBI PNG variant; most image viewers cannot open it)
- `AppIcon60x60@2x.png` - the same icon decoded to a normal PNG
- `icon-report.txt` - sha256, size, CgBI flag, sample pixels, 8x8 color
  grid, mean RGB difference against the source artwork, and the bundle's
  display names

See [docs/ICON.md](../docs/ICON.md) for how the pipeline works.
