import 'package:auraflow/routes/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'data/repositories/ambience_repository.dart';
import 'features/ambience/bloc/ambience_bloc.dart';
import 'features/ambience/screens/home_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  await Hive.openBox('journalBox');
  await Hive.openBox('sessionBox');

  runApp(const AuraFlowApp());
}
class AuraFlowApp extends StatelessWidget {
  const AuraFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (_)=> AmbienceBloc(AmbienceRepository()),
          ),
        ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: AppRouter.router,
      ),
    );
  }
}