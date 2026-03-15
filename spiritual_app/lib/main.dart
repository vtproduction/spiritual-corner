import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'presentation/routing/app_router.dart';

void main() {
  runApp(
    const ProviderScope(
      child: SpiritualsCornerApp(),
    ),
  );
}

class SpiritualsCornerApp extends StatelessWidget {
  const SpiritualsCornerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Spirituals Corner',
      theme: AppTheme.lightTheme,
      routerConfig: appRouter,
    );
  }
}
