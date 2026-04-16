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
            return ListView.builder(
              itemCount: state.ambiences.length,
              itemBuilder: (context,index){
                final item=state.ambiences[index];
                return ListTile(
                  leading: Image.asset(item.image, width: 50,),
                  title: Text(item.title),
                  subtitle: Text("${item.tag} • ${item.duration}s"),
                );
              },
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