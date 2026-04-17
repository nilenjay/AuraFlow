import 'package:auraflow/features/ambience/bloc/ambience_bloc.dart';
import 'package:auraflow/features/ambience/widgets/featured_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/ambience_event.dart';
import '../bloc/ambience_state.dart';
import '../widgets/ambience_list_card.dart';

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
      appBar: null,
      
      body: BlocBuilder<AmbienceBloc, AmbienceState>(
        builder: (context, state) {
          if(state is AmbienceLoading){
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          else if(state is AmbienceLoaded){
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
                          "Sanctuary",
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

                  const SizedBox(height: 20),

                  FeaturedCard(item: state.ambiences.first),

                  const SizedBox(height: 20),

                  ...state.ambiences.skip(1).map(
                        (item) => AmbienceListCard(item: item),
                  ),
                ],
              ),
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