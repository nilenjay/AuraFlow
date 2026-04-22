import 'package:flutter_bloc/flutter_bloc.dart';
import 'journal_event.dart';
import 'journal_state.dart';
import '../repository/journal_repository.dart';

class JournalBloc extends Bloc<JournalEvent, JournalState> {
  final JournalRepository repo;

  JournalBloc(this.repo) : super(JournalInitial()) {
    on<LoadJournal>(_onLoad);
    on<SaveJournal>(_onSave);
  }

  void _onLoad(LoadJournal event, Emitter<JournalState> emit) {
    emit(JournalLoading());

    try {
      final entries = repo.getEntries();
      emit(JournalLoaded(entries));
    } catch (e) {
      emit(JournalError("Failed to load entries"));
    }
  }

  void _onSave(SaveJournal event, Emitter<JournalState> emit) async {
    try {
      await repo.addEntry(event.entry);

      final entries = repo.getEntries();
      emit(JournalLoaded(entries));
    } catch (e) {
      emit(JournalError("Failed to save entry"));
    }
  }
}