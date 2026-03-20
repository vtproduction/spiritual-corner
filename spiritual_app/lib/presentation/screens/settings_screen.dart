import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/settings_provider.dart';
import '../../core/theme/app_colors.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);
    final theme = Theme.of(context);

    // Some preset colors for the color picker
    final presetColors = [
      AppColors.templeRed,   // Default red
      AppColors.gold,        // Gold
      Colors.blue.shade700,
      Colors.green.shade700,
      Colors.purple.shade700,
      Colors.teal.shade700,
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cài đặt'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Notifications Toggle
          Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: SwitchListTile(
              title: const Text('Thông báo'),
              subtitle: const Text('Nhận thông báo nhắc nhở hàng ngày'),
              value: settings.notificationsEnabled,
              activeThumbColor: theme.colorScheme.primary,
              onChanged: (value) {
                notifier.toggleNotifications(value);
              },
            ),
          ),

          // Theme Selector
          Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Giao diện', style: theme.textTheme.titleMedium),
                  const SizedBox(height: 12),
                  SegmentedButton<ThemeMode>(
                    segments: const [
                      ButtonSegment(value: ThemeMode.system, label: Text('Hệ thống')),
                      ButtonSegment(value: ThemeMode.light, label: Text('Sáng')),
                      ButtonSegment(value: ThemeMode.dark, label: Text('Tối')),
                    ],
                    selected: {settings.themeMode},
                    onSelectionChanged: (Set<ThemeMode> newSelection) {
                      notifier.updateThemeMode(newSelection.first);
                    },
                    style: SegmentedButton.styleFrom(
                      backgroundColor: theme.colorScheme.surface,
                      selectedBackgroundColor: theme.colorScheme.primary.withValues(alpha: 0.2),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Color Selector
          Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Màu chủ đạo', style: theme.textTheme.titleMedium),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 50,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: presetColors.length,
                      separatorBuilder: (context, index) => const SizedBox(width: 12),
                      itemBuilder: (context, index) {
                        final color = presetColors[index];
                        final isSelected = settings.appColor.toARGB32() == color.toARGB32();
                        
                        return GestureDetector(
                          onTap: () => notifier.updateAppColor(color),
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isSelected ? theme.colorScheme.onSurface : Colors.transparent,
                                width: isSelected ? 3 : 0,
                              ),
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: color.withValues(alpha: 0.4),
                                        blurRadius: 8,
                                        spreadRadius: 2,
                                      )
                                    ]
                                  : null,
                            ),
                            child: isSelected 
                                ? Icon(Icons.check, color: color.computeLuminance() > 0.5 ? Colors.black : Colors.white) 
                                : null,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
