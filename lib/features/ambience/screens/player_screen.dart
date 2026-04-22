import 'package:flutter/material.dart';
import '../../../data/models/ambience_model.dart';

class PlayerScreen extends StatefulWidget {
  final Ambience item;

  const PlayerScreen({super.key, required this.item});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  bool isPlaying = false;
  double progress = 0.3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
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

          CircleAvatar(
            radius: 35,
            backgroundColor: Colors.blue,
            child: IconButton(
              icon: Icon(
                isPlaying ? Icons.pause : Icons.play_arrow,
                color: Colors.white,
                size: 30,
              ),
              onPressed: () {
                setState(() {
                  isPlaying = !isPlaying;
                });
              },
            ),
          ),

          const SizedBox(height: 30),

          Slider(
            value: progress,
            onChanged: (value) {
              setState(() {
                progress = value;
              });
            },
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text("0:30"),
                Text("3:00"),
              ],
            ),
          ),

          const SizedBox(height: 30),

          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("End Session"),
          ),
        ],
      ),
    );
  }
}