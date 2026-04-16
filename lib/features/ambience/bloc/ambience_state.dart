import 'package:equatable/equatable.dart';

import '../../../data/models/ambience_model.dart';

abstract class AmbienceState extends Equatable{

  @override
  List<Object?> get props => [];
}

class AmbienceInitial extends AmbienceState{}

class AmbienceLoaded extends AmbienceState{
  final List<Ambience> ambiences;

  AmbienceLoaded(this.ambiences);

  @override
  List<Object?> get props => [ambiences];
}

class AmbienceLoading extends AmbienceState{}

class AmbienceError extends AmbienceState{
  final String message;

  AmbienceError(this.message);

  @override
  List<Object?> get props => [message];
}

