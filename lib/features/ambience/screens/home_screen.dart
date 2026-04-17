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
            return Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.8,
                ),
                itemCount: state.ambiences.length,
                itemBuilder: (context,index){
                  final item=state.ambiences[index];

                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      image: DecorationImage(
                        image: AssetImage(item.image),
                        fit: BoxFit.cover,
                      )
                    ),
                    child: Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: LinearGradient(
                            colors: [
                              Colors.black.withOpacity(0.1),
                              Colors.black.withOpacity(0.6),
                            ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "${item.tag} • ${item.duration}s",
                            style: const TextStyle(color: Colors.white70),
                          )
                        ],
                      ),
                    ),
                  );
                },
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