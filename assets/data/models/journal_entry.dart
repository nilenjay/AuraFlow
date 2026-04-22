class JournalEntry {
  final String title;
  final String mood;
  final String text;
  final DateTime date;

  JournalEntry({
    required this.title,
    required this.mood,
    required this.text,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'mood': mood,
      'text': text,
      'date': date.toIso8601String(),
    };
  }

  factory JournalEntry.fromMap(Map map) {
    return JournalEntry(
      title: map['title'],
      mood: map['mood'],
      text: map['text'],
      date: DateTime.parse(map['date']),
    );
  }
}