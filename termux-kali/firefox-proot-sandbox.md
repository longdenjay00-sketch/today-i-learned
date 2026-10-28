# Firefox ESR under Kali PRoot requires sandbox overrides on DISPLAY=:0

2026-10-23

Firefox ESR (`/usr/bin/firefox`) runs on `DISPLAY=:0` inside the Kali PRoot guest when launched with `MOZ_FAKE_NO_SANDBOX=1`, `LIBGL_ALWAYS_SOFTWARE=1`, and `MOZ_ENABLE_WAYLAND=0`.

The profile lives at `/root/55_INFRA/dotfiles/.mozilla/firefox/py.default` via the `~/.mozilla` symlink; if that symlink target is missing, Firefox shows a Profile Missing dialog.
