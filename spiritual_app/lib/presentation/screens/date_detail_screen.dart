import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../domain/models/lunar_date.dart';

const dataDetailTitles = [
  "Giờ Hoàng Đạo",
  "Giờ Hắc Đạo",
  "Việc Nên - Không Nên",
  "Các Ngày Kỵ",
  "Ngũ Hành",
  "Bành Tổ Bách Kỵ Nhật",
  "Khổng Minh Lục Diệu",
  "Nhị Thập Bát Tú",
  "Thập Nhị Kiến Trừ",
  "Ngọc Hạp Thông Thư",
  "Hướng xuất hành",
  "Giờ xuất hành Theo Lý Thuần Phong",
];

class DateDetailScreen extends StatelessWidget {
  final LunarDate lunarDate;

  const DateDetailScreen({super.key, required this.lunarDate});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.ivory,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: AppColors.textPrimary,
          ),
          onPressed: () => context.pop(),
        ),
        title: const Text('Luận Giải Chi Tiết'),
        backgroundColor: AppColors.ivory,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Date Array Section
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.warmPaper,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.gold.withValues(alpha: 0.2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(lunarDate.rawDate.length, (index) {
                  String text = lunarDate.rawDate[index];
                  if (index == 0) text = 'Dương lịch: $text';
                  if (index == 1) text = 'Âm lịch: $text';

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: Text(
                      text,
                      style: AppTypography.body.copyWith(
                        fontWeight: index < 2
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  );
                }),
              ),
            ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1),

            AppSpacing.gap32,

            // Data Array Section with Titles
            ...List.generate(lunarDate.rawData.length, (index) {
              final title = index < dataDetailTitles.length
                  ? dataDetailTitles[index]
                  : 'Thông tin khác';
              final content = lunarDate.rawData[index];
              return _buildDataSection(
                title,
                content,
                delayMs: 200 + (index * 50),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildDataSection(
    String title,
    String content, {
    required int delayMs,
  }) {
    if (content.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 4,
                height: 16,
                decoration: BoxDecoration(
                  color: AppColors.templeRed,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              AppSpacing.gap8,
              Expanded(
                child: Text(
                  title,
                  style: AppTypography.section.copyWith(fontSize: 18),
                ),
              ),
            ],
          ),
          AppSpacing.gap8,
          Text(
            content,
            style: AppTypography.body.copyWith(
              height: 1.6,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ).animate().fadeIn(delay: delayMs.ms).slideX(begin: 0.05),
    );
  }
} // EOF
