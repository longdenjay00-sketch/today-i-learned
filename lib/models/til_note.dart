import 'package:flutter/material.dart';

/// Represents one of the six domain categories in the Today I Learned corpus.
enum TilTopic {
  johnnyDecimal(
    id: 'johnny-decimal',
    label: 'Johnny Decimal',
    subtitle: 'System Spine & Filesystem Layout',
    emoji: '🗂️',
    icon: Icons.account_tree_rounded,
    accentColor: Color(0xFF00E676),
    secondaryColor: Color(0xFF00BFA5),
  ),
  termuxKali(
    id: 'termux-kali',
    label: 'Termux & Kali',
    subtitle: 'Android Host, PRoot Guest & X11',
    emoji: '🐉',
    icon: Icons.terminal_rounded,
    accentColor: Color(0xFF00B0FF),
    secondaryColor: Color(0xFF2979FF),
  ),
  conduitBending(
    id: 'conduit-bending',
    label: 'Conduit Bending',
    subtitle: 'EMT Hand-Bender Math & NEC 358',
    emoji: '🔧',
    icon: Icons.architecture_rounded,
    accentColor: Color(0xFFFF9100),
    secondaryColor: Color(0xFFFF6D00),
  ),
  electrician(
    id: 'electrician',
    label: 'Electrician',
    subtitle: 'NEC Chapter 9 & Trade Curriculum',
    emoji: '⚡',
    icon: Icons.bolt_rounded,
    accentColor: Color(0xFFFFD600),
    secondaryColor: Color(0xFFFFAB00),
  ),
  aiHarnesses(
    id: 'ai-harnesses',
    label: 'AI Harnesses',
    subtitle: 'Antigravity (agy), Grok, OpenCode & Local Models',
    emoji: '🤖',
    icon: Icons.auto_awesome_rounded,
    accentColor: Color(0xFFD500F9),
    secondaryColor: Color(0xFF651FFF),
  ),
  turboTheTurtle(
    id: 'turbo-the-turtle',
    label: 'Turbo the Turtle',
    subtitle: 'Media Pipeline & ffmpeg',
    emoji: '🐢',
    icon: Icons.movie_filter_rounded,
    accentColor: Color(0xFF1DE9B6),
    secondaryColor: Color(0xFF00BFA5),
  );

  const TilTopic({
    required this.id,
    required this.label,
    required this.subtitle,
    required this.emoji,
    required this.icon,
    required this.accentColor,
    required this.secondaryColor,
  });

  final String id;
  final String label;
  final String subtitle;
  final String emoji;
  final IconData icon;
  final Color accentColor;
  final Color secondaryColor;

  /// Resolves a [TilTopic] from its directory slug (e.g. `termux-kali`).
  static TilTopic fromFolder(String folder) {
    return TilTopic.values.firstWhere(
      (t) => t.id == folder.trim().toLowerCase(),
      orElse: () => TilTopic.johnnyDecimal,
    );
  }
}

/// Optional markdown table extracted from a TIL note.
class TilTableData {
  const TilTableData({
    required this.headers,
    required this.rows,
  });

  final List<String> headers;
  final List<List<String>> rows;
}

/// Immutable domain model representing a single Today I Learned note.
///
/// Follows the canonical `<topic>/<slug>.md` specification:
/// - Line 1: `# Title`
/// - Line 3: `YYYY-MM-DD`
/// - Body: Distilled factual paragraphs, inline commands/paths, and optional tables.
class TilNote {
  const TilNote({
    required this.slug,
    required this.topic,
    required this.title,
    required this.date,
    required this.summary,
    required this.details,
    this.keyCommandOrRule,
    this.table,
    this.tags = const <String>[],
  });

  /// File name without `.md`, e.g., `firefox-proot-sandbox`.
  final String slug;

  /// Category folder to which this note belongs.
  final TilTopic topic;

  /// Distilled headline of what was learned.
  final String title;

  /// ISO 8601 date string (`YYYY-MM-DD`) when the fact was recorded.
  final String date;

  /// Primary paragraph explaining the core fact.
  final String summary;

  /// Secondary paragraph or deeper operational nuance.
  final String details;

  /// Primary CLI command, formula, or path highlighted for one-tap copying.
  final String? keyCommandOrRule;

  /// Optional structured reference table (such as Johnny Decimal area mappings).
  final TilTableData? table;

  /// Searchable keywords and tokens extracted from the note.
  final List<String> tags;

  /// Canonical relative path in the repository (`<topic>/<slug>.md`).
  String get relativePath => '${topic.id}/$slug.md';

  /// Estimated reading time in seconds for micro-learning badges.
  int get estimatedReadSeconds {
    final wordCount = '$title $summary $details'.split(RegExp(r'\s+')).length;
    return ((wordCount / 3.2).round()).clamp(15, 90);
  }

  /// Parses raw Markdown matching the `<topic>/<slug>.md` convention into a [TilNote].
  factory TilNote.fromMarkdown({
    required String topicFolder,
    required String slug,
    required String rawMarkdown,
  }) {
    final topic = TilTopic.fromFolder(topicFolder);
    final lines = rawMarkdown
        .split('\n')
        .map((l) => l.trimRight())
        .toList();

    String title = slug;
    String date = '2026-10-28';
    final List<String> paragraphs = <String>[];
    final List<String> tableLines = <String>[];

    for (final line in lines) {
      final trimmed = line.trim();
      if (trimmed.isEmpty) continue;
      if (trimmed.startsWith('# ')) {
        title = trimmed.substring(2).trim();
      } else if (RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(trimmed)) {
        date = trimmed;
      } else if (trimmed.startsWith('|') && trimmed.endsWith('|')) {
        tableLines.add(trimmed);
      } else {
        paragraphs.add(trimmed);
      }
    }

    TilTableData? parsedTable;
    if (tableLines.length >= 3) {
      List<String> splitRow(String row) => row
          .substring(1, row.length - 1)
          .split('|')
          .map((c) => c.trim())
          .toList();

      final headers = splitRow(tableLines.first);
      final rows = tableLines.skip(2).map(splitRow).toList();
      parsedTable = TilTableData(headers: headers, rows: rows);
    }

    // Extract the longest inline backtick code span as the featured command/rule
    final codeMatches = RegExp(r'`([^`]+)`')
        .allMatches(rawMarkdown)
        .map((m) => m.group(1)!)
        .toList();
    String? keyCommand;
    if (codeMatches.isNotEmpty) {
      codeMatches.sort((a, b) => b.length.compareTo(a.length));
      keyCommand = codeMatches.first;
    }

    return TilNote(
      slug: slug,
      topic: topic,
      title: title,
      date: date,
      summary: paragraphs.isNotEmpty ? paragraphs.first : title,
      details: paragraphs.length > 1 ? paragraphs.skip(1).join('\n\n') : '',
      keyCommandOrRule: keyCommand,
      table: parsedTable,
      tags: codeMatches.take(5).toList(),
    );
  }

  /// Generates the canonical `<topic>/<slug>.md` markdown representation.
  String toMarkdown() {
    final buffer = StringBuffer()
      ..writeln('# $title')
      ..writeln()
      ..writeln(date)
      ..writeln()
      ..writeln(summary);

    if (table != null) {
      buffer.writeln();
      buffer.writeln('| ${table!.headers.join(' | ')} |');
      buffer.writeln('|${List.filled(table!.headers.length, '---').join('|')}|');
      for (final row in table!.rows) {
        buffer.writeln('| ${row.join(' | ')} |');
      }
    }

    if (details.isNotEmpty) {
      buffer
        ..writeln()
        ..writeln(details);
    }

    return buffer.toString();
  }
}
