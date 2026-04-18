import 'package:equatable/equatable.dart';

abstract class AmbienceEvent extends Equatable{

  @override
  List<Object?> get props => [];
}

class LoadAmbience extends AmbienceEvent{}

class FilterAmbiences extends AmbienceEvent{
  final String query;
  final String tag;

  FilterAmbiences({required this.query, required this.tag});
}


