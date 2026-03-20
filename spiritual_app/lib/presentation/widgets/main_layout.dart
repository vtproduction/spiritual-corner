import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_colors.dart';


class MainLayout extends StatelessWidget {
  final Widget child;

  const MainLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.ivory,
      body: child,
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    // Determine the current index based on the route
    final String location = GoRouterState.of(context).uri.path;
    int currentIndex = 0;
    if (location.startsWith('/calendar')) {
      currentIndex = 1;
    } else if (location.startsWith('/prayers')) {
      currentIndex = 2;
    } else if (location.startsWith('/settings')) {
      currentIndex = 3;
    }

    // Determine the color theme
    final indicatorColor = Theme.of(context).colorScheme.primary.withValues(alpha: 0.3);
    final selectedIconColor = Theme.of(context).colorScheme.primary;

    return NavigationBar(
      selectedIndex: currentIndex,
      backgroundColor: Theme.of(context).colorScheme.surface,
      indicatorColor: indicatorColor,
      onDestinationSelected: (index) {
        switch (index) {
          case 0:
            context.go('/');
            break;
          case 1:
            context.go('/calendar');
            break;
          case 2:
            context.go('/prayers');
            break;
          case 3:
            context.go('/settings');
            break;
        }
      },
      destinations: [
        NavigationDestination(
          icon: const Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home, color: selectedIconColor),
          label: 'Hôm nay',
        ),
        NavigationDestination(
          icon: const Icon(Icons.calendar_month_outlined),
          selectedIcon: Icon(Icons.calendar_month, color: selectedIconColor),
          label: 'Lịch Âm',
        ),
        NavigationDestination(
          icon: const Icon(Icons.menu_book_outlined),
          selectedIcon: Icon(Icons.menu_book, color: selectedIconColor),
          label: 'Văn Khấn',
        ),
        NavigationDestination(
          icon: const Icon(Icons.settings_outlined),
          selectedIcon: Icon(Icons.settings, color: selectedIconColor),
          label: 'Cài đặt',
        ),
      ],
    ).animate().slideY(begin: 1.0, duration: 600.ms, curve: Curves.easeOutQuart);
  }
}
