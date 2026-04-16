import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/repositories/ambience_repository.dart';
import 'ambience_event.dart';
import 'ambience_state.dart';

class AmbienceBloc extends Bloc<AmbienceEvent, AmbienceState>{
  final AmbienceRepository repository;

  AmbienceBloc(this.repository) : super(AmbienceInitial()){
    on<LoadAmbience>((event,emit) async {
      emit(AmbienceLoading());
      try{
        final data=await repository.getAmbiences();
        emit(AmbienceLoaded(data));
      }
      catch(e){
        emit(AmbienceError(e.toString()));
      }
    });
  }
}