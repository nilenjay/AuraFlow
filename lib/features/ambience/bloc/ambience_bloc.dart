import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/ambience_model.dart';
import '../../../data/repositories/ambience_repository.dart';
import 'ambience_event.dart';
import 'ambience_state.dart';

class AmbienceBloc extends Bloc<AmbienceEvent, AmbienceState> {
  final AmbienceRepository repository;

  AmbienceBloc(this.repository) : super(AmbienceInitial()) {
    on<LoadAmbience>(_onLoadAmbience);
    on<FilterAmbiences>(_onFilterAmbiences);
  }

  Future<void> _onLoadAmbience(
      LoadAmbience event,
      Emitter<AmbienceState> emit,
      ) async {
    emit(AmbienceLoading());
    try {
      final data = await repository.getAmbiences();

      emit(AmbienceLoaded(
        allAmbiences: data,
        filteredAmbiences: data,
      ));
    } catch (e) {
      emit(AmbienceError(e.toString()));
    }
  }
  void _onFilterAmbiences(FilterAmbiences event, Emitter<AmbienceState> emit){
    if(state is AmbienceLoaded){
      final current = state as AmbienceLoaded;
      final filtered = _filterAmbiences(current.allAmbiences, event.query, event.tag);

      emit(AmbienceLoaded(
        allAmbiences: current.allAmbiences,
        filteredAmbiences: filtered,
      ));
    }
  }

  List<Ambience> _filterAmbiences(List<Ambience> list, String query, String tag){
    return list.where((item){
      final matchesSearch = item.title.toLowerCase().contains(query.toLowerCase());
      final matchedTag = tag=="All" || item.tag==tag;

      return matchesSearch && matchedTag;
    }).toList();
  }
}