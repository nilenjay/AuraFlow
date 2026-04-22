import 'package:equatable/equatable.dart';
import '../models/journal_entry.dart';

abstract class JournalEvent extends Equatable {
  const JournalEvent();

  @override
  List<Object?> get props => [];
}

class SaveJournal extends JournalEvent {
  final JournalEntry entry;

  const SaveJournal(this.entry);

  @override
  List<Object?> get props => [entry];
}

class LoadJournal extends JournalEvent {}