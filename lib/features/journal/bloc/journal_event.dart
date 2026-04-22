import 'package:auraflow/features/journal/models/journal_entry.dart';
import 'package:equatable/equatable.dart';

abstract class JournalEvent extends Equatable{
  const JournalEvent();
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class SaveJournal extends JournalEvent{
  final JournalEntry entry;
  const SaveJournal(this.entry);
  @override
  // TODO: implement props
  List<Object?> get props => [entry];
}

class LoadJournal extends JournalEvent{}