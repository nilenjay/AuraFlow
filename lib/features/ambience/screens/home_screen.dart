import 'package:auraflow/features/ambience/bloc/ambience_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/ambience_event.dart';
import '../bloc/ambience_state.dart';

class HomeScreen extends StatefulWidget{
  const HomeScreen({super.key});
  
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AmbienceBloc>().add(LoadAmbience());
  }
  String searchQuery = "";
  String selectedTag = "All";
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("AuraFlow"),),
      
      body: BlocBuilder<AmbienceBloc, AmbienceState>(
        builder: (context, state) {
          if(state is AmbienceLoading){
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          else if(state is AmbienceLoaded){
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value.toLowerCase();
                      });
                    },
                    decoration: InputDecoration(
                      hintText: "Search ambiences...",
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),

                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: ["All", "Focus", "Calm", "Sleep", "Reset"]
                        .map((tag) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(tag),
                        selected: selectedTag == tag,
                        onSelected: (_) {
                          setState(() {
                            selectedTag = tag;
                          });
                        },
                      ),
                    ))
                        .toList(),
                  ),
                ),

                const SizedBox(height: 10),

                Expanded(
                  child: Builder(
                    builder: (context) {
                      final filtered = state.ambiences.where((item) {
                        final matchesSearch =
                        item.title.toLowerCase().contains(searchQuery);

                        final matchesTag =
                            selectedTag == "All" || item.tag == selectedTag;

                        return matchesSearch && matchesTag;
                      }).toList();

                      if (filtered.isEmpty) {
                        return const Center(child: Text("No ambiences found"));
                      }

                      return GridView.builder(
                        padding: const EdgeInsets.all(16),
                        gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 0.75,
                        ),
                        itemCount: filtered.length,
                        itemBuilder: (context, index) {
                          final item = filtered[index];

                          return ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Stack(
                              children: [
                                Image.asset(
                                  item.image,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                ),

                                Container(
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
                                  bottom: 12,
                                  left: 12,
                                  right: 12,
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.title,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        "${item.tag} • ${item.duration ~/ 60} min",
                                        style: const TextStyle(
                                            color: Colors.white70),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          }
          else if(state is AmbienceError){
            return Center(child: Text(state.message),);
          }
          return const SizedBox();
        }
      ),
    );
  }
  
}