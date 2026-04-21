import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../data/models/ambience_model.dart';

class FeaturedCard extends StatelessWidget {
  final Ambience item;

  const FeaturedCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.pushNamed(
          'details',
          extra: item,
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            children: [

              Image.asset(
                item.image,
                height: 220,
                width: double.infinity,
                fit: BoxFit.cover,
              ),

              Container(
                height: 220,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.7),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),

              Positioned(
                bottom: 16,
                left: 16,
                right: 70,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.tag.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 10,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "${item.duration ~/ 60} min",
                      style: const TextStyle(
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),

              Positioned(
                bottom: 16,
                right: 16,
                child: CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.blue,
                  child: const Icon(
                    Icons.play_arrow,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}