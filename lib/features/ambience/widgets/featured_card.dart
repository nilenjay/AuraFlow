import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../data/models/ambience_model.dart';

class FeaturedCard extends StatelessWidget{
  final Ambience item;

  const FeaturedCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
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
              right: 16,
              child: Text(
                item.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Positioned(
              bottom: 16,
              right: 16,
              child: CircleAvatar(
                backgroundColor: Colors.blue,
                child: const Icon(Icons.play_arrow, color: Colors.white,),
              ),
            ),
          ],
        ),
      ),
    );
  }

}