import 'dart:async';
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

class _PlayerScreenState extends State<PlayerScreen>
    with TickerProviderStateMixin {
  final audioService = AudioService();
  late int _elapsed;
  Timer? _timer;
  late AnimationController _breathController;
  late Animation<double> _breathAnim;

  @override
  void initState() {
    super.initState();
    _elapsed = 0;

    _breathController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
    _breathAnim = Tween<double>(begin: 0.1, end: 0.4).animate(
      CurvedAnimation(parent: _breathController, curve: Curves.easeInOut),
    );

    if (audioService.current?.audio != widget.item.audio) {
      audioService.play(widget.item);
    }

    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() => _elapsed++);

      if (_elapsed >= widget.item.duration) {
        _timer?.cancel();
        _endSession();
      }
    });
  }

  void _endSession() async {
    await audioService.stop();
    if (mounted) {
      context.pushNamed('journal', extra: widget.item.title);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _breathController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final total = Duration(seconds: widget.item.duration);
    final position = Duration(seconds: _elapsed);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [

            SizedBox(
              height: 300,
              width: double.infinity,
              child: AnimatedBuilder(
                animation: _breathAnim,
                builder: (context, child) {
                  return Stack(
                    children: [
                      child!,
                      Container(
                        decoration: BoxDecoration(
                          gradient: RadialGradient(
                            colors: [
                              Colors.white.withOpacity(_breathAnim.value),
                              Colors.transparent,
                            ],
                            radius: 1.2,
                          ),
                        ),
                      ),
                    ],
                  );
                },
                child: Image.asset(
                  widget.item.image,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 300,
                ),
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
                        _timer?.cancel();
                        await audioService.pause();
                      } else {
                        await audioService.player.play();
                        _startTimer();
                      }
                    },
                  ),
                );
              },
            ),

            const SizedBox(height: 30),

            Column(
              children: [
                Slider(
                  value: _elapsed.toDouble(),
                  max: widget.item.duration.toDouble(),
                  onChanged: (value) {
                    setState(() => _elapsed = value.toInt());
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(_formatTime(position)),
                      Text(_formatTime(total)),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text("End Session?"),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, false),
                        child: const Text("Cancel"),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, true),
                        child: const Text("End"),
                      ),
                    ],
                  ),
                );
                if (confirm == true) {
                  _timer?.cancel();
                  await audioService.stop();
                  if (mounted) {
                    context.pushNamed('journal', extra: widget.item.title);
                  }
                }
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
