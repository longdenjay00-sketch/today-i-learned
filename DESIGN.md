# Design System & Mass-Appeal UX (`DESIGN.md`)

`TodayILearnedWidget` is crafted to make technical micro-notes feel as engaging, scannable, and rewarding as a modern consumer discovery feed while preserving high-density terminal and trade accuracy.

---

## 1. Design Philosophy: "Obsidian & Neon"

Technical notes often fail to appeal to a broad audience because they look like walls of raw plain text. To bridge the gap between **power-user precision** and **mass-market delight**, `TodayILearnedWidget` applies three core principles:

1. **Bite-Sized Visual Hierarchy:** Every card strictly separates **Context** (Topic pill + ISO Date), **Core Insight** (2-line bold headline + 3-line summary), and **Actionable Artifact** (1-tap monospace command/formula bar).
2. **Tactile Micro-Rewards:** Marking a note as *Learned* (`Check`) immediately illuminates the card border with its category accent color and increments the live **Mastery Progress Bar** in the hero header.
3. **Zero-Friction Discovery:** Users can either scan a responsive **Bento Grid**, flip through a **Swipeable Card Deck**, or tap **Surprise Me (`Shuffle`)** to surface a random insight.

---

## 2. Color Palette & Semantic Tokens

### Core Surfaces
| Token Role | Hex | Preview Description |
| :--- | :--- | :--- |
| **Canvas Background** | `#090D16` | Deep Obsidian Midnight |
| **Card Surface Primary** | `#1E293B` | Elevated Slate (85–90% alpha gradient) |
| **Card Surface Secondary** | `#0F172A` | Deep Navy Slate |
| **Terminal Pill Surface** | `#090D16` | Pure Code Contrast Well |
| **Subtle Border** | `#334155` | 1px Hairline Divider |

### Category Neon Accents (`TilTopic`)
Each topic folder in the repository is assigned a distinct high-contrast neon accent so users recognize the subject domain before reading a single word:

| Topic Folder | Emoji | Primary Accent | Secondary Accent | Visual Association |
| :--- | :---: | :--- | :--- | :--- |
| `johnny-decimal/` | 🗂️ | `#00E676` (Matrix Emerald) | `#00BFA5` | Ordered filesystem spine |
| `termux-kali/` | 🐉 | `#00B0FF` (Kali Cyan) | `#2979FF` | Linux kernel & X11 sockets |
| `conduit-bending/` | 🔧 | `#FF9100` (Safety Amber) | `#FF6D00` | Jobsite EMT benders & layout |
| `electrician/` | ⚡ | `#FFD600` (Arc Gold) | `#FFAB00` | High-voltage NEC code rules |
| `ai-harnesses/` | 🤖 | `#D500F9` (Neural Magenta) | `#651FFF` | Agentic harnesses (`agy`, `Grok`) |
| `turbo-the-turtle/` | 🐢 | `#1DE9B6` (Aqua Mint) | `#00BFA5` | Video pipelines & `ffmpeg` |

---

## 3. Typography Scale

| Element | Size | Weight | Color | Tracking / Line Height |
| :--- | :--- | :--- | :--- | :--- |
| **Hero Title** | `24sp` | `w800` (ExtraBold) | `#FFFFFF` | `-0.5` letter spacing |
| **Modal Sheet Headline** | `22sp` | `w800` (ExtraBold) | `#FFFFFF` | `1.25` line height |
| **Card Headline** | `16.5sp` | `w800` (ExtraBold) | `#FFFFFF` | `1.25` line height (max 2 lines) |
| **Card Body Summary** | `13.5sp` | `w400` (Regular) | `#CBD5E1` | `1.45` line height |
| **Terminal / Formula Pill** | `12sp` | `w600` (SemiBold) | `#E2E8F0` | `monospace` family |
| **Topic Badge & Counters** | `11sp` | `w800` (ExtraBold) | Topic Accent | `+0.3` letter spacing |

---

## 4. Component Anatomy & Layout Breakpoints

### Card Anatomy (`_TilNoteCard`)
```text
┌──────────────────────────────────────────────────────────┐
│ [🗂️ johnny-decimal]  2026-10-26              (✓)   (🔖) │ ← Metadata & Mastery Bar
│                                                          │
│ Project repos go in 10_DEV/11_PROJECTS                   │ ← Bold 2-line Headline
│                                                          │
│ `11_PROJECTS` is category 11 of area 10. This notes repo │ ← Scannable Summary
│ is `10_DEV/11_PROJECTS/today-i-learned`.                 │
│                                                          │
│ ┌──────────────────────────────────────────────────────┐ │
│ │ >_  10_DEV/11_PROJECTS/today-i-learned          [📋] │ │ ← 1-Tap Copy Terminal Pill
│ └──────────────────────────────────────────────────────┘ │
└──────────────────────────────────────────────────────────┘
```

### Responsive Viewport Adaptation
- **Compact (`< 680px`):** Single-column Bento feed or full-width Swipe Deck; ideal for portrait mobile use.
- **Medium (`680px – 1099px`):** 2-column Bento grid; tailored for our `BYYBUO SmartPad T10` tablet in landscape and `Termux:X11` windows.
- **Expanded (`>= 1100px`):** 3-column Bento grid with balanced aspect ratios for desktop browsers and external monitors.
