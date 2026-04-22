import 'package:auraflow/core/widgets/app_shell.dart';
import 'package:auraflow/features/ambience/screens/home_screen.dart';
import 'package:auraflow/features/onboarding/screens/splash_screen.dart';
import 'package:go_router/go_router.dart';

import '../data/models/ambience_model.dart';
import '../features/ambience/screens/ambience_details_screen.dart';
import '../features/journal/screens/journal_screen.dart';
import '../features/journal/screens/journal_history_screen.dart';
import '../features/journal/screens/journal_detail_screen.dart';
import '../features/journal/models/journal_entry.dart';
import '../features/player/screens/player_screen.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
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
      GoRoute(
        path: '/journal',
        name: 'journal',
        builder: (context, state) {
          final title = state.extra as String;
          return AppShell(child: JournalScreen(title: title));
        },
      ),
      GoRoute(
        path: '/history',
        name: 'history',
        builder: (context, state) =>
            AppShell(child: const JournalHistoryScreen()),
      ),
      GoRoute(
        path: '/journal-detail',
        name: 'journal-detail',
        builder: (context, state) {
          final entry = state.extra as JournalEntry;
          return AppShell(child: JournalDetailScreen(entry: entry));
        },
      ),
    ],
  );
}