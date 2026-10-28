import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:today_i_learned/today_i_learned.dart';

void main() {
  group('TilRepository & TilNote domain tests', () {
    test('contains all 20 canonical notes across 6 topics', () {
      expect(TilRepository.allNotes.length, 20);
      final counts = TilRepository.countByTopic();
      expect(counts[TilTopic.johnnyDecimal], 7);
      expect(counts[TilTopic.termuxKali], 5);
      expect(counts[TilTopic.conduitBending], 3);
      expect(counts[TilTopic.electrician], 1);
      expect(counts[TilTopic.aiHarnesses], 3);
      expect(counts[TilTopic.turboTheTurtle], 1);
    });

    test('parses and serializes canonical <topic>/<slug>.md markdown', () {
      const sampleMarkdown = '''
# EMT hand-bender take-up is 5 in., 6 in., and 8 in.

2026-10-25

On a 90° EMT stub-up, subtract take-up from the target stub height (`mark = height - take-up`).
''';
      final note = TilNote.fromMarkdown(
        topicFolder: 'conduit-bending',
        slug: 'take-up-and-stub',
        rawMarkdown: sampleMarkdown,
      );

      expect(note.topic, TilTopic.conduitBending);
      expect(note.relativePath, 'conduit-bending/take-up-and-stub.md');
      expect(note.date, '2026-10-25');
      expect(note.keyCommandOrRule, 'mark = height - take-up');
      expect(note.toMarkdown(), contains('# EMT hand-bender take-up'));
    });
  });

  group('TodayILearnedWidget UI tests', () {
    testWidgets('renders hero header, topic chips, and filters notes by search',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: TodayILearnedWidget(),
          ),
        ),
      );

      expect(find.text('Today I Learned'), findsOneWidget);
      expect(find.text('20 NOTES'), findsOneWidget);
      expect(find.text('All Topics'), findsOneWidget);

      // Search for a specific NEC rule
      await tester.enterText(
        find.byKey(const Key('til_search_field')),
        '358.26',
      );
      await tester.pumpAndSettle();

      expect(
        find.textContaining('Three-point saddle layout'),
        findsOneWidget,
      );
    });
  });
}
