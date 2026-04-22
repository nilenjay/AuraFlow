import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'journal_event.dart';
part 'journal_state.dart';

class JournalBloc extends Bloc<JournalEvent, JournalState> {
  JournalBloc() : super(JournalInitial()) {
    on<JournalEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
