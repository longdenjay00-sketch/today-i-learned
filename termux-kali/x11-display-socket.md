# Start Termux:X11 from PRoot with sv up tx11 and symlink X0

2026-10-23

Inside the Kali PRoot container, start the host X server with `SVDIR=/data/data/com.termux/files/usr/var/service` and `sv up tx11` rather than `am start` (which fails due to UID mismatch).

The live socket `/data/data/com.termux/files/usr/tmp/.X11-unix/X0` must be symlinked into `/tmp/.X11-unix/X0` inside the PRoot guest, and X clients must run with `DISPLAY=:0`.
