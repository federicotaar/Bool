# App icon pipeline

Bool's icon is a cloud-and-sky design. The rebrand is home-screen only, so
getting a custom icon into an unsigned, `actool`-compiled IPA needed some
verification tooling.

## Source assets

- `Erosion/Resources/AppIcon.icon/` - the icon definition (`icon.json`) and
  its layers (`Assets/bool-icon.png` and friends)
- `PreviewIcon.png` - flat preview used outside the app

The icon is compiled into `Assets.car` by Xcode's asset catalog compiler,
which also encodes PNGs in Apple's **CgBI** variant (premultiplied,
BGRA-ordered, headerless-deflate PNG).

## Verification

The **Verify built icon** workflow (`.github/workflows/verify-icon.yml`):

1. Downloads `Bool.ipa` from a release.
2. Extracts the compiled `AppIcon60x60@2x.png` from the app bundle.
3. Decodes the CgBI PNG manually (chunk parsing, unfiltering,
   un-premultiplying) with a small Python script - stock image libraries
   refuse CgBI files.
4. Compares the decoded pixels against the source artwork (mean absolute
   RGB difference) and reports corner/center/average colors plus an 8x8
   pixel grid.
5. Writes the normalized PNG and a text report to `build-verification/` and
   commits them, so there is always a record of what the compiled icon
   actually looks like on device.

Latest report: [build-verification/icon-report.txt](../build-verification/icon-report.txt)
