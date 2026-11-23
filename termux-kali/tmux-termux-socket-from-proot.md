# Locate Termux live tmux socket from inside PRoot

2026-11-23

Termux sets `TMUX_TMPDIR=/data/data/com.termux/files/usr/var/run` and creates its socket at `tmux-<android_uid>/default` (such as `tmux-10135/default`), whereas commands inside a `proot-distro` guest default to `/tmp/tmux-0/default` and report `no server running`.

Pass the host socket explicitly with `tmux -S`, unwrap long wrapped lines with `-J`, and sanitize tokens or OAuth URLs before writing digests:

```bash
SOCK=$(find /data/data/com.termux/files/usr/var/run -name default -type s | head -n 1)
tmux -S "$SOCK" list-panes -a
tmux -S "$SOCK" capture-pane -p -J -t %0 -S -200
```
