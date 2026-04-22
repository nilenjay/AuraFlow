import 'package:auraflow/features/ambience/screens/home_screen.dart';
import 'package:go_router/go_router.dart';

import '../data/models/ambience_model.dart';
import '../features/ambience/screens/ambience_details_screen.dart';
import '../features/ambience/screens/player_screen.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context,state)=> const HomeScreen(),
      ),
      GoRoute(
        path: '/details',
        name: 'details',
        builder: (context,state){
          final item=state.extra as Ambience;
          return AmbienceDetailScreen(item: item);
        }
      ),
      GoRoute(
        path: '/player',
        name: 'player',
        builder: (context, state) {
          final item = state.extra as Ambience;
          return PlayerScreen(item: item);
        },
      ),
    ]
  );
}