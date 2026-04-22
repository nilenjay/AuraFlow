import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/journal_bloc.dart';
import '../bloc/journal_event.dart';
import '../bloc/journal_state.dart';

class JournalHistoryScreen extends StatefulWidget {
  const JournalHistoryScreen({super.key});

  @override
  State<JournalHistoryScreen> createState() =>
      _JournalHistoryScreenState();
}

class _JournalHistoryScreenState
    extends State<JournalHistoryScreen> {
  @override
  void initState() {
    super.initState();
    context.read<JournalBloc>().add(LoadJournal());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Journal History")),
      body: BlocBuilder<JournalBloc, JournalState>(
        builder: (context, state) {
          if (state is JournalLoaded) {
            if (state.entries.isEmpty) {
              return const Center(
                child: Text("No reflections yet. Start a session to begin."),
              );
            }

            return ListView.builder(
              itemCount: state.entries.length,
              itemBuilder: (context, index) {
                final item = state.entries[index];
                final preview = item.text.split('\n').first;
                final dateStr =
                    item.date.toLocal().toString().substring(0, 16);

                return ListTile(
                  onTap: () =>
                      context.pushNamed('journal-detail', extra: item),
                  title: Text(item.title),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        dateStr,
                        style: const TextStyle(
                            fontSize: 11, color: Colors.grey),
                      ),
                      Text(
                        preview.isEmpty ? "No text written." : preview,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  trailing: Text(
                    item.mood,
                    style: const TextStyle(fontSize: 12),
                  ),
                  isThreeLine: true,
                );
              },
            );
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}