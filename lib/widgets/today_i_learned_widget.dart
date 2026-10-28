import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../data/til_repository.dart';
import '../models/til_note.dart';

/// Presentation modes supported by [TodayILearnedWidget].
enum TilViewMode {
  /// Swipeable 3D-feel discovery deck for daily micro-learning.
  deck,

  /// Responsive multi-column masonry/bento grid for scanning and reference.
  bentoGrid,
}

/// A mass-appeal, drop-in Flutter widget for exploring, searching, bookmarking,
/// and composing "Today I Learned" (TIL) micro-knowledge cards.
///
/// Designed with a high-contrast "Obsidian & Neon" Material 3 aesthetic,
/// interactive inline code copying, swipeable deck & bento grid modes,
/// and an integrated `<topic>/<slug>.md` composer.
class TodayILearnedWidget extends StatefulWidget {
  const TodayILearnedWidget({
    super.key,
    this.initialNotes = TilRepository.allNotes,
    this.initialTopic,
    this.initialViewMode = TilViewMode.bentoGrid,
    this.title = 'Today I Learned',
    this.subtitle =
        'Bite-sized engineering, Linux & trade insights distilled from real sessions.',
    this.enableComposer = true,
    this.onNoteSelected,
    this.onNoteCreated,
  });

  /// Initial collection of [TilNote] entries to display.
  final List<TilNote> initialNotes;

  /// Optional topic filter applied on initial mount.
  final TilTopic? initialTopic;

  /// Initial layout mode ([TilViewMode.bentoGrid] or [TilViewMode.deck]).
  final TilViewMode initialViewMode;

  /// Headline displayed in the hero banner.
  final String title;

  /// Subtitle displayed in the hero banner.
  final String subtitle;

  /// Whether to show the "+ New TIL" button to compose `<topic>/<slug>.md` notes.
  final bool enableComposer;

  /// Callback fired when a user taps a note card.
  final ValueChanged<TilNote>? onNoteSelected;

  /// Callback fired when a user creates a new [TilNote] via the composer modal.
  final ValueChanged<TilNote>? onNoteCreated;

  @override
  State<TodayILearnedWidget> createState() => _TodayILearnedWidgetState();
}

class _TodayILearnedWidgetState extends State<TodayILearnedWidget>
    with SingleTickerProviderStateMixin {
  late List<TilNote> _notes;
  TilTopic? _selectedTopic;
  late TilViewMode _viewMode;
  String _searchQuery = '';
  bool _onlyBookmarked = false;
  final Set<String> _bookmarkedSlugs = <String>{
    'areas',
    'firefox-proot-sandbox',
    'offset-multipliers-and-shrink',
  };
  final Set<String> _masteredSlugs = <String>{
    'areas',
    'category-11-projects',
    'take-up-and-stub',
    'nec-chapter-9-table-1-fill',
    'grok-headless-imagine',
  };

  late final TextEditingController _searchController;
  late final PageController _deckPageController;
  int _currentDeckIndex = 0;

  @override
  void initState() {
    super.initState();
    _notes = List<TilNote>.from(widget.initialNotes);
    _selectedTopic = widget.initialTopic;
    _viewMode = widget.initialViewMode;
    _searchController = TextEditingController();
    _deckPageController = PageController(viewportFraction: 0.88);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _deckPageController.dispose();
    super.dispose();
  }

  List<TilNote> get _filteredNotes {
    final query = _searchQuery.trim().toLowerCase();
    return _notes.where((note) {
      if (_selectedTopic != null && note.topic != _selectedTopic) {
        return false;
      }
      if (_onlyBookmarked && !_bookmarkedSlugs.contains(note.slug)) {
        return false;
      }
      if (query.isEmpty) {
        return true;
      }
      final haystack = <String>[
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
      return haystack.contains(query);
    }).toList();
  }

  void _toggleBookmark(String slug) {
    HapticFeedback.lightImpact();
    setState(() {
      if (_bookmarkedSlugs.contains(slug)) {
        _bookmarkedSlugs.remove(slug);
      } else {
        _bookmarkedSlugs.add(slug);
      }
    });
  }

  void _toggleMastered(String slug) {
    HapticFeedback.selectionClick();
    setState(() {
      if (_masteredSlugs.contains(slug)) {
        _masteredSlugs.remove(slug);
      } else {
        _masteredSlugs.add(slug);
      }
    });
  }

  void _shuffleSpotlight() {
    final filtered = _filteredNotes;
    if (filtered.isEmpty) return;
    HapticFeedback.mediumImpact();
    final randomIndex = math.Random().nextInt(filtered.length);
    if (_viewMode == TilViewMode.deck && _deckPageController.hasClients) {
      _deckPageController.animateToPage(
        randomIndex,
        duration: const Duration(milliseconds: 420),
        curve: Curves.easeOutCubic,
      );
    } else {
      _openNoteDetailSheet(filtered[randomIndex]);
    }
  }

  Future<void> _copyToClipboard(String text, {String label = 'Snippet'}) async {
    await Clipboard.setData(ClipboardData(text: text));
    HapticFeedback.selectionClick();
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: const Color(0xFF1A2234),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: Color(0xFF00E676), width: 1),
          ),
          content: Row(
            children: <Widget>[
              const Icon(Icons.check_circle_rounded, color: Color(0xFF00E676), size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  '$label copied to clipboard',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          duration: const Duration(seconds: 2),
        ),
      );
  }

  void _openNoteDetailSheet(TilNote note) {
    widget.onNoteSelected?.call(note);
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _TilNoteDetailSheet(
        note: note,
        isBookmarked: _bookmarkedSlugs.contains(note.slug),
        isMastered: _masteredSlugs.contains(note.slug),
        onToggleBookmark: () => _toggleBookmark(note.slug),
        onToggleMastered: () => _toggleMastered(note.slug),
        onCopyText: (text, label) => _copyToClipboard(text, label: label),
      ),
    );
  }

  Future<void> _openComposerModal() async {
    final created = await showModalBottomSheet<TilNote>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _TilComposerSheet(
        initialTopic: _selectedTopic ?? TilTopic.johnnyDecimal,
      ),
    );
    if (created != null && mounted) {
      setState(() {
        _notes.insert(0, created);
      });
      widget.onNoteCreated?.call(created);
      _copyToClipboard(created.toMarkdown(), label: '${created.relativePath} markdown');
    }
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredNotes;
    final topicCounts = <TilTopic, int>{
      for (final t in TilTopic.values)
        t: _notes.where((n) => n.topic == t).length,
    };

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            Color(0xFF090D16),
            Color(0xFF0F172A),
            Color(0xFF0B1120),
          ],
        ),
      ),
      child: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: <Widget>[
            // 1. Hero Header & Streak Telemetry Bar
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                child: _buildHeroHeader(),
              ),
            ),

            // 2. Search Bar, View Switcher & Quick Filters
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: _buildSearchAndControlsBar(),
              ),
            ),

            // 3. Topic Category Pill Strip
            SliverToBoxAdapter(
              child: SizedBox(
                height: 52,
                child: _buildTopicFilterStrip(topicCounts),
              ),
            ),

            // 4. Active Filter Summary Row
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
                child: _buildResultsToolbar(filtered.length),
              ),
            ),

            // 5. Main Content Area (Empty state, Swipe Deck, or Bento Grid)
            if (filtered.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: _buildEmptyState(),
              )
            else if (_viewMode == TilViewMode.deck)
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 450,
                  child: _buildSwipeDeck(filtered),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 32),
                sliver: _buildResponsiveBentoGrid(filtered),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroHeader() {
    final masteryRatio =
        _notes.isEmpty ? 0.0 : (_masteredSlugs.length / _notes.length).clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            const Color(0xFF1E293B).withValues(alpha: 0.85),
            const Color(0xFF0F172A).withValues(alpha: 0.95),
          ],
        ),
        border: Border.all(
          color: const Color(0xFF334155).withValues(alpha: 0.6),
          width: 1.2,
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: const Color(0xFF00E676).withValues(alpha: 0.06),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Glowing badge icon
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: const LinearGradient(
                    colors: <Color>[Color(0xFF00E676), Color(0xFF00B0FF)],
                  ),
                ),
                child: const Icon(
                  Icons.bolt_rounded,
                  color: Color(0xFF090D16),
                  size: 26,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Flexible(
                          child: Text(
                            widget.title,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF00E676).withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(
                              color: const Color(0xFF00E676).withValues(alpha: 0.4),
                            ),
                          ),
                          child: Text(
                            '${_notes.length} NOTES',
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF00E676),
                              letterSpacing: 0.8,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.subtitle,
                      style: const TextStyle(
                        fontSize: 13.5,
                        color: Color(0xFF94A3B8),
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
              if (widget.enableComposer) ...<Widget>[
                const SizedBox(width: 8),
                FilledButton.icon(
                  onPressed: _openComposerModal,
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF00E676),
                    foregroundColor: const Color(0xFF090D16),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  icon: const Icon(Icons.add_rounded, size: 18),
                  label: const Text(
                    'New TIL',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 18),
          // Telemetry & Mastery Progress Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFF090D16).withValues(alpha: 0.55),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: const Color(0xFF1E293B),
              ),
            ),
            child: Row(
              children: <Widget>[
                const Icon(
                  Icons.local_fire_department_rounded,
                  color: Color(0xFFFF9100),
                  size: 18,
                ),
                const SizedBox(width: 6),
                const Text(
                  '7-Day Streak',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 12.5,
                  ),
                ),
                const SizedBox(width: 14),
                Container(
                  width: 1,
                  height: 16,
                  color: const Color(0xFF334155),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'Mastered ${_masteredSlugs.length} of ${_notes.length}',
                            style: const TextStyle(
                              color: Color(0xFFCBD5E1),
                              fontSize: 11.5,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            '${(masteryRatio * 100).round()}%',
                            style: const TextStyle(
                              color: Color(0xFF00E676),
                              fontSize: 11.5,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(999),
                        child: LinearProgressIndicator(
                          value: masteryRatio,
                          minHeight: 5,
                          backgroundColor: const Color(0xFF1E293B),
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            Color(0xFF00E676),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                IconButton(
                  tooltip: 'Surprise Me (Random TIL)',
                  onPressed: _shuffleSpotlight,
                  style: IconButton.styleFrom(
                    backgroundColor: const Color(0xFF1E293B),
                    foregroundColor: const Color(0xFF38BDF8),
                    padding: const EdgeInsets.all(8),
                    minimumSize: const Size(34, 34),
                  ),
                  icon: const Icon(Icons.shuffle_rounded, size: 17),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndControlsBar() {
    return Row(
      children: <Widget>[
        // Search Input
        Expanded(
          child: TextField(
            key: const Key('til_search_field'),
            controller: _searchController,
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
                _currentDeckIndex = 0;
              });
            },
            style: const TextStyle(color: Colors.white, fontSize: 14),
            decoration: InputDecoration(
              hintText: 'Search commands, NEC rules, paths, or topics...',
              hintStyle: const TextStyle(color: Color(0xFF64748B), fontSize: 13.5),
              prefixIcon: const Icon(
                Icons.search_rounded,
                color: Color(0xFF94A3B8),
                size: 20,
              ),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      tooltip: 'Clear search',
                      onPressed: () {
                        _searchController.clear();
                        setState(() {
                          _searchQuery = '';
                        });
                      },
                      icon: const Icon(
                        Icons.close_rounded,
                        color: Color(0xFF94A3B8),
                        size: 18,
                      ),
                    )
                  : null,
              filled: true,
              fillColor: const Color(0xFF1E293B).withValues(alpha: 0.75),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: Color(0xFF334155)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: Color(0xFF334155)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(
                  color: Color(0xFF00E676),
                  width: 1.4,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),

        // Bookmarks Filter Toggle
        IconButton(
          key: const Key('til_bookmark_filter_button'),
          tooltip: _onlyBookmarked ? 'Show all notes' : 'Show saved bookmarks',
          onPressed: () {
            setState(() {
              _onlyBookmarked = !_onlyBookmarked;
              _currentDeckIndex = 0;
            });
          },
          style: IconButton.styleFrom(
            backgroundColor: _onlyBookmarked
                ? const Color(0xFFFFD600).withValues(alpha: 0.18)
                : const Color(0xFF1E293B).withValues(alpha: 0.75),
            foregroundColor: _onlyBookmarked
                ? const Color(0xFFFFD600)
                : const Color(0xFF94A3B8),
            side: BorderSide(
              color: _onlyBookmarked
                  ? const Color(0xFFFFD600)
                  : const Color(0xFF334155),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            minimumSize: const Size(46, 46),
          ),
          icon: Icon(
            _onlyBookmarked
                ? Icons.bookmark_rounded
                : Icons.bookmark_border_rounded,
            size: 20,
          ),
        ),
        const SizedBox(width: 8),

        // View Mode Toggle (Bento Grid vs Swipe Deck)
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1E293B).withValues(alpha: 0.75),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFF334155)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _buildViewModeButton(
                mode: TilViewMode.bentoGrid,
                icon: Icons.grid_view_rounded,
                tooltip: 'Bento Grid View',
              ),
              _buildViewModeButton(
                mode: TilViewMode.deck,
                icon: Icons.style_rounded,
                tooltip: 'Swipe Deck View',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildViewModeButton({
    required TilViewMode mode,
    required IconData icon,
    required String tooltip,
  }) {
    final isSelected = _viewMode == mode;
    return IconButton(
      tooltip: tooltip,
      onPressed: () {
        setState(() {
          _viewMode = mode;
        });
      },
      style: IconButton.styleFrom(
        backgroundColor:
            isSelected ? const Color(0xFF00E676) : Colors.transparent,
        foregroundColor:
            isSelected ? const Color(0xFF090D16) : const Color(0xFF94A3B8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(11),
        ),
        minimumSize: const Size(42, 42),
      ),
      icon: Icon(icon, size: 19),
    );
  }

  Widget _buildTopicFilterStrip(Map<TilTopic, int> topicCounts) {
    return ListView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      children: <Widget>[
        _TopicChip(
          label: 'All Topics',
          emoji: '✨',
          count: _notes.length,
          accentColor: const Color(0xFF00E676),
          isSelected: _selectedTopic == null,
          onTap: () {
            setState(() {
              _selectedTopic = null;
              _currentDeckIndex = 0;
            });
          },
        ),
        const SizedBox(width: 8),
        for (final topic in TilTopic.values) ...<Widget>[
          _TopicChip(
            label: topic.label,
            emoji: topic.emoji,
            count: topicCounts[topic] ?? 0,
            accentColor: topic.accentColor,
            isSelected: _selectedTopic == topic,
            onTap: () {
              setState(() {
                _selectedTopic = _selectedTopic == topic ? null : topic;
                _currentDeckIndex = 0;
              });
            },
          ),
          const SizedBox(width: 8),
        ],
      ],
    );
  }

  Widget _buildResultsToolbar(int resultCount) {
    final topic = _selectedTopic;
    return Row(
      children: <Widget>[
        Text(
          topic == null
              ? 'Showing $resultCount ${resultCount == 1 ? 'note' : 'notes'}'
              : '${topic.emoji} ${topic.label} — ${topic.subtitle} ($resultCount)',
          style: const TextStyle(
            color: Color(0xFF94A3B8),
            fontSize: 12.5,
            fontWeight: FontWeight.w600,
          ),
        ),
        const Spacer(),
        if (_selectedTopic != null ||
            _searchQuery.isNotEmpty ||
            _onlyBookmarked)
          TextButton.icon(
            onPressed: () {
              _searchController.clear();
              setState(() {
                _selectedTopic = null;
                _searchQuery = '';
                _onlyBookmarked = false;
              });
            },
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFF38BDF8),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            icon: const Icon(Icons.filter_alt_off_rounded, size: 15),
            label: const Text(
              'Reset filters',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF334155)),
              ),
              child: const Icon(
                Icons.manage_search_rounded,
                size: 40,
                color: Color(0xFF38BDF8),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'No matching Today I Learned notes',
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Try clearing your search query or switching topic filters.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13.5),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwipeDeck(List<TilNote> notes) {
    final safeIndex = _currentDeckIndex.clamp(0, notes.length - 1);
    return Column(
      children: <Widget>[
        Expanded(
          child: PageView.builder(
            controller: _deckPageController,
            itemCount: notes.length,
            onPageChanged: (index) {
              setState(() {
                _currentDeckIndex = index;
              });
            },
            itemBuilder: (context, index) {
              final note = notes[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                child: _TilNoteCard(
                  note: note,
                  isBookmarked: _bookmarkedSlugs.contains(note.slug),
                  isMastered: _masteredSlugs.contains(note.slug),
                  isDeckCard: true,
                  onTap: () => _openNoteDetailSheet(note),
                  onToggleBookmark: () => _toggleBookmark(note.slug),
                  onToggleMastered: () => _toggleMastered(note.slug),
                  onCopyCommand: note.keyCommandOrRule != null
                      ? () => _copyToClipboard(
                            note.keyCommandOrRule!,
                            label: 'Command',
                          )
                      : null,
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            IconButton(
              tooltip: 'Previous card',
              onPressed: safeIndex > 0
                  ? () => _deckPageController.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOutCubic,
                      )
                  : null,
              icon: const Icon(Icons.chevron_left_rounded, color: Colors.white),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                'Card ${safeIndex + 1} of ${notes.length}',
                style: const TextStyle(
                  color: Color(0xFFCBD5E1),
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            IconButton(
              tooltip: 'Next card',
              onPressed: safeIndex < notes.length - 1
                  ? () => _deckPageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOutCubic,
                      )
                  : null,
              icon: const Icon(Icons.chevron_right_rounded, color: Colors.white),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildResponsiveBentoGrid(List<TilNote> notes) {
    return SliverLayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.crossAxisExtent;
        final int crossAxisCount;
        final double childAspectRatio;

        if (width >= 1100) {
          crossAxisCount = 3;
          childAspectRatio = 1.18;
        } else if (width >= 680) {
          crossAxisCount = 2;
          childAspectRatio = 1.12;
        } else {
          crossAxisCount = 1;
          childAspectRatio = 1.32;
        }

        return SliverGrid(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: 14,
            crossAxisSpacing: 14,
            childAspectRatio: childAspectRatio,
          ),
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final note = notes[index];
              return _TilNoteCard(
                note: note,
                isBookmarked: _bookmarkedSlugs.contains(note.slug),
                isMastered: _masteredSlugs.contains(note.slug),
                onTap: () => _openNoteDetailSheet(note),
                onToggleBookmark: () => _toggleBookmark(note.slug),
                onToggleMastered: () => _toggleMastered(note.slug),
                onCopyCommand: note.keyCommandOrRule != null
                    ? () => _copyToClipboard(
                          note.keyCommandOrRule!,
                          label: 'Command',
                        )
                    : null,
              );
            },
            childCount: notes.length,
          ),
        );
      },
    );
  }
}

/// Interactive pill chip representing a [TilTopic] filter.
class _TopicChip extends StatelessWidget {
  const _TopicChip({
    required this.label,
    required this.emoji,
    required this.count,
    required this.accentColor,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final String emoji;
  final int count;
  final Color accentColor;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            color: isSelected
                ? accentColor.withValues(alpha: 0.2)
                : const Color(0xFF1E293B).withValues(alpha: 0.7),
            border: Border.all(
              color: isSelected ? accentColor : const Color(0xFF334155),
              width: isSelected ? 1.5 : 1.0,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(emoji, style: const TextStyle(fontSize: 14)),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.white : const Color(0xFFCBD5E1),
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                  fontSize: 13,
                ),
              ),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                decoration: BoxDecoration(
                  color: isSelected
                      ? accentColor.withValues(alpha: 0.3)
                      : const Color(0xFF0F172A),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  '$count',
                  style: TextStyle(
                    color: isSelected ? Colors.white : const Color(0xFF94A3B8),
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Individual micro-knowledge card displaying a [TilNote].
class _TilNoteCard extends StatelessWidget {
  const _TilNoteCard({
    required this.note,
    required this.isBookmarked,
    required this.isMastered,
    required this.onTap,
    required this.onToggleBookmark,
    required this.onToggleMastered,
    this.onCopyCommand,
    this.isDeckCard = false,
  });

  final TilNote note;
  final bool isBookmarked;
  final bool isMastered;
  final VoidCallback onTap;
  final VoidCallback onToggleBookmark;
  final VoidCallback onToggleMastered;
  final VoidCallback? onCopyCommand;
  final bool isDeckCard;

  @override
  Widget build(BuildContext context) {
    final accent = note.topic.accentColor;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[
                const Color(0xFF1E293B).withValues(alpha: 0.9),
                const Color(0xFF0F172A).withValues(alpha: 0.95),
              ],
            ),
            border: Border.all(
              color: isMastered
                  ? accent.withValues(alpha: 0.65)
                  : const Color(0xFF334155).withValues(alpha: 0.8),
              width: isMastered ? 1.4 : 1.0,
            ),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: accent.withValues(alpha: 0.05),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Top Metadata Row (Topic Badge + Date + Actions)
              Row(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: accent.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(color: accent.withValues(alpha: 0.4)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(note.topic.emoji, style: const TextStyle(fontSize: 12)),
                        const SizedBox(width: 5),
                        Text(
                          note.topic.id,
                          style: TextStyle(
                            color: accent,
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    note.date,
                    style: const TextStyle(
                      color: Color(0xFF64748B),
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    tooltip: isMastered ? 'Marked as learned' : 'Mark as learned',
                    onPressed: onToggleMastered,
                    visualDensity: VisualDensity.compact,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(minWidth: 30, minHeight: 30),
                    icon: Icon(
                      isMastered
                          ? Icons.check_circle_rounded
                          : Icons.check_circle_outline_rounded,
                      color: isMastered ? accent : const Color(0xFF64748B),
                      size: 19,
                    ),
                  ),
                  const SizedBox(width: 4),
                  IconButton(
                    tooltip: isBookmarked ? 'Remove bookmark' : 'Bookmark note',
                    onPressed: onToggleBookmark,
                    visualDensity: VisualDensity.compact,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(minWidth: 30, minHeight: 30),
                    icon: Icon(
                      isBookmarked
                          ? Icons.bookmark_rounded
                          : Icons.bookmark_border_rounded,
                      color: isBookmarked
                          ? const Color(0xFFFFD600)
                          : const Color(0xFF64748B),
                      size: 19,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Title
              Text(
                note.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16.5,
                  fontWeight: FontWeight.w800,
                  height: 1.25,
                ),
              ),
              const SizedBox(height: 8),

              // Distilled Summary
              Expanded(
                child: Text(
                  note.summary,
                  maxLines: isDeckCard ? 5 : 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFFCBD5E1),
                    fontSize: 13.5,
                    height: 1.45,
                  ),
                ),
              ),

              // Highlighted Command / Formula Bar
              if (note.keyCommandOrRule != null) ...<Widget>[
                const SizedBox(height: 10),
                InkWell(
                  onTap: onCopyCommand,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF090D16),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: accent.withValues(alpha: 0.35),
                      ),
                    ),
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.terminal_rounded,
                          size: 15,
                          color: accent,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            note.keyCommandOrRule!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 12,
                              color: Color(0xFFE2E8F0),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Icon(
                          Icons.copy_rounded,
                          size: 14,
                          color: Color(0xFF94A3B8),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Full interactive bottom sheet for reading a [TilNote], viewing its markdown
/// table, and copying its raw `<topic>/<slug>.md` source or CLI snippet.
class _TilNoteDetailSheet extends StatelessWidget {
  const _TilNoteDetailSheet({
    required this.note,
    required this.isBookmarked,
    required this.isMastered,
    required this.onToggleBookmark,
    required this.onToggleMastered,
    required this.onCopyText,
  });

  final TilNote note;
  final bool isBookmarked;
  final bool isMastered;
  final VoidCallback onToggleBookmark;
  final VoidCallback onToggleMastered;
  final void Function(String text, String label) onCopyText;

  @override
  Widget build(BuildContext context) {
    final accent = note.topic.accentColor;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.86,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        border: Border.all(color: accent.withValues(alpha: 0.4), width: 1.2),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const SizedBox(height: 10),
          Container(
            width: 44,
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFF475569),
              borderRadius: BorderRadius.circular(999),
            ),
          ),
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Path & Read time badge row
                  Row(
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: accent.withValues(alpha: 0.16),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          '${note.topic.emoji}  ${note.relativePath}',
                          style: TextStyle(
                            color: accent,
                            fontFamily: 'monospace',
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '${note.date} • ~${note.estimatedReadSeconds}s read',
                        style: const TextStyle(
                          color: Color(0xFF94A3B8),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Headline
                  Text(
                    note.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      height: 1.25,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Primary Summary
                  Text(
                    note.summary,
                    style: const TextStyle(
                      color: Color(0xFFE2E8F0),
                      fontSize: 15.5,
                      height: 1.55,
                    ),
                  ),

                  if (note.details.isNotEmpty) ...<Widget>[
                    const SizedBox(height: 14),
                    Text(
                      note.details,
                      style: const TextStyle(
                        color: Color(0xFFCBD5E1),
                        fontSize: 14.5,
                        height: 1.55,
                      ),
                    ),
                  ],

                  // Key Command or Formula Box
                  if (note.keyCommandOrRule != null) ...<Widget>[
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFF090D16),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: accent.withValues(alpha: 0.45)),
                      ),
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.terminal_rounded, color: accent, size: 20),
                          const SizedBox(width: 12),
                          Expanded(
                            child: SelectableText(
                              note.keyCommandOrRule!,
                              style: const TextStyle(
                                fontFamily: 'monospace',
                                color: Color(0xFF00E676),
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          IconButton(
                            tooltip: 'Copy snippet',
                            onPressed: () => onCopyText(
                              note.keyCommandOrRule!,
                              'Command snippet',
                            ),
                            icon: const Icon(
                              Icons.copy_all_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  // Structured Markdown Table (if present, e.g., Johnny Decimal tables)
                  if (note.table != null) ...<Widget>[
                    const SizedBox(height: 20),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF090D16),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFF334155)),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Table(
                          border: const TableBorder(
                            horizontalInside: BorderSide(
                              color: Color(0xFF1E293B),
                            ),
                          ),
                          columnWidths: const <int, TableColumnWidth>{
                            0: IntrinsicColumnWidth(),
                            1: FlexColumnWidth(),
                          },
                          children: <TableRow>[
                            TableRow(
                              decoration: const BoxDecoration(
                                color: Color(0xFF1E293B),
                              ),
                              children: note.table!.headers
                                  .map(
                                    (h) => Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Text(
                                        h,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 12.5,
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                            for (final row in note.table!.rows)
                              TableRow(
                                children: row
                                    .map(
                                      (cell) => Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Text(
                                          cell,
                                          style: const TextStyle(
                                            color: Color(0xFFCBD5E1),
                                            fontSize: 12.5,
                                            fontFamily: 'monospace',
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],

                  const SizedBox(height: 24),
                  // Action Buttons Row
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: <Widget>[
                      FilledButton.icon(
                        onPressed: () => onCopyText(
                          note.toMarkdown(),
                          '${note.relativePath} Markdown',
                        ),
                        style: FilledButton.styleFrom(
                          backgroundColor: accent,
                          foregroundColor: const Color(0xFF090D16),
                        ),
                        icon: const Icon(Icons.code_rounded, size: 18),
                        label: const Text(
                          'Copy Raw .md',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                      OutlinedButton.icon(
                        onPressed: () {
                          onToggleMastered();
                          Navigator.of(context).pop();
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: Color(0xFF475569)),
                        ),
                        icon: Icon(
                          isMastered
                              ? Icons.check_circle_rounded
                              : Icons.check_circle_outline_rounded,
                          size: 18,
                          color: accent,
                        ),
                        label: Text(
                          isMastered ? 'Learned' : 'Mark as Learned',
                        ),
                      ),
                      OutlinedButton.icon(
                        onPressed: () {
                          onToggleBookmark();
                          Navigator.of(context).pop();
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: Color(0xFF475569)),
                        ),
                        icon: Icon(
                          isBookmarked
                              ? Icons.bookmark_rounded
                              : Icons.bookmark_border_rounded,
                          size: 18,
                          color: const Color(0xFFFFD600),
                        ),
                        label: Text(isBookmarked ? 'Saved' : 'Save Note'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Interactive modal composer for creating a new `<topic>/<slug>.md` note.
class _TilComposerSheet extends StatefulWidget {
  const _TilComposerSheet({required this.initialTopic});

  final TilTopic initialTopic;

  @override
  State<_TilComposerSheet> createState() => _TilComposerSheetState();
}

class _TilComposerSheetState extends State<_TilComposerSheet> {
  late TilTopic _topic;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _slugController = TextEditingController();
  final TextEditingController _summaryController = TextEditingController();
  final TextEditingController _commandController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _topic = widget.initialTopic;
    _titleController.addListener(_syncSlugFromTitle);
  }

  void _syncSlugFromTitle() {
    final generated = _titleController.text
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
        .replaceAll(RegExp(r'^-+|-+$'), '');
    _slugController.value = TextEditingValue(text: generated);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _slugController.dispose();
    _summaryController.dispose();
    _commandController.dispose();
    super.dispose();
  }

  void _submit() {
    final title = _titleController.text.trim();
    final summary = _summaryController.text.trim();
    if (title.isEmpty || summary.isEmpty) return;

    final slug = _slugController.text.trim().isEmpty
        ? 'new-note'
        : _slugController.text.trim();
    final now = DateTime.now();
    final isoDate =
        '${now.year.toString().padLeft(4, '0')}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

    final note = TilNote(
      slug: slug,
      topic: _topic,
      title: title,
      date: isoDate,
      summary: summary,
      details: '',
      keyCommandOrRule: _commandController.text.trim().isEmpty
          ? null
          : _commandController.text.trim(),
      tags: <String>[_topic.id],
    );
    Navigator.of(context).pop(note);
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
        decoration: const BoxDecoration(
          color: Color(0xFF0F172A),
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                'Capture a Today I Learned Note',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 19,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Target path: ${_topic.id}/${_slugController.text.isEmpty ? '<slug>' : _slugController.text}.md',
                style: TextStyle(
                  color: _topic.accentColor,
                  fontFamily: 'monospace',
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 14),
              DropdownButtonFormField<TilTopic>(
                value: _topic,
                dropdownColor: const Color(0xFF1E293B),
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Topic Folder',
                  labelStyle: TextStyle(color: Color(0xFF94A3B8)),
                ),
                items: TilTopic.values
                    .map(
                      (t) => DropdownMenuItem<TilTopic>(
                        value: t,
                        child: Text('${t.emoji} ${t.label} (${t.id}/)'),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _topic = value);
                  }
                },
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _titleController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'What did you learn? (# Title)',
                  labelStyle: TextStyle(color: Color(0xFF94A3B8)),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _summaryController,
                maxLines: 3,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'The fact in a few sentences',
                  labelStyle: TextStyle(color: Color(0xFF94A3B8)),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _commandController,
                style: const TextStyle(
                  color: Color(0xFF00E676),
                  fontFamily: 'monospace',
                ),
                decoration: const InputDecoration(
                  labelText: 'Key command, path, or formula (optional)',
                  labelStyle: TextStyle(color: Color(0xFF94A3B8)),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _submit,
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF00E676),
                    foregroundColor: const Color(0xFF090D16),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  icon: const Icon(Icons.save_rounded),
                  label: const Text(
                    'Add Note & Copy Markdown',
                    style: TextStyle(fontWeight: FontWeight.w800),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
