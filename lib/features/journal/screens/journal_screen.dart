import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/journal_bloc.dart';
import '../bloc/journal_event.dart';
import '../models/journal_entry.dart';

class JournalScreen extends StatefulWidget {
  final String title;

  const JournalScreen({super.key, required this.title});

  @override
  State<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  final _controller = TextEditingController();
  String _selectedMood = 'Calm';

  static const _moods = [
    _Mood('Calm', Icons.spa_outlined),
    _Mood('Grounded', Icons.landscape_outlined),
    _Mood('Energized', Icons.bolt_outlined),
    _Mood('Sleepy', Icons.bedtime_outlined),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
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
                    child: Icon(Icons.person, size: 20, color: cs.onPrimaryContainer),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 28, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'DAILY REFLECTION',
                      style: TextStyle(
                        fontSize: 11,
                        letterSpacing: 1.5,
                        color: cs.onSurface.withOpacity(0.5),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'What is gently present\nwith you right now?',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w600,
                        height: 1.3,
                        color: cs.onSurface,
                      ),
                    ),

                    const SizedBox(height: 28),

                    // Text field
                    Container(
                      decoration: BoxDecoration(
                        color: cs.surface,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _controller,
                        maxLines: 10,
                        style: TextStyle(
                          fontSize: 15,
                          height: 1.6,
                          color: cs.onSurface,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Let your thoughts flow onto the page...',
                          hintStyle: TextStyle(
                            color: cs.onSurface.withOpacity(0.35),
                            fontSize: 15,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.all(20),
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    Text(
                      'SELECT MOOD',
                      style: TextStyle(
                        fontSize: 11,
                        letterSpacing: 1.5,
                        color: cs.onSurface.withOpacity(0.5),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Mood grid
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio: 3.0,
                      children: _moods.map((mood) {
                        final isSelected = _selectedMood == mood.label;
                        return GestureDetector(
                          onTap: () =>
                              setState(() => _selectedMood = mood.label),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color(0xFFB2DFDB)
                                  : cs.surface,
                              borderRadius: BorderRadius.circular(40),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(
                                      isDark ? 0.3 : 0.04),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  mood.icon,
                                  size: 18,
                                  color: isSelected
                                      ? const Color(0xFF00695C)
                                      : cs.onSurface.withOpacity(0.55),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  mood.label,
                                  style: TextStyle(
                                    fontWeight: isSelected
                                        ? FontWeight.w600
                                        : FontWeight.w500,
                                    color: isSelected
                                        ? const Color(0xFF00695C)
                                        : cs.onSurface.withOpacity(0.7),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 32),

                    // Save button
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        onPressed: () {
                          final entry = JournalEntry(
                            id: Random().nextInt(99999).toString(),
                            title: widget.title,
                            mood: _selectedMood,
                            text: _controller.text,
                            date: DateTime.now(),
                          );
                          context.read<JournalBloc>().add(SaveJournal(entry));
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2D4B6B),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Save Entry',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Mood {
  final String label;
  final IconData icon;
  const _Mood(this.label, this.icon);
}