import 'package:auraflow/features/ambience/screens/home_screen.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context,state)=> const HomeScreen(),
      ),
    ]
  );
}