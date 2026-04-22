import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:just_audio/just_audio.dart';
import '../../../data/models/ambience_model.dart';
import '../services/audio_service.dart';

class PlayerScreen extends StatefulWidget {
  final Ambience item;

  const PlayerScreen({super.key, required this.item});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  final audioService = AudioService();

  @override
  void initState() {
    super.initState();

    if (audioService.current?.audio != widget.item.audio) {
      audioService.play(widget.item);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [

            SizedBox(
              height: 300,
              width: double.infinity,
              child: Image.asset(
                widget.item.image,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 20),

            Text(
              widget.item.title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              "${widget.item.duration ~/ 60} min session",
              style: const TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 30),

            StreamBuilder<PlayerState>(
              stream: audioService.player.playerStateStream,
              builder: (context, snapshot) {
                final isPlaying = snapshot.data?.playing ?? false;

                return CircleAvatar(
                  radius: 35,
                  backgroundColor: Colors.blue,
                  child: IconButton(
                    icon: Icon(
                      isPlaying ? Icons.pause : Icons.play_arrow,
                      color: Colors.white,
                      size: 30,
                    ),
                    onPressed: () async {
                      if (isPlaying) {
                        await audioService.pause();
                      } else {
                        await audioService.player.play();
                      }
                    },
                  ),
                );
              },
            ),

            const SizedBox(height: 30),

            StreamBuilder<Duration>(
              stream: audioService.player.positionStream,
              builder: (context, snapshot) {
                final position = snapshot.data ?? Duration.zero;
                final total =
                    audioService.player.duration ?? Duration.zero;

                return Column(
                  children: [

                    Slider(
                      value: position.inSeconds.toDouble(),
                      max: total.inSeconds > 0
                          ? total.inSeconds.toDouble()
                          : 1,
                      onChanged: (value) async {
                        await audioService.player.seek(
                          Duration(seconds: value.toInt()),
                        );
                      },
                    ),

                    Padding(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: [
                          Text(_formatTime(position)),
                          Text(_formatTime(total)),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: () async {
                await audioService.stop();
                context.pop();
              },
              child: const Text("End Session"),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(Duration d) {
    final minutes = d.inMinutes;
    final seconds = d.inSeconds % 60;
    return "$minutes:${seconds.toString().padLeft(2, '0')}";
  }
}