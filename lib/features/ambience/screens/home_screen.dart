import 'package:auraflow/features/ambience/bloc/ambience_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/ambience_event.dart';
import '../bloc/ambience_state.dart';
import '../widgets/featured_card.dart';
import '../widgets/ambience_list_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String searchQuery = "";
  String selectedTag = "All";

  @override
  void initState() {
    super.initState();
    context.read<AmbienceBloc>().add(LoadAmbience());
  }

  void _applyFilter() {
    context.read<AmbienceBloc>().add(
      FilterAmbiences(
        query: searchQuery,
        tag: selectedTag,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AmbienceBloc, AmbienceState>(
        builder: (context, state) {
          if (state is AmbienceLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          else if (state is AmbienceLoaded) {

            final list = state.filteredAmbiences;

            if (list.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.search_off,
                        size: 60, color: Colors.grey.shade400),
                    const SizedBox(height: 16),
                    const Text(
                      "No ambiences found",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Try changing filters",
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          searchQuery = "";
                          selectedTag = "All";
                        });
                        _applyFilter();
                      },
                      child: const Text("Clear Filters"),
                    ),
                  ],
                ),
              );
            }

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 50, 16, 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Icon(Icons.menu),
                        const Text(
                          "AuraFlow",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const CircleAvatar(radius: 18),
                      ],
                    ),
                  ),

                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      "Find your calm",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TextField(
                      onChanged: (value) {
                        searchQuery = value;
                        _applyFilter();
                      },
                      decoration: InputDecoration(
                        hintText: "Search ambience...",
                        prefixIcon: const Icon(Icons.search),
                        filled: true,
                        fillColor: Colors.grey.shade200,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

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
                          selectedColor: Colors.blue.shade100,
                          onSelected: (_) {
                            setState(() {
                              selectedTag = tag;
                            });
                            _applyFilter();
                          },
                        ),
                      ))
                          .toList(),
                    ),
                  ),

                  const SizedBox(height: 20),

                  FeaturedCard(item: list.first),

                  const SizedBox(height: 20),

                  ...list.skip(1).map(
                        (item) => AmbienceListCard(item: item),
                  ),
                ],
              ),
            );
          }

          else if (state is AmbienceError) {
            return Center(child: Text(state.message));
          }

          return const SizedBox();
        },
      ),
    );
  }
}