import 'package:auraflow/routes/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'data/models/ambience_model.dart';
import 'data/repositories/ambience_repository.dart';
import 'features/ambience/bloc/ambience_bloc.dart';
import 'features/ambience/screens/home_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'features/journal/bloc/journal_bloc.dart';
import 'features/journal/repository/journal_repository.dart';
import 'features/player/services/audio_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  await Hive.openBox('journalBox');
  await Hive.openBox('sessionBox');

  final sessionBox = Hive.box('sessionBox');
  final savedSession = sessionBox.get('activeSession');
  if (savedSession != null) {
    final item = Ambience.fromJson(Map<String, dynamic>.from(savedSession as Map));
    AudioService().current = item;
  }

  runApp(const AuraFlowApp());
}
final themeNotifier = ValueNotifier<ThemeMode>(ThemeMode.light);

class AuraFlowApp extends StatelessWidget {
  const AuraFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (_) => AmbienceBloc(AmbienceRepository()),
          ),
          BlocProvider(
            create: (_) => JournalBloc(JournalRepository()),
          ),
        ],
      child: ValueListenableBuilder<ThemeMode>(
        valueListenable: themeNotifier,
        builder: (context, mode, _) => MaterialApp.router(
          debugShowCheckedModeBanner: false,
          themeMode: mode,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
            useMaterial3: true,
          ),
          darkTheme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.blueGrey,
              brightness: Brightness.dark,
            ),
            useMaterial3: true,
          ),
          routerConfig: AppRouter.router,
        ),
      ),
    );
  }
}