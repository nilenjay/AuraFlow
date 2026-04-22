import 'package:hive/hive.dart';
import 'package:just_audio/just_audio.dart';
import '../../ambience/../../data/models/ambience_model.dart';

class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;

  AudioService._internal();

  final AudioPlayer player = AudioPlayer();

  Ambience? current;

  Box get _sessionBox => Hive.box('sessionBox');

  Future<void> play(Ambience item) async {
    if (current?.audio != item.audio) {
      await player.setAsset(item.audio);
      await player.setLoopMode(LoopMode.one);
      current = item;
    }
    await player.play();
    await _sessionBox.put('activeSession', item.toJson());
  }

  Future<void> pause() async {
    await player.pause();
  }

  Future<void> stop() async {
    await player.stop();
    current = null;
    await _sessionBox.delete('activeSession');
  }
}