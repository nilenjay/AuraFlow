import 'package:hive/hive.dart';
import '../models/journal_entry.dart';

class JournalRepository {
  final Box box = Hive.box('journalBox');

  Future<void> addEntry(JournalEntry entry) async {
    await box.put(entry.id, entry.toMap());
  }

  List<JournalEntry> getEntries() {
    return box.values
        .map((e) => JournalEntry.fromMap(
      Map<String, dynamic>.from(e),
    ))
        .toList()
        .reversed
        .toList();
  }

  Future<void> clearAll() async {
    await box.clear();
  }
}