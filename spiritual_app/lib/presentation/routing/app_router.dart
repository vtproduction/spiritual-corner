
import 'package:go_router/go_router.dart';
import '../screens/calendar_screen.dart';
import '../screens/home_screen.dart';
import '../screens/prayer_screen.dart';
import '../screens/prayer_detail_screen.dart';
import '../screens/teleprompter_screen.dart';
import '../widgets/main_layout.dart';
import '../../domain/models/prayer.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return MainLayout(child: child);
      },
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/calendar',
          builder: (context, state) => const CalendarScreen(),
        ),
        GoRoute(
          path: '/prayers',
          builder: (context, state) => const PrayerScreen(),
          routes: [
            GoRoute(
              path: 'detail/:id',
              builder: (context, state) {
                final id = state.pathParameters['id']!;
                return PrayerDetailScreen(prayerId: id);
              },
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: '/teleprompter',
      builder: (context, state) {
        final prayer = state.extra as Prayer;
        return TeleprompterScreen(prayer: prayer);
      },
    ),
  ],
);
