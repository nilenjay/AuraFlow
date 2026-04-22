import 'package:just_audio/just_audio.dart';
import '../../ambience/../../data/models/ambience_model.dart';

class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;

  AudioService._internal();

  final AudioPlayer player = AudioPlayer();

  Ambience? current;

  Future<void> play(Ambience item) async {
    if (current?.audio != item.audio) {
      await player.setAsset(item.audio);
      current = item;
    }
    await player.play();
  }

  Future<void> pause() async {
    await player.pause();
  }

  Future<void> stop() async {
    await player.stop();
    current = null;
  }
}