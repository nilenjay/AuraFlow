import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
                child: Text("No reflections yet"),
              );
            }

            return ListView.builder(
              itemCount: state.entries.length,
              itemBuilder: (context, index) {
                final item = state.entries[index];

                return ListTile(
                  title: Text(item.title),
                  subtitle: Text(item.text),
                  trailing: Text(item.mood),
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