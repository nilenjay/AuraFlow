import 'package:equatable/equatable.dart';
import '../../../data/models/ambience_model.dart';

abstract class AmbienceState extends Equatable {
  const AmbienceState();

  @override
  List<Object?> get props => [];
}

class AmbienceInitial extends AmbienceState {
  const AmbienceInitial();
}

class AmbienceLoading extends AmbienceState {
  const AmbienceLoading();
}

class AmbienceLoaded extends AmbienceState {
  final List<Ambience> allAmbiences;
  final List<Ambience> filteredAmbiences;

  const AmbienceLoaded({
    required this.allAmbiences,
    required this.filteredAmbiences,
  });

  @override
  List<Object?> get props => [allAmbiences, filteredAmbiences];
}

class AmbienceError extends AmbienceState {
  final String message;

  const AmbienceError(this.message);

  @override
  List<Object?> get props => [message];
}