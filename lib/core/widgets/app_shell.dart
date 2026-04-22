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
    final isPlayerScreen = location == '/player';
    final audioService = AudioService();

    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 90),
            child: child,
          ),

          // Mini-player — sits above nav bar, only when session active
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
                    final progress = total.inSeconds > 0
                        ? position.inSeconds / total.inSeconds
                        : 0.0;

                    return Positioned(
                      bottom: 100,
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

          // Bottom Nav Bar — always visible
          Positioned(
            bottom: 12,
            left: 20,
            right: 20,
            child: _BottomNavBar(location: location),
          ),
        ],
      ),
    );
  }
}

// ─── Nav Bar ─────────────────────────────────────────────────────────────────

class _BottomNavBar extends StatelessWidget {
  final String location;

  const _BottomNavBar({required this.location});

  @override
  Widget build(BuildContext context) {
    final audioService = AudioService();

    final items = [
      _NavDef(
        asset: 'assets/nav/home.png',
        label: 'HOME',
        isActive: location == '/',
        onTap: () => context.goNamed('home'),
      ),
      _NavDef(
        asset: 'assets/nav/player.png',
        label: 'PLAYER',
        isActive: location == '/player',
        onTap: () {
          final current = audioService.current;
          if (current != null) {
            context.pushNamed('player', extra: current);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('No active session. Start an ambience first.'),
                duration: Duration(seconds: 2),
              ),
            );
          }
        },
      ),
      _NavDef(
        asset: 'assets/nav/journal.png',
        label: 'JOURNAL',
        isActive: location == '/journal',
        onTap: () => context.pushNamed(
          'journal',
          extra: 'Daily Reflection',
        ),
      ),
      _NavDef(
        asset: 'assets/nav/history.png',
        label: 'HISTORY',
        isActive: location == '/history',
        onTap: () => context.pushNamed('history'),
      ),
    ];

    return Container(
      height: 76,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(40),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.10),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: items
            .map((def) => _NavItem(def: def))
            .toList(),
      ),
    );
  }
}

// ─── Single Nav Item ──────────────────────────────────────────────────────────

class _NavDef {
  final String asset;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavDef({
    required this.asset,
    required this.label,
    required this.isActive,
    required this.onTap,
  });
}

class _NavItem extends StatelessWidget {
  final _NavDef def;

  const _NavItem({required this.def});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: def.onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 68,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: def.isActive ? 52 : 28,
              height: def.isActive ? 52 : 28,
              decoration: BoxDecoration(
                color: def.isActive
                    ? const Color(0xFF2D4B6B)
                    : Colors.transparent,
                shape: BoxShape.circle,
              ),
              padding: EdgeInsets.all(def.isActive ? 14 : 0),
              child: Image.asset(
                def.asset,
                color: def.isActive ? Colors.white : Colors.grey.shade400,
              ),
            ),
            const SizedBox(height: 4),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                fontSize: def.isActive ? 9 : 9,
                letterSpacing: 0.8,
                fontWeight: FontWeight.w600,
                color: def.isActive
                    ? const Color(0xFF2D4B6B)
                    : Colors.grey.shade400,
              ),
              child: Text(def.label),
            ),
          ],
        ),
      ),
    );
  }
}