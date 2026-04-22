import 'package:auraflow/core/widgets/app_shell.dart';
import 'package:auraflow/features/ambience/screens/home_screen.dart';
import 'package:go_router/go_router.dart';

import '../data/models/ambience_model.dart';
import '../features/ambience/screens/ambience_details_screen.dart';
import '../features/player/screens/player_screen.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/',
    routes: [

      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => AppShell(
          child: const HomeScreen(),
        ),
      ),

      GoRoute(
        path: '/details',
        name: 'details',
        builder: (context, state) {
          final item = state.extra as Ambience;

          return AppShell(
            child: AmbienceDetailScreen(item: item),
          );
        },
      ),

      GoRoute(
        path: '/player',
        name: 'player',
        builder: (context, state) {
          final item = state.extra as Ambience;

          return AppShell(
            child: PlayerScreen(item: item),
          );
        },
      ),
    ],
  );
}