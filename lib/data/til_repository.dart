import '../models/til_note.dart';

/// Provides the canonical 20 Today I Learned notes from the repository,
/// plus search, topic filtering, and daily spotlight selection.
class TilRepository {
  const TilRepository._();

  /// Complete corpus of 20 verified TIL notes across all 6 topic areas.
  static const List<TilNote> allNotes = <TilNote>[
    // -------------------------------------------------------------------------
    // 1. johnny-decimal/ (7 notes)
    // -------------------------------------------------------------------------
    TilNote(
      slug: 'areas',
      topic: TilTopic.johnnyDecimal,
      title: 'The home areas are the Johnny Decimal system',
      date: '2026-10-26',
      summary:
          'These directories live in the Termux home and are linked from `/root`. New files go in one of them.',
      details:
          'A category inside an area is `AC_name`. `10_DEV/11_PROJECTS` is category 11. Do not nest another `00_INBOX` inside a project. A new top-level area needs a number, a row in this table, and a symlink in `/root`.',
      keyCommandOrRule: '10_DEV/11_PROJECTS',
      table: TilTableData(
        headers: <String>['Directory', 'What goes here'],
        rows: <List<String>>[
          <String>['00_INBOX', 'Landing zone. Sort it.'],
          <String>['10_DEV', 'Code. One directory per project.'],
          <String>['20_MEDIA', 'Media you made.'],
          <String>['30_DOCS', 'Notes and references.'],
          <String>['40_BUSINESS', 'Business paperwork (`40_BUSINESS/ebay/`).'],
          <String>['50_OPS', 'sshd, wake-lock, Termux:X11, and service scripts.'],
          <String>['55_INFRA', 'Dotfiles and config you would copy onto a new phone.'],
          <String>['60_TEMPLATES', 'Reusable templates.'],
          <String>['70_BACKUP', 'Small dated backups.'],
          <String>['80_ARCHIVE', 'Cold storage (`80_ARCHIVE/debian.tar`).'],
          <String>['90_VAULT', 'Secrets. Mode 700.'],
          <String>['91_OBSIDIAN', 'Obsidian vaults. Added 2026-10-27.'],
        ],
      ),
      tags: <String>['00_INBOX', '10_DEV', '55_INFRA', '90_VAULT', '91_OBSIDIAN'],
    ),
    TilNote(
      slug: 'category-11-projects',
      topic: TilTopic.johnnyDecimal,
      title: 'Project repos go in 10_DEV/11_PROJECTS',
      date: '2026-10-26',
      summary:
          '`11_PROJECTS` is category 11 of area 10. This notes repo is `10_DEV/11_PROJECTS/today-i-learned`.',
      details:
          'The remote is `https://github.com/longdenjay00-sketch/today-i-learned`, branch `main`. A note is `<topic>/<slug>.md`: a title, the date, and one fact.',
      keyCommandOrRule: '10_DEV/11_PROJECTS/today-i-learned',
      tags: <String>['11_PROJECTS', 'today-i-learned', '<topic>/<slug>.md'],
    ),
    TilNote(
      slug: 'dotfiles',
      topic: TilTopic.johnnyDecimal,
      title: 'Kali dotfiles live in 55_INFRA',
      date: '2026-10-26',
      summary:
          'The live Kali dotfiles are `55_INFRA/dotfiles/`. `/root/dotfiles` is a symlink to that directory.',
      details:
          '`/root/.bashrc`, `/root/.ssh`, `/root/.git`, and the other hidden names are also links into `55_INFRA/dotfiles/`. Leave those links. The shell, SSH, and git need them. Older copies in the same area are `termux-dotfiles`, `dotfiles-from-dev`, `dotfiles-from-inbox`, and `kali-dotfiles`.',
      keyCommandOrRule: '55_INFRA/dotfiles/',
      tags: <String>['55_INFRA/dotfiles/', '/root/dotfiles', '/root/.ssh'],
    ),
    TilNote(
      slug: 'host-paths',
      topic: TilTopic.johnnyDecimal,
      title: 'Host paths after the move',
      date: '2026-10-26',
      summary:
          'These paths resolve. The old `/root/DEV`, `/root/DOC`, `/root/INB`, `/root/OPS`, `/root/dotfiles` directory, and `/root/home` names do not.',
      details:
          'Every active operational path maps cleanly into its numbered Johnny Decimal area.',
      keyCommandOrRule: '55_INFRA/dotfiles/.ssh/config',
      table: TilTableData(
        headers: <String>['What', 'Path'],
        rows: <List<String>>[
          <String>['Phone SSH notes', '30_DOCS/reconnect-termux.md'],
          <String>['SSH config', '55_INFRA/dotfiles/.ssh/config'],
          <String>['Repair scripts', '50_OPS/fix-termux-ssh.sh'],
          <String>['Spare SSH backup', '90_VAULT/ssh-backup'],
          <String>['X11 notes', '30_DOCS/x11.md'],
          <String>['Firefox profile', '55_INFRA/dotfiles/.mozilla/firefox/py.default'],
          <String>['YouTube editor', '10_DEV/turtle_edit/turtle_youtube.py'],
          <String>['Finished clips', '20_MEDIA'],
          <String>['eBay catalog', '40_BUSINESS/ebay/'],
          <String>['Rootfs tarball', '80_ARCHIVE/debian.tar'],
        ],
      ),
      tags: <String>['30_DOCS', '50_OPS', '90_VAULT', '80_ARCHIVE'],
    ),
    TilNote(
      slug: 'morpheus',
      topic: TilTopic.johnnyDecimal,
      title: 'Morpheus is the Kali guide',
      date: '2026-10-26',
      summary:
          'The agent rules are `30_DOCS/AGENTS.md`. They name Morpheus and tell him to file new work in the Johnny Decimal areas.',
      details:
          '`~/.grok/personas/Morpheus.toml` uses the same role. The layout map is `30_DOCS/LAYOUT.md`.',
      keyCommandOrRule: '30_DOCS/AGENTS.md',
      tags: <String>['30_DOCS/AGENTS.md', 'Morpheus.toml', '30_DOCS/LAYOUT.md'],
    ),
    TilNote(
      slug: 'old-short-names',
      topic: TilTopic.johnnyDecimal,
      title: 'The three-letter directory names are gone',
      date: '2026-10-26',
      summary:
          '`INB`, `DEV`, `MED`, `DOC`, `BUS`, `OPS`, `BAK`, `ARC`, `VAU`, `TEM`, `PRO`, `OUT`, and `INF` are not on the home listing. Their contents were moved, then the short names were removed.',
      details:
          '`TEM` was scratch, not templates. `~/bin` was removed. `~/.local/bin` is on the Termux bash `PATH`.',
      keyCommandOrRule: '~/.local/bin',
      table: TilTableData(
        headers: <String>['Was', 'Now'],
        rows: <List<String>>[
          <String>['INB', '00_INBOX'],
          <String>['DEV', '10_DEV'],
          <String>['MED / OUT', '20_MEDIA'],
          <String>['DOC', '30_DOCS'],
          <String>['BUS', '40_BUSINESS'],
          <String>['OPS', '50_OPS'],
          <String>['INF', '55_INFRA'],
          <String>['BAK', '70_BACKUP'],
          <String>['ARC', '80_ARCHIVE'],
          <String>['VAU', '90_VAULT'],
        ],
      ),
      tags: <String>['00_INBOX', '10_DEV', '20_MEDIA', '~/.local/bin'],
    ),
    TilNote(
      slug: 'root-listing',
      topic: TilTopic.johnnyDecimal,
      title: '/root has no loose files',
      date: '2026-10-26',
      summary:
          '`ls /root` shows the numbered areas and `dotfiles`. `91_OBSIDIAN` is the Obsidian area, symlinked like the others. Notes, scripts, and the editor CLI are not linked from `/root` anymore.',
      details:
          '`AGENTS.md` and `LAYOUT.md` are real files in `30_DOCS`. The sshd one-liner `ssb` is in `50_OPS/ssb`. `code` is `55_INFRA/code`. `vscode_cli.tar.gz` is in `70_BACKUP`.',
      keyCommandOrRule: 'ls /root',
      tags: <String>['ls /root', '91_OBSIDIAN', '50_OPS/ssb', '55_INFRA/code'],
    ),

    // -------------------------------------------------------------------------
    // 2. termux-kali/ (5 notes)
    // -------------------------------------------------------------------------
    TilNote(
      slug: 'x11-display-socket',
      topic: TilTopic.termuxKali,
      title: 'Start Termux:X11 from PRoot with sv up tx11 and symlink X0',
      date: '2026-10-23',
      summary:
          'Inside the Kali PRoot container, start the host X server with `SVDIR=/data/data/com.termux/files/usr/var/service` and `sv up tx11` rather than `am start` (which fails due to UID mismatch).',
      details:
          'The live socket `/data/data/com.termux/files/usr/tmp/.X11-unix/X0` must be symlinked into `/tmp/.X11-unix/X0` inside the PRoot guest, and X clients must run with `DISPLAY=:0`.',
      keyCommandOrRule:
          'SVDIR=/data/data/com.termux/files/usr/var/service sv up tx11',
      tags: <String>['sv up tx11', 'DISPLAY=:0', '/tmp/.X11-unix/X0'],
    ),
    TilNote(
      slug: 'firefox-proot-sandbox',
      topic: TilTopic.termuxKali,
      title:
          'Firefox ESR under Kali PRoot requires sandbox overrides on DISPLAY=:0',
      date: '2026-10-23',
      summary:
          'Firefox ESR (`/usr/bin/firefox`) runs on `DISPLAY=:0` inside the Kali PRoot guest when launched with `MOZ_FAKE_NO_SANDBOX=1`, `LIBGL_ALWAYS_SOFTWARE=1`, and `MOZ_ENABLE_WAYLAND=0`.',
      details:
          'The profile lives at `/root/55_INFRA/dotfiles/.mozilla/firefox/py.default` via the `~/.mozilla` symlink; if that symlink target is missing, Firefox shows a Profile Missing dialog.',
      keyCommandOrRule:
          'DISPLAY=:0 MOZ_FAKE_NO_SANDBOX=1 LIBGL_ALWAYS_SOFTWARE=1 MOZ_ENABLE_WAYLAND=0 firefox',
      tags: <String>[
        'MOZ_FAKE_NO_SANDBOX=1',
        'LIBGL_ALWAYS_SOFTWARE=1',
        'MOZ_ENABLE_WAYLAND=0',
      ],
    ),
    TilNote(
      slug: 'ssh-termux-dhcp-sweep',
      topic: TilTopic.termuxKali,
      title: 'Find the Termux SSH host after a DHCP change with Python connect_ex',
      date: '2026-10-26',
      summary:
          'Inside this Kali PRoot container, a bash `/dev/tcp` subnet sweep prints nothing when scanning for the phone\'s `sshd` on port `8022`.',
      details:
          'Use a Python `socket.connect_ex((ip, 8022))` sweep across `192.168.0.0/24` to locate the phone, then update `HostName` under `Host termux` in `~/.ssh/config` (`/root/55_INFRA/dotfiles/.ssh/config`).',
      keyCommandOrRule: 'socket.connect_ex((ip, 8022))',
      tags: <String>['socket.connect_ex', 'port 8022', '~/.ssh/config'],
    ),
    TilNote(
      slug: 'termux-runsv-sshd-down-file',
      topic: TilTopic.termuxKali,
      title:
          'Termux runsv keeps sshd stopped when a down trigger file is present',
      date: '2026-10-30',
      summary:
          'When runsvdir supervises Termux services, sshd stays down if a file named down exists in its service directory: /data/data/com.termux/files/usr/var/service/sshd/down.',
      details:
          'Clear the down file or start the service with `sv-enable sshd` (or `SVDIR=/data/data/com.termux/files/usr/var/service sv up sshd`), and inspect local Wi-Fi addresses via `ip addr show wlan0` to detect DHCP lease changes.',
      keyCommandOrRule: 'sv-enable sshd',
      tags: <String>['runsv', 'sshd', 'down file', 'sv-enable', 'wlan0'],
    ),
    TilNote(
      slug: 'esbuild-allow-scripts',
      topic: TilTopic.termuxKali,
      title: 'Allow esbuild postinstall scripts under npm 12 on aarch64',
      date: '2026-10-24',
      summary:
          'When npm 12 blocks the `esbuild` postinstall script via `allowScripts`, Vite and bundler installs can fail if the native binary is not linked.',
      details:
          'Re-enable it for the user profile with `npm config set allow-scripts=esbuild --location=user` or per-install with `npm install -g --allow-scripts=esbuild`.',
      keyCommandOrRule: 'npm config set allow-scripts=esbuild --location=user',
      tags: <String>['esbuild', 'allow-scripts', 'aarch64', 'npm 12'],
    ),
    TilNote(
      slug: 'android-tools-installed',
      topic: TilTopic.termuxKali,
      title: 'Installed Android tools vs repo-only packages on Kali PRoot',
      date: '2026-10-22',
      summary:
          'This Kali Rolling `aarch64` container has `/usr/bin/adb` (`1:34.0.5-13`), `aapt`, `aapt2`, `scrcpy`, `waydroid`, `androidbackup2john`, and `androidfde2john` installed out of the box.',
      details:
          'Reverse-engineering and flashing utilities (`jadx`, `apktool`, `dex2jar`, `androguard`, `apksigner`, `fastboot`) are available in the `kali-rolling` APT repositories but are not pre-installed.',
      keyCommandOrRule: 'apt install jadx apktool dex2jar fastboot',
      tags: <String>['adb', 'scrcpy', 'jadx', 'apktool', 'kali-rolling'],
    ),

    // -------------------------------------------------------------------------
    // 3. conduit-bending/ (3 notes)
    // -------------------------------------------------------------------------
    TilNote(
      slug: 'take-up-and-stub',
      topic: TilTopic.conduitBending,
      title: 'EMT hand-bender take-up is 5 in., 6 in., and 8 in.',
      date: '2026-10-25',
      summary:
          'On a 90° EMT stub-up, subtract take-up from the target stub height (`mark = height - take-up`). Standard take-up is `5 in.` for `1/2 in.` EMT, `6 in.` for `3/4 in.` EMT, and `8 in.` for `1 in.` EMT.',
      details:
          'The take-up number stamped on the physical shoe in the lab room always overrides the default chart.',
      keyCommandOrRule: 'mark = height - take_up (5", 6", 8")',
      tags: <String>['90° stub-up', '1/2 in. = 5"', '3/4 in. = 6"', '1 in. = 8"'],
    ),
    TilNote(
      slug: 'offset-multipliers-and-shrink',
      topic: TilTopic.conduitBending,
      title: 'EMT offset multipliers and shrink per inch of depth',
      date: '2026-10-25',
      summary:
          'For a two-bend EMT offset, add shrink to the distance to the obstacle to place the far mark, then step back by `depth × multiplier` for the near mark.',
      details:
          'At `30°`, the multiplier is `×2` and shrink is `1/4 in.` per inch of depth (e.g., a `6 in.` rise at `60 in.` uses `1-1/2 in.` shrink and `12 in.` spacing, placing marks at `61-1/2 in.` and `49-1/2 in.`).',
      keyCommandOrRule: '30° Offset: Multiplier ×2 | Shrink 1/4" per inch',
      tags: <String>['30° offset', 'multiplier ×2', 'shrink 1/4 in.'],
    ),
    TilNote(
      slug: 'three-point-saddle-and-360-budget',
      topic: TilTopic.conduitBending,
      title: 'Three-point saddle layout and the NEC 358.26 360-degree bend budget',
      date: '2026-10-25',
      summary:
          'A three-point saddle places the `45°` center bend on the rim notch (teardrop), advanced ahead of the obstacle center by `3/16 in.` per inch of depth, with `22.5°` wing marks spaced `2-1/2 in.` per inch of depth on each side.',
      details:
          'Under NEC `358.26`, a conduit run may not exceed `360°` of total bends between pull points (boxes or conduit bodies), and offsets and factory elbows count toward that total.',
      keyCommandOrRule: 'NEC 358.26 Max Bends ≤ 360° | Center +3/16"/in, Wings 2.5"/in',
      tags: <String>['NEC 358.26', '360° budget', '3-point saddle', '45° / 22.5°'],
    ),

    // -------------------------------------------------------------------------
    // 4. electrician/ (1 note)
    // -------------------------------------------------------------------------
    TilNote(
      slug: 'nec-chapter-9-table-1-fill',
      topic: TilTopic.electrician,
      title: 'NEC Chapter 9 Table 1 conduit fill percentages and nipple rule',
      date: '2026-10-18',
      summary:
          'NEC Chapter 9, Table 1 limits raceway cross-sectional fill to `53%` for one conductor, `31%` for two conductors, and `40%` for three or more conductors.',
      details:
          'A conduit nipple `24 in.` (`600 mm`) or shorter between enclosures may be filled to `60%`, equipment grounding conductors count toward fill, and same-size maximum conductor calculations round up when the decimal is `0.8` or greater.',
      keyCommandOrRule: '1 cond: 53% | 2 cond: 31% | 3+ cond: 40% | Nipple ≤24": 60%',
      tags: <String>['NEC Ch. 9 Table 1', '53% / 31% / 40%', '60% nipple rule'],
    ),

    // -------------------------------------------------------------------------
    // 5. ai-harnesses/ (6 notes)
    // -------------------------------------------------------------------------
    TilNote(
      slug: 'fifty-repos-developer-roadmap',
      topic: TilTopic.aiHarnesses,
      title: 'The 50-Repo Developer Roadmap from Foundational CLI to Industrial PRoot Construct',
      date: '2026-10-29',
      summary:
          'A master architecture map organizing 50 essential developer repositories across 5 escalating tiers: Foundations, Operations, Advanced Systems, Industrial Cyber-Physical, and our host Kali PRoot / Termux construct.',
      details:
          'Tier 1 covers Foundations (Dotfiles, TIL, CLIs, Rust engines, Web, Mobile APK, Trade Math). Tier 2 handles Operations (Containers, Red Team, FFmpeg, SQLite, IoT). Tier 3 covers Advanced Systems & Agents. Tier 4 reaches Industrial SCADA & Robotics Kinematics. Tier 5 unlocks host/guest PRoot bridges and ARM64 tooling.',
      keyCommandOrRule: '10_DEV/11_PROJECTS/today-i-learned/ai-harnesses/fifty-repos-developer-roadmap.md',
      tags: <String>['roadmap', '50-repos', 'architecture', 'construct'],
    ),
    TilNote(
      slug: 'agy-termux-proot-wrapper',
      topic: TilTopic.aiHarnesses,
      title: 'Bridge glibc agy into Termux via proot-distro login wrapper',
      date: '2026-10-28',
      summary:
          'Because `/usr/local/bin/agy` inside the Kali rootfs is a `glibc` `aarch64` ELF executable (`/lib/ld-linux-aarch64.so.1`), it cannot execute directly under Termux\'s `bionic` libc.',
      details:
          'Create `/root/50_OPS/agy-termux` (`chmod 755`) wrapping `proot-distro login debian --work-dir "\$WORKDIR" -- /usr/local/bin/agy "\$@"` and symlink it to `/data/data/com.termux/files/usr/bin/agy` so `agy` runs seamlessly from any Termux shell.',
      keyCommandOrRule:
          'ln -s /data/data/com.termux/files/home/50_OPS/agy-termux \$PREFIX/bin/agy',
      tags: <String>['agy-termux', 'proot-distro', 'glibc', 'bionic'],
    ),
    TilNote(
      slug: 'flutter-til-widget-architecture',
      topic: TilTopic.aiHarnesses,
      title: 'Dual Bento Grid and Swipe Deck layout in TodayILearnedWidget',
      date: '2026-10-28',
      summary:
          '`lib/widgets/today_i_learned_widget.dart` renders `<topic>/<slug>.md` notes in two switchable views: a responsive `SliverLayoutBuilder` Bento Grid (`1`–`3` columns) and a horizontal `PageView.builder` Swipe Deck (`viewportFraction: 0.88`).',
      details:
          '`TilNote.fromMarkdown` extracts the `# Title`, `YYYY-MM-DD` date, Markdown pipe tables (`TilTableData`), and longest inline backtick code span for one-tap clipboard copying.',
      keyCommandOrRule: 'flutter test test/today_i_learned_widget_test.dart',
      tags: <String>['TodayILearnedWidget', 'SliverLayoutBuilder', 'TilNote'],
    ),
    TilNote(
      slug: 'grok-headless-imagine',
      topic: TilTopic.aiHarnesses,
      title: 'Run Grok in headless mode with GenerateImage for 16:9 hero banners',
      date: '2026-10-28',
      summary:
          'Grok Build can execute non-interactively from scripts or another agent harness via `grok --always-approve -p "<prompt>"`.',
      details:
          'Passing an explicit file-save prompt to headless Grok invokes its `GenerateImage` (`image_gen`) tool and writes 16:9 (`1280x720`) hero assets directly to disk without launching the fullscreen TUI.',
      keyCommandOrRule: 'grok --always-approve -p "<prompt>"',
      tags: <String>['grok --always-approve', 'GenerateImage', '1280x720'],
    ),
    TilNote(
      slug: 'installed-coding-clis',
      topic: TilTopic.aiHarnesses,
      title: 'Install paths for agy, grok, opencode, and codex on this host',
      date: '2026-10-21',
      summary:
          'Google Antigravity (`agy` 1.4.3) is installed at `/usr/local/bin/agy`, Grok CLI lives at `/root/.grok/bin/grok`, OpenCode (`v2.1.1`) lives in `/root/.opencode/bin/opencode` (symlinked into `/usr/local/bin`), and Codex (`0.163.0`) links from `/root/.codex/packages/standalone/current/bin/codex`.',
      details:
          'All three active harnesses (`agy`, `grok`, `opencode`) read `/root/AGENTS.md` to adopt the Morpheus operator persona.',
      keyCommandOrRule: '/usr/local/bin/agy | /root/.grok/bin/grok | /usr/local/bin/opencode',
      tags: <String>['agy', 'grok', 'opencode', 'codex', '/root/AGENTS.md'],
    ),
    TilNote(
      slug: 'local-lfm25-gguf-cache',
      topic: TilTopic.aiHarnesses,
      title: 'Offline GGUF inference with hf download and llama-cli',
      date: '2026-10-20',
      summary:
          'Download a single GGUF quantization for offline `llama.cpp` inference without pulling the entire repository using `hf download LiquidAI/LFM2.5-1.2B-Instruct-GGUF --include LFM2.5-1.2B-Instruct-Q4_K_M.gguf`.',
      details:
          'The `698 MiB` model caches under `/root/.cache/huggingface/hub/` and runs locally via `llama-cli -m <snapshot-path> -c 2048 -t 4 -cnv`.',
      keyCommandOrRule:
          'hf download LiquidAI/LFM2.5-1.2B-Instruct-GGUF --include LFM2.5-1.2B-Instruct-Q4_K_M.gguf',
      tags: <String>['hf download', 'llama-cli', 'GGUF', 'LFM2.5-1.2B'],
    ),

    // -------------------------------------------------------------------------
    // 6. turbo-the-turtle/ (1 note)
    // -------------------------------------------------------------------------
    TilNote(
      slug: 'ffmpeg-lanczos-rotation-fix',
      topic: TilTopic.turboTheTurtle,
      title: 'Re-encode upside-down phone video clips in ffmpeg to bake rotation',
      date: '2026-10-24',
      summary:
          'Phone clips recorded with a `-180°` display matrix (such as `baby-fishey-dance-magic-show.mp4`) can open upside down in raw frame tools unless re-encoded so the rotation metadata is baked into the pixel stream.',
      details:
          '`10_DEV/turtle_edit/turtle_youtube.py` compiles, pads (`1920x1080`), and scales Turbo the Turtle and Fishy clips using `ffmpeg` Lanczos without requiring an AI upscaler.',
      keyCommandOrRule: 'python3 10_DEV/turtle_edit/turtle_youtube.py',
      tags: <String>['ffmpeg', 'lanczos', '1920x1080', 'turtle_youtube.py'],
    ),
  ];

  /// Returns notes matching the optional [topic], [searchQuery], and [bookmarkedSlugs].
  static List<TilNote> filter({
    TilTopic? topic,
    String searchQuery = '',
    Set<String>? bookmarkedSlugs,
    bool onlyBookmarked = false,
  }) {
    final normalizedQuery = searchQuery.trim().toLowerCase();

    return allNotes.where((note) {
      if (topic != null && note.topic != topic) {
        return false;
      }
      if (onlyBookmarked &&
          (bookmarkedSlugs == null || !bookmarkedSlugs.contains(note.slug))) {
        return false;
      }
      if (normalizedQuery.isEmpty) {
        return true;
      }
      final searchableText = <String>[
        note.title,
        note.summary,
        note.details,
        note.topic.label,
        note.topic.id,
        note.slug,
        note.date,
        if (note.keyCommandOrRule != null) note.keyCommandOrRule!,
        ...note.tags,
      ].join(' ').toLowerCase();

      return searchableText.contains(normalizedQuery);
    }).toList();
  }

  /// Counts how many notes belong to each [TilTopic].
  static Map<TilTopic, int> countByTopic() {
    final counts = <TilTopic, int>{
      for (final topic in TilTopic.values) topic: 0,
    };
    for (final note in allNotes) {
      counts[note.topic] = (counts[note.topic] ?? 0) + 1;
    }
    return counts;
  }

  /// Deterministically picks a "Daily Spotlight" note for a given [date].
  static TilNote spotlightForDate(DateTime date) {
    final daySeed = date.year * 1000 + date.month * 31 + date.day;
    return allNotes[daySeed % allNotes.length];
  }
}
