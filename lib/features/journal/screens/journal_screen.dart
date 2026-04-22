import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/journal_bloc.dart';
import '../bloc/journal_event.dart';
import '../models/journal_entry.dart';
import 'dart:math';

class JournalScreen extends StatefulWidget {
  final String title;

  const JournalScreen({super.key, required this.title});

  @override
  State<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  final controller = TextEditingController();
  String selectedMood = "Calm";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Reflection")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            const Text(
              "What is gently present with you right now?",
              style: TextStyle(fontSize: 18),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: controller,
              maxLines: 6,
              decoration: const InputDecoration(
                hintText: "Write your thoughts...",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            Wrap(
              spacing: 10,
              children: ["Calm", "Grounded", "Energized", "Sleepy"]
                  .map((mood) => ChoiceChip(
                label: Text(mood),
                selected: selectedMood == mood,
                onSelected: (_) {
                  setState(() => selectedMood = mood);
                },
              ))
                  .toList(),
            ),

            const Spacer(),

            ElevatedButton(
              onPressed: () {
                final entry = JournalEntry(
                  id: Random().nextInt(99999).toString(),
                  title: widget.title,
                  mood: selectedMood,
                  text: controller.text,
                  date: DateTime.now(),
                );

                context.read<JournalBloc>().add(SaveJournal(entry));

                Navigator.pop(context);
              },
              child: const Text("Save Entry"),
            )
          ],
        ),
      ),
    );
  }
}