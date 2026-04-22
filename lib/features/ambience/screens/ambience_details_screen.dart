import 'package:auraflow/data/models/ambience_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AmbienceDetailScreen extends StatelessWidget{
  final Ambience item;

  const AmbienceDetailScreen({super.key,required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            height: 300,
            width: double.infinity,
            child: Image.asset(
              item.image,
              fit: BoxFit.cover,
            ),
          ),

          Positioned(
            top: 50,
            left: 16,
            child: CircleAvatar(
              backgroundColor: Colors.black.withOpacity(0.5),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white,),
                onPressed: ()=>Navigator.pop(context),
              ),
            ),
          ),

          DraggableScrollableSheet(
            initialChildSize: 0.65,
            minChildSize: 0.65,
            maxChildSize: 0.9,
            builder: (context,scrollController){
              return Container(
                padding: EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                ),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade100,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          item.tag,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),

                      SizedBox(height: 12,),

                      Text(
                        item.title,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      SizedBox(height: 8,),

                      Text(
                        "${item.duration ~/ 60} min session",
                        style: const TextStyle(color: Colors.grey),
                      ),

                      const SizedBox(height: 16,),

                      Text(
                        item.description,
                        style: const TextStyle(fontSize: 14),
                      ),

                      const SizedBox(height: 20,),

                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: item.sensoryTags.map(
                            (tag)=>Chip(
                              label: Text(tag),
                              backgroundColor: Colors.grey.shade200,
                            ),
                        ).toList()
                      ),

                      const SizedBox(height: 30,),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: (){
                            context.pushNamed(
                              'player',
                              extra: item,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Text(
                            "Start Session",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            }
          )
        ],
      ),
    );
  }
}