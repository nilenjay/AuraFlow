import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../data/models/ambience_model.dart';

class AmbienceListCard extends StatelessWidget{
  final Ambience item;
  
  const AmbienceListCard({super.key, required this.item});
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16,0,16,16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
              child: Image.asset(
                item.image,
                height: 140,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(item.title),
            )
          ],
        ),
      ),
    );
  }
}