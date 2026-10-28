# today i learned

Short notes on one thing learned. One file per note, distilled from hands-on sessions across our `aarch64` Termux + Kali PRoot workstation, AI harnesses (`agy`, `Grok`, `OpenCode`), and client engineering projects.

---

## Topic Index (20 Notes)

### 🗂️ `johnny-decimal/` — System Spine & Filesystem Layout
- [The home areas are the Johnny Decimal system](johnny-decimal/areas.md) (`2026-10-26`)
- [Project repos go in 10_DEV/11_PROJECTS](johnny-decimal/category-11-projects.md) (`2026-10-26`)
- [Kali dotfiles live in 55_INFRA](johnny-decimal/dotfiles.md) (`2026-10-26`)
- [Host paths after the move](johnny-decimal/host-paths.md) (`2026-10-26`)
- [Morpheus is the Kali guide](johnny-decimal/morpheus.md) (`2026-10-26`)
- [The three-letter directory names are gone](johnny-decimal/old-short-names.md) (`2026-10-26`)
- [/root has no loose files](johnny-decimal/root-listing.md) (`2026-10-26`)

### 🐉 `termux-kali/` — Android Host, PRoot Guest & X11
- [Start Termux:X11 from PRoot with `sv up tx11` and symlink `X0`](termux-kali/x11-display-socket.md) (`2026-10-23`)
- [Firefox ESR under Kali PRoot requires sandbox overrides on `DISPLAY=:0`](termux-kali/firefox-proot-sandbox.md) (`2026-10-23`)
- [Find the Termux SSH host after a DHCP change with Python `connect_ex`](termux-kali/ssh-termux-dhcp-sweep.md) (`2026-10-26`)
- [Allow `esbuild` postinstall scripts under npm 12 on `aarch64`](termux-kali/esbuild-allow-scripts.md) (`2026-10-24`)
- [Installed Android tools vs repo-only packages on Kali PRoot](termux-kali/android-tools-installed.md) (`2026-10-22`)

### 🔧 `conduit-bending/` — EMT Hand-Bender Math & NEC 358
- [EMT hand-bender take-up is 5 in., 6 in., and 8 in.](conduit-bending/take-up-and-stub.md) (`2026-10-25`)
- [EMT offset multipliers and shrink per inch of depth](conduit-bending/offset-multipliers-and-shrink.md) (`2026-10-25`)
- [Three-point saddle layout and the NEC 358.26 360-degree bend budget](conduit-bending/three-point-saddle-and-360-budget.md) (`2026-10-25`)

### ⚡ `electrician/` — NEC Chapter 9 & Trade Curriculum
- [NEC Chapter 9 Table 1 conduit fill percentages and nipple rule](electrician/nec-chapter-9-table-1-fill.md) (`2026-10-18`)

### 🤖 `ai-harnesses/` — Antigravity (`agy`), Grok, OpenCode & Local Models
- [Run Grok in headless mode with `GenerateImage` for 16:9 hero banners](ai-harnesses/grok-headless-imagine.md) (`2026-10-28`)
- [Install paths for `agy`, `grok`, `opencode`, and `codex` on this host](ai-harnesses/installed-coding-clis.md) (`2026-10-21`)
- [Offline GGUF inference with `hf download` and `llama-cli`](ai-harnesses/local-lfm25-gguf-cache.md) (`2026-10-20`)

### 🐢 `turbo-the-turtle/` — Media Pipeline & `ffmpeg`
- [Re-encode upside-down phone video clips in `ffmpeg` to bake rotation](turbo-the-turtle/ffmpeg-lanczos-rotation-fix.md) (`2026-10-24`)

---

## Add a note

Create `<topic>/<slug>.md`:

```markdown
# What you learned

2026-10-28

The fact, in a few sentences. Include the command, path, or setting that made it true.
```

The folder name is the topic. Add a folder when the subject is new. Keep one fact in one file. The date in the file is the day it was learned.
