# FAQ

**Is Bool a jailbreak?**
No. It uses the [worse_query](https://github.com/forcequitOS/worse_query)
sandbox escape to write to locations reachable from an App Group container.
No jailbreak is installed and none is required.

**Which iOS versions are supported?**
See the [compatibility table](../README.md#compatibility). In short: full
support on iOS 27.0-27.2.1 and 27.3 beta 1, limited support (no MobileGestalt
tweaks) on iOS 26.0-26.7.2. Support ends whenever Apple patches worse_query.

**Do tweaks survive a reboot?**
It depends. MobileGestalt edits target the system's cache file, and cache
rebuilds can discard them. The app's "Overwrite Atomically" write mode is
meant to improve persistence, but it is unverified on the latest betas.
Assume you may need to re-apply tweaks after a reboot.

**Why is the IPA unsigned?**
So you sign it with your own Apple ID. Enterprise or distribution
certificates can break the App Group the tweaks rely on, and redistributing a
signed copy would not be legal.

**The app is called Erosion inside / in the project files. Why?**
The rebrand is intentionally home-screen only: the display name and icon say
Bool, while targets, bundle structure, and tweak code keep their upstream
names so the tweak logic stays identical to the project it is based on.

**Something went wrong after a tweak. What now?**
Reboot the device; most cache-based changes do not survive it. If a change
does persist and causes trouble, re-open Bool and revert it. This is exactly
why every tweak shows its own warning - read them.

**Where do I report bugs?**
Open an issue: <https://github.com/federicotaar/Bool/issues>
