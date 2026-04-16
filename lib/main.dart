import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'data/repositories/ambience_repository.dart';
import 'features/ambience/bloc/ambience_bloc.dart';
import 'features/ambience/screens/home_screen.dart';

void main() {
  runApp(const AuraFlowApp());
}

class AuraFlowApp extends StatelessWidget {
  const AuraFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BlocProvider(
        create: (_) => AmbienceBloc(AmbienceRepository()),
        child: const HomeScreen(),
      ),
    );
  }
}