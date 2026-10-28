# Flutter Architecture & Developer Guide (`FLUTTER.md`)

This document explains the architecture, widget lifecycle, data layer, and runtime workflows for the `today_i_learned` Flutter package located in `10_DEV/11_PROJECTS/today-i-learned`.

---

## 1. Package Layout

```text
10_DEV/11_PROJECTS/today-i-learned/
├── pubspec.yaml                          # Flutter SDK config & asset bundle declarations
├── analysis_options.yaml                 # Strict flutter_lints ruleset
├── lib/
│   ├── main.dart                         # Standalone Material 3 dark-theme showcase entry point
│   ├── today_i_learned.dart              # Public barrel export for embedding in external apps
│   ├── models/
│   │   └── til_note.dart                 # Immutable TilNote, TilTopic enum, & Markdown parser
│   ├── data/
│   │   └── til_repository.dart           # Canonical 20-note corpus, search & spotlight engine
│   └── widgets/
│       └── today_i_learned_widget.dart   # TodayILearnedWidget, Bento Grid, Swipe Deck & Modals
└── test/
    └── today_i_learned_widget_test.dart  # Unit tests for Markdown parsing & Widget UI tests
```

---

## 2. Domain Model (`lib/models/til_note.dart`)

### `TilTopic` Enum
Every top-level folder in the repository maps to a strongly typed `TilTopic` enum value carrying its own visual identity:

| Enum Value | Folder ID | Label | Accent Color | Icon |
| :--- | :--- | :--- | :--- | :--- |
| `TilTopic.johnnyDecimal` | `johnny-decimal` | Johnny Decimal | `#00E676` | `Icons.account_tree_rounded` |
| `TilTopic.termuxKali` | `termux-kali` | Termux & Kali | `#00B0FF` | `Icons.terminal_rounded` |
| `TilTopic.conduitBending` | `conduit-bending` | Conduit Bending | `#FF9100` | `Icons.architecture_rounded` |
| `TilTopic.electrician` | `electrician` | Electrician | `#FFD600` | `Icons.bolt_rounded` |
| `TilTopic.aiHarnesses` | `ai-harnesses` | AI Harnesses | `#D500F9` | `Icons.auto_awesome_rounded` |
| `TilTopic.turboTheTurtle` | `turbo-the-turtle` | Turbo the Turtle | `#1DE9B6` | `Icons.movie_filter_rounded` |

### `TilNote` & Markdown Serialization
`TilNote` is an immutable value object with bidirectional Markdown support:
- **`TilNote.fromMarkdown({required String topicFolder, required String slug, required String rawMarkdown})`**:
  - Extracts the `# Heading` on line 1.
  - Parses the `YYYY-MM-DD` date stamp.
  - Separates Markdown pipe tables (`| Col | Col |`) into a structured `TilTableData` object so notes like `johnny-decimal/areas.md` and `johnny-decimal/host-paths.md` render native Flutter `Table` widgets inside the detail sheet.
  - Automatically extracts inline backtick code spans (`` `...` ``) to populate searchable tags and the highlighted command bar.
- **`note.toMarkdown()`**:
  - Serializes any `TilNote` back into the exact `<topic>/<slug>.md` specification.

---

## 3. `TodayILearnedWidget` API Reference

`TodayILearnedWidget` is designed as a self-contained, drop-in component that works inside any `Scaffold`, tab view, or dashboard panel.

### Constructor Parameters

| Parameter | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| `initialNotes` | `List<TilNote>` | `TilRepository.allNotes` | The list of notes to display. Defaults to all 20 repository notes. |
| `initialTopic` | `TilTopic?` | `null` | Pre-selects a single topic filter when the widget mounts. |
| `initialViewMode` | `TilViewMode` | `TilViewMode.bentoGrid` | Starts in either `TilViewMode.bentoGrid` or `TilViewMode.deck`. |
| `title` | `String` | `'Today I Learned'` | Hero banner headline text. |
| `subtitle` | `String` | `'Bite-sized engineering...'` | Hero banner subtitle text. |
| `enableComposer` | `bool` | `true` | Shows or hides the **+ New TIL** button in the hero header. |
| `onNoteSelected` | `ValueChanged<TilNote>?` | `null` | Callback invoked whenever a user opens a note card. |
| `onNoteCreated` | `ValueChanged<TilNote>?` | `null` | Callback invoked when a user submits a new note in the composer sheet. |

### Interactive Capabilities
1. **Responsive Bento Grid (`SliverLayoutBuilder`):**
   - `< 680px` (Phones / Portrait): 1 column (`childAspectRatio: 1.32`)
   - `680px – 1099px` (Tablets / Termux:X11 Landscape): 2 columns (`childAspectRatio: 1.12`)
   - `>= 1100px` (Desktop / Wide Web): 3 columns (`childAspectRatio: 1.18`)
2. **Swipeable Card Deck (`PageView.builder`):**
   - Uses `viewportFraction: 0.88` so adjacent cards peek from the left and right edges, encouraging horizontal swipe exploration.
3. **One-Tap Clipboard & Haptics:**
   - Tapping any monospace command bar copies the command (`Clipboard.setData`) and triggers `HapticFeedback.selectionClick()`.
   - Inside the detail modal sheet, tapping **Copy Raw .md** copies the complete `<topic>/<slug>.md` file contents.

---

## 4. Running & Testing on Our Construct

### Running Unit & Widget Tests
```bash
cd /root/10_DEV/11_PROJECTS/today-i-learned
flutter test
```

### Running on Termux:X11 (`DISPLAY=:0`) or Linux Desktop
Inside the Kali PRoot container, ensure the host X11 socket is active (`SVDIR=/data/data/com.termux/files/usr/var/service sv up tx11`) and run:
```bash
export DISPLAY=:0
flutter run -d linux
```

### Building for Web or Android APK
```bash
# Build a standalone Web bundle
flutter build web --release

# Build an Android split-per-ABI APK (aarch64)
flutter build apk --target-platform android-arm64
```
