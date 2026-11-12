# Security Policy

## Scope

Bool modifies system behavior on your own device. Two different kinds of
security issues exist for a project like this:

1. **Vulnerabilities in Bool itself** - for example the app writing outside
   the containers it is supposed to touch, or corrupting data it should only
   read.
2. **The sandbox escape it relies on** -
   [worse_query](https://github.com/forcequitOS/worse_query) is a separate
   project; issues with the escape itself belong there.

## Reporting

Please **do not open a public issue** for a vulnerability in Bool. Instead,
report it privately through GitHub's private vulnerability reporting on the
repository's Security tab, or by contacting the maintainer through
[federicotaranu.com](https://federicotaranu.com).

Include: iOS version and build number, device model, the exact tweak or
action, what you expected, and what actually happened.

## Supported versions

Only the latest release receives fixes. Older builds may stop working at any
time when Apple patches the underlying escape.

## A note on risk

Any tool of this kind can, in the worst case, make a device unstable. Bool
ships unsigned so that no third party can tamper with the binary you
install - build it yourself or use only releases published on this
repository, and back up your device before enabling tweaks.
