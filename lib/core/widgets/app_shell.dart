import 'package:auraflow/features/player/widgets/mini_player.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:just_audio/just_audio.dart';
import 'package:auraflow/features/player/services/audio_service.dart';

class AppShell extends StatelessWidget {
  final Widget child;

  const AppShell({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    final isPlayerScreen = location == '/player'; // ✅ FIXED
    final audioService = AudioService();

    return Scaffold(
      body: Stack(
        children: [
          child,

          if (!isPlayerScreen)
            StreamBuilder<PlayerState>(
              stream: audioService.player.playerStateStream,
              builder: (context, snapshot) {
                final current = audioService.current;

                if (current == null) return const SizedBox();

                final isPlaying = snapshot.data?.playing ?? false;

                return StreamBuilder<Duration>(
                  stream: audioService.player.positionStream,
                  builder: (context, snapshot) {
                    final position = snapshot.data ?? Duration.zero;
                    final total =
                        audioService.player.duration ?? Duration.zero;

                    double progress = 0.0;

                    if (total.inSeconds > 0) {
                      progress =
                          position.inSeconds / total.inSeconds;
                    }

                    return Positioned(
                      bottom: 10,
                      left: 0,
                      right: 0,
                      child: MiniPlayer(
                        title: current.title,
                        isPlaying: isPlaying,
                        progress: progress,
                        item: current,
                        onPlayPause: () async {
                          if (isPlaying) {
                            await audioService.pause();
                          } else {
                            await audioService.player.play();
                          }
                        },
                        onClose: () async {
                          await audioService.stop();
                        },
                      ),
                    );
                  },
                );
              },
            ),
        ],
      ),
    );
  }
}