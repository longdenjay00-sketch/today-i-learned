# Dual Bento Grid and Swipe Deck layout in TodayILearnedWidget

2026-10-28

`lib/widgets/today_i_learned_widget.dart` renders `<topic>/<slug>.md` notes in two switchable views: a responsive `SliverLayoutBuilder` Bento Grid (`1` column `<680px`, `2` columns `680–1099px`, `3` columns `>=1100px`) and a horizontal `PageView.builder` Swipe Deck (`viewportFraction: 0.88`).

`TilNote.fromMarkdown` extracts the `# Title`, `YYYY-MM-DD` date, Markdown pipe tables (`TilTableData`), and longest inline backtick code span for one-tap clipboard copying.
