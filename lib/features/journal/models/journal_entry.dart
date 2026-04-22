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

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'mood': mood,
      'text': text,
      'date': date.toIso8601String(),
    };
  }

  factory JournalEntry.fromMap(Map<String, dynamic> map) {
    return JournalEntry(
      id: map['id'] as String,
      title: map['title'] as String,
      mood: map['mood'] as String,
      text: map['text'] as String,
      date: DateTime.parse(map['date'] as String),
    );
  }

  @override
  List<Object?> get props => [id, title, mood, text, date];
}