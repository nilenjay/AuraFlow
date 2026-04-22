import 'package:equatable/equatable.dart';

class JournalEntry extends Equatable {
  final String id;
  final String title;
  final String mood;
  final String text;
  final DateTime date;

  const JournalEntry({
    required this.id,
    required this.title,
    required this.mood,
    required this.text,
    required this.date,
  });

  @override
  List<Object?> get props => [id, title, mood, text, date];
}