# today i learned (`today_i_learned`)

Short notes on one thing learned—paired with a **mass-appeal Flutter micro-knowledge widget** (`TodayILearnedWidget`) that turns `<topic>/<slug>.md` notes into an interactive, swipeable, searchable learning feed.

One file per note, distilled from hands-on sessions across our `aarch64` Termux + Kali PRoot workstation, AI harnesses (`agy`, `Grok`, `OpenCode`), and electrical trade engineering projects.

---

## ✨ Documentation & Architecture Guides

- **[`README.md`](README.md)** — Topic index of all 20 canonical notes, quick-start guide, and markdown specification.
- **[`FLUTTER.md`](FLUTTER.md)** — Flutter package architecture, `TodayILearnedWidget` API reference, state management, and instructions for running on Android, Linux X11 (`DISPLAY=:0`), and Web.
- **[`DESIGN.md`](DESIGN.md)** — Visual design system ("Obsidian & Neon"), Material 3 color tokens, typography scale, micro-interactions, and mass-appeal UX psychology.

---

## 📱 Flutter `TodayILearnedWidget` Highlights

The repository includes a zero-dependency Flutter package (`lib/today_i_learned.dart`) built for universal appeal:

- **Dual Discovery Modes:** Toggle seamlessly between a **Responsive Bento Grid** (1, 2, or 3 columns depending on viewport width) and a **Swipeable Card Deck** (`PageView` with 0.88 viewport fraction).
- **6 Color-Coded Domain Topics:** Each category folder (`johnny-decimal`, `termux-kali`, `conduit-bending`, `electrician`, `ai-harnesses`, `turbo-the-turtle`) has a dedicated neon accent palette, emoji badge, and Material 3 icon.
- **Instant Full-Text & Tag Search:** Filter across titles, dates, CLI flags, NEC code sections (`358.26`, `Chapter 9 Table 1`), and Johnny Decimal paths in real time.
- **One-Tap Command & Markdown Copying:** Every card extracts its primary CLI command or trade formula into a monospace terminal pill with one-tap clipboard copy and haptic feedback.
- **Gamified Mastery & Streak Bar:** Track how many TIL facts you have mastered (`Check` toggle) alongside a bookmark filter and a **"Surprise Me"** random spotlight shuffler.
- **Built-In `<topic>/<slug>.md` Composer:** Tap **+ New TIL** to author a new note in-app, automatically generate its kebab-case slug, and copy the formatted Markdown directly to your clipboard.

### Drop-in Usage

```dart
import 'package:flutter/material.dart';
import 'package:today_i_learned/today_i_learned.dart';

class KnowledgeScreen extends StatelessWidget {
  const KnowledgeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TodayILearnedWidget(
        initialViewMode: TilViewMode.bentoGrid,
        enableComposer: true,
        onNoteSelected: (TilNote note) {
          debugPrint('Opened: ${note.relativePath}');
        },
      ),
    );
  }
}
```

---

## 📚 Topic Index (22 Notes)

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
- [Bridge glibc `agy` into Termux via `proot-distro login` wrapper](ai-harnesses/agy-termux-proot-wrapper.md) (`2026-10-28`)
- [Dual Bento Grid and Swipe Deck layout in `TodayILearnedWidget`](ai-harnesses/flutter-til-widget-architecture.md) (`2026-10-28`)
- [Run Grok in headless mode with `GenerateImage` for 16:9 hero banners](ai-harnesses/grok-headless-imagine.md) (`2026-10-28`)
- [Install paths for `agy`, `grok`, `opencode`, and `codex` on this host](ai-harnesses/installed-coding-clis.md) (`2026-10-21`)
- [Offline GGUF inference with `hf download` and `llama-cli`](ai-harnesses/local-lfm25-gguf-cache.md) (`2026-10-20`)

### 🐢 `turbo-the-turtle/` — Media Pipeline & `ffmpeg`
- [Re-encode upside-down phone video clips in `ffmpeg` to bake rotation](turbo-the-turtle/ffmpeg-lanczos-rotation-fix.md) (`2026-10-24`)

---

## ✍️ Add a Note

Create `<topic>/<slug>.md` (or use the **+ New TIL** button inside the Flutter widget):

```markdown
# What you learned

2026-10-28

The fact, in a few sentences. Include the command, path, or setting that made it true.
```

The folder name is the topic. Add a folder when the subject is new. Keep one fact in one file. The date in the file is the day it was learned.
