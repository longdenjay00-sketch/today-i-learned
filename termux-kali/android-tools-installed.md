# Installed Android tools vs repo-only packages on Kali PRoot

2026-10-22

This Kali Rolling `aarch64` container has `/usr/bin/adb` (`1:34.0.5-13`), `aapt`, `aapt2`, `scrcpy`, `waydroid`, `androidbackup2john`, and `androidfde2john` installed out of the box.

Reverse-engineering and flashing utilities (`jadx`, `apktool`, `dex2jar`, `androguard`, `apksigner`, `fastboot`) are available in the `kali-rolling` APT repositories but are not pre-installed.
