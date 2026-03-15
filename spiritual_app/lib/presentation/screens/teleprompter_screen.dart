import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../domain/models/prayer.dart';

class TeleprompterScreen extends StatelessWidget {
  final Prayer prayer;

  const TeleprompterScreen({super.key, required this.prayer});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.ivory,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: const Text('Đọc Văn Khấn'),
        backgroundColor: AppColors.ivory,
        elevation: 0,
      ),
      body: Center(
        child: Text(
          'Màn hình đọc: ${prayer.name}\n(Đang hoàn thiện - Phase 7)',
          textAlign: TextAlign.center,
          style: AppTypography.body,
        ),
      ),
    );
  }
} // EOF
