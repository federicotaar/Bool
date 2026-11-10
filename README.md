<div align="center">
  <img src="Erosion/Resources/AppIcon.icon/Assets/bool-icon.png" alt="Bool icon" width="150">
  <h1>Bool</h1>
  <p>iOS customization toolbox using the <a href="https://github.com/forcequitOS/worse_query">worse_query</a> sandbox escape.</p>
  <p>Supports iOS 26.0 - 26.7.2 (limited) & iOS 27.0 - 27.2.1 & iOS 27.3 beta 1.</p>
</div>

### What it does
- **MobileGestalt tweaks** (iOS 27 only): toggle hidden device features such as Dynamic Island, Always-On Display, 80% charge limit, boot chime, internal settings and more.
- **Custom wallpapers** via PosterBoard, including MercuryPoster collections.
- **Dialer themes**: customize the phone app keypad.
- **Config tweaks** and a built-in **file browser**.

### Before you begin
- Create a backup of your device before usage. There is still a possibility of data loss.
- Tweaks depend on your device (and sometimes Apple's servers) cooperating. If one doesn't work the way you expected, there may be nothing the app can do.
- MobileGestalt tweaks are written to the system's MobileGestalt **cache**. iOS rebuilds that cache, for example on reboot, so tweaks revert and must be re-applied after a restart.
- Some tweaks can softbrick specific device configurations. Read the in-app warnings before enabling anything.

### Signing
Sign with your own Apple ID (SideStore, Impactor, or a similar sideloading method). Enterprise/paid certificates can break the App Group the exploit relies on.

### Credits
Bool is based on the [Erosion](https://github.com/jailbreakdotparty/Erosion) project.

- [lunginspector](https://github.com/lunginspector) - Primary developer and maintainer.
- [forcequit](https://github.com/forcequitOS) - worse_query sandbox escape and container enumeration strategy.
- [0xjohnny](https://github.com/0xjohnnydev) - worse_query sandbox escape.
- [Skadz](https://github.com/skadz108) - Exploit implementation, backend functions, and project maintainer.
- [rooootdev](https://github.com/rooootdev) - Various backend components.
- [neonmodder123](https://github.com/neonmodder123) - Developed WebView respring method.

### License
GNU General Public License v3.0 - see [LICENSE](LICENSE).
