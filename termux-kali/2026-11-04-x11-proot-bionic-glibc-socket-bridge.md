# TIL 2026-11-04: PRoot glibc vs Termux Bionic X11 UNIX Domain Socket Bridge

## The Core Problem
When launching `termux-x11` on the Android host, the X11 server binds its domain socket inside Termux's `$TMPDIR`:
```text
/data/data/com.termux/files/usr/tmp/.X11-unix/X0
```
However, GNU glibc applications (such as Firefox ESR, Openbox, or Alacritty) running inside the Kali Linux PRoot container expect the socket strictly at standard POSIX `/tmp`:
```text
/tmp/.X11-unix/X0
```
If not linked, clients throw `Error: Can't open display: :0`.

## The Solution
A simple cross-boundary symlink bridges the two runtimes:
```bash
ln -sf /data/data/com.termux/files/usr/tmp/.X11-unix/X0 /tmp/.X11-unix/X0
```
Additionally, `termux-x11` can be supervised via Termux runit (`tx11`), and remote display streaming can be enabled by attaching `x11vnc` directly to `:0` on port 5900.
