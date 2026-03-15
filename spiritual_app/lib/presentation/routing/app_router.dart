import 'package:go_router/go_router.dart';
import '../screens/calendar_screen.dart';
import '../screens/home_screen.dart';
import '../screens/prayer_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
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
    ),
  ],
);
