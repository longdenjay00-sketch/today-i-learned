# Changelog

All notable changes to the `today-i-learned` knowledge corpus and `TodayILearnedWidget` Flutter package are documented in this file.

The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and timestamps are UTC.

---

## [2026-11-23] — Multi-Distro Fleet Distillation & Corpus Cleanup (`34 Notes`)

### Added
- Distilled five cross-distro operational TIL notes from container cleanup and brain/chat-history audits (`34` notes total across `8` topics):
  - `johnny-decimal/gdrive-symlink-vault-isolation.md` — Symlinking `00_INBOX`–`80_ARCHIVE` into `70_BACKUP/longden/gdrive` across all five PRoot guests while isolating secrets in local-only `90_VAULT` (`vault-local`) and push-locking index repos (`DISABLED-LOCAL-ONLY`).
  - `termux-kali/tmux-termux-socket-from-proot.md` — Passing Termux's `TMUX_TMPDIR` socket (`tmux-<uid>/default`) with `tmux -S` and `-J` unwrap from inside PRoot.
  - `termux-kali/termux-x11-turnip-flags-and-desktop.md` — `termux-x11` recovery flags (`-legacy-drawing`, `-force-bgra`, `-disable-dri3`, `-disable-gpu-present`) and Turnip/Zink vs `virgl_test_server_android` GPU acceleration.
  - `ai-harnesses/agy-glibc-musl-sigill-cortex-a53.md` — Shipping glibc `/opt/agy/agy` across Alpine, Arch Linux ARM, Debian/Kali, Ubuntu, and Void with `AGY_CLI_DISABLE_AUTO_UPDATE=1` to prevent Cortex-A53/A73 `SIGILL`.
  - `ai-harnesses/opencode-sqlite-session-v2-mismatch.md` — Diagnosing `session_v2` vs legacy `session` SQLite table errors read-only via `mode=ro`.
- `python/print-variables-and-input.md` (`0e6ed04`) — Promoted the Nov 17 Python input and casting lesson into the canonical `<topic>/<slug>.md` layout.
- `.gitignore` (`59b1f4a`) — Added Flutter/Dart and IntelliJ build exclusions (`.dart_tool/`, `build/`, `*.iml`).
- `CHANGELOG.md` — Initialized project changelog and linked it from `README.md`.

### Changed
- Normalized four `2026-11-04` notes to `<topic>/<slug>.md` with standalone ISO date lines (`7c161ac`, `5c18389`, `886fd7f`, `5e9bfe9`).
- Extended `pubspec.yaml` (`bfde4a7`), `lib/models/til_note.dart` (`8adc7c0`), `lib/data/til_repository.dart`, `test/today_i_learned_widget_test.dart`, `DESIGN.md` (`a6bcb82`), `FLUTTER.md` (`5c3b926`), and `README.md` to cover all `8` domains and `34` verified notes.
- Re-committed the pending cleanup and all new additions cleanly as atomic single-file commits.

---

## [2026-11-04] — Initial Bitcoin, Electrician, X11 Socket & Transcript Notes

### Added
- `42ad97a`, `d76e568`, `f4ef16c`, `5c61ff2` — Added four notes covering PRoot vs Termux Bionic X11 sockets, Bitcoin Script Forth stack evaluation, NEC box fill/working space clearances, and JSONL transcript harvesting.

---

## [2026-10-28] — [2026-10-30] — Flutter `TodayILearnedWidget` & Core Corpus Expansion

### Added
- `3f77832` — Added Termux `runsv` `down` trigger note (`termux-kali/termux-runsv-sshd-down-file.md`).
- `c7f13aa` — Added 50-repo developer roadmap note (`ai-harnesses/fifty-repos-developer-roadmap.md`).
- `5949805` — Added `agy-termux` PRoot wrapper and Flutter TIL widget architecture notes.
- `d7900f3` — Added `TodayILearnedWidget` Flutter package, `DESIGN.md`, `FLUTTER.md`, and widget/unit test suite.
- `be5642d` — Added scraped Grok session notes across `termux-kali`, `conduit-bending`, `electrician`, `ai-harnesses`, and `turbo-the-turtle`.

---

## [2026-10-24] — [2026-10-26] — Repository Scaffold & Johnny Decimal Notes

### Added
- `c858713` — Added the initial seven `johnny-decimal/` notes documenting the system spine.
- `a16053e` — Initialized `README.md`.
