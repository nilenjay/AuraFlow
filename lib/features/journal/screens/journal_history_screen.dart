import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/journal_bloc.dart';
import '../bloc/journal_event.dart';
import '../bloc/journal_state.dart';
import '../models/journal_entry.dart';

class JournalHistoryScreen extends StatefulWidget {
  const JournalHistoryScreen({super.key});

  @override
  State<JournalHistoryScreen> createState() => _JournalHistoryScreenState();
}

class _JournalHistoryScreenState extends State<JournalHistoryScreen> {
  String _search = '';

  @override
  void initState() {
    super.initState();
    context.read<JournalBloc>().add(LoadJournal());
  }

  static const _moodSubtitle = {
    'Calm': 'Feeling Balanced',
    'Grounded': 'Deep Reflection',
    'Energized': 'Joyful Clarity',
    'Sleepy': 'Restful State',
  };

  static const _moodColor = {
    'Calm': Color(0xFF80CBC4),
    'Grounded': Color(0xFF9575CD),
    'Energized': Color(0xFFFFB74D),
    'Sleepy': Color(0xFF7986CB),
  };

  String _formatDate(DateTime dt) {
    final months = [
      'JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN',
      'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC'
    ];
    final h = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final m = dt.minute.toString().padLeft(2, '0');
    final ampm = dt.hour < 12 ? 'AM' : 'PM';
    return '${months[dt.month - 1]} ${dt.day}, ${dt.year}  •  $h:$m $ampm';
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<JournalBloc, JournalState>(
          builder: (context, state) {
            final entries = state is JournalLoaded ? state.entries : <JournalEntry>[];

            final filtered = _search.isEmpty
                ? entries
                : entries
                    .where((e) =>
                        e.title.toLowerCase().contains(_search.toLowerCase()) ||
                        e.text.toLowerCase().contains(_search.toLowerCase()))
                    .toList();

            return CustomScrollView(
              slivers: [
                // ── Header ──
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const SizedBox(width: 40),
                            Text(
                              'AuraFlow',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 17,
                                color: cs.onSurface,
                              ),
                            ),
                            CircleAvatar(
                              radius: 18,
                              backgroundColor: cs.primaryContainer,
                              child: Icon(Icons.person,
                                  size: 20, color: cs.onPrimaryContainer),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'REFLECTIONS',
                          style: TextStyle(
                            fontSize: 11,
                            letterSpacing: 1.6,
                            fontWeight: FontWeight.w600,
                            color: cs.onSurface.withOpacity(0.45),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Journal History',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            color: cs.onSurface,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Your journey toward inner peace,\ndocumented one breath at a time.',
                          style: TextStyle(
                            fontSize: 13,
                            height: 1.5,
                            color: cs.onSurface.withOpacity(0.5),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // ── Search bar ──
                        Container(
                          decoration: BoxDecoration(
                            color: cs.surface,
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.06),
                                blurRadius: 10,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: TextField(
                            onChanged: (v) => setState(() => _search = v),
                            decoration: InputDecoration(
                              hintText: 'Search your thoughts...',
                              hintStyle: TextStyle(
                                color: cs.onSurface.withOpacity(0.35),
                                fontSize: 14,
                              ),
                              prefixIcon: Icon(Icons.search,
                                  color: cs.onSurface.withOpacity(0.4)),
                              border: InputBorder.none,
                              contentPadding:
                                  const EdgeInsets.symmetric(vertical: 14),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),

                // ── Empty state ──
                if (state is JournalLoaded && filtered.isEmpty)
                  SliverFillRemaining(
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.auto_stories_outlined,
                              size: 52,
                              color: cs.onSurface.withOpacity(0.25)),
                          const SizedBox(height: 16),
                          Text(
                            'No reflections yet.',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              color: cs.onSurface.withOpacity(0.5),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Start a session to begin.',
                            style: TextStyle(
                              fontSize: 13,
                              color: cs.onSurface.withOpacity(0.35),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                // ── Entry cards ──
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final item = filtered[index];
                        final moodColor =
                            _moodColor[item.mood] ?? const Color(0xFF80CBC4);
                        final subtitle =
                            _moodSubtitle[item.mood] ?? item.mood;
                        final preview = item.text.trim();

                        return GestureDetector(
                          onTap: () => context.pushNamed(
                            'journal-detail',
                            extra: item,
                          ),
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                              color: cs.surface,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.06),
                                  blurRadius: 14,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(18),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Date row + mood badge
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(Icons.calendar_today_outlined,
                                              size: 12,
                                              color: cs.onSurface
                                                  .withOpacity(0.4)),
                                          const SizedBox(width: 5),
                                          Text(
                                            _formatDate(item.date.toLocal()),
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: cs.onSurface
                                                  .withOpacity(0.45),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 4),
                                        decoration: BoxDecoration(
                                          color:
                                              moodColor.withOpacity(0.2),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Text(
                                          item.mood.toUpperCase(),
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w700,
                                            letterSpacing: 0.8,
                                            color: moodColor
                                                .withOpacity(1)
                                                .withRed(
                                                  (moodColor.red * 0.7)
                                                      .toInt(),
                                                ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 12),

                                  // Title
                                  Text(
                                    item.title,
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      color: cs.onSurface,
                                    ),
                                  ),

                                  const SizedBox(height: 6),

                                  // Subtitle (mood label)
                                  Row(
                                    children: [
                                      Container(
                                        width: 8,
                                        height: 8,
                                        decoration: BoxDecoration(
                                          color: moodColor,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        subtitle,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color:
                                              cs.onSurface.withOpacity(0.55),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),

                                  if (preview.isNotEmpty) ...[
                                    const SizedBox(height: 12),
                                    Text(
                                      preview,
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 13,
                                        height: 1.6,
                                        color: cs.onSurface.withOpacity(0.65),
                                      ),
                                    ),
                                  ],

                                  const SizedBox(height: 14),

                                  // View link
                                  Row(
                                    children: [
                                      Text(
                                        'View Full Insight',
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: const Color(0xFF2D4B6B),
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      const Icon(
                                        Icons.arrow_forward,
                                        size: 13,
                                        color: Color(0xFF2D4B6B),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      childCount: filtered.length,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}