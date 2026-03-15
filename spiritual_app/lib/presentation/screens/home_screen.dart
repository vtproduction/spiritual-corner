import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../data/repositories/lunar_calendar_repository.dart';
import '../../domain/models/lunar_date.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  String _getVietnameseWeekday(int weekday) {
    switch (weekday) {
      case DateTime.monday: return 'Thứ Hai';
      case DateTime.tuesday: return 'Thứ Ba';
      case DateTime.wednesday: return 'Thứ Tư';
      case DateTime.thursday: return 'Thứ Năm';
      case DateTime.friday: return 'Thứ Sáu';
      case DateTime.saturday: return 'Thứ Bảy';
      case DateTime.sunday: return 'Chủ Nhật';
      default: return '';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todayLunarAsync = ref.watch(todayLunarDateProvider);
    final now = DateTime.now();

    return Scaffold(
      backgroundColor: AppColors.ivory,
      body: SafeArea(
        child: todayLunarAsync.when(
          data: (lunarDate) {
            if (lunarDate == null) {
              return Center(
                child: Text('Không có dữ liệu', style: AppTypography.body),
              );
            }
            return _buildContent(context, lunarDate, now);
          },
          loading: () => const Center(
            child: CircularProgressIndicator(color: AppColors.templeRed),
          ),
          error: (err, stack) => Center(
            child: Text('Lỗi tải dữ liệu', style: AppTypography.body),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, LunarDate lunarDate, DateTime now) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 48.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Top Section: Day of week & Solar Date
            Center(
              child: Column(
                children: [
                  Text(
                    _getVietnameseWeekday(now.weekday).toUpperCase(),
                    style: AppTypography.small.copyWith(
                      color: AppColors.templeRed,
                      letterSpacing: 3,
                      fontWeight: FontWeight.w600,
                    ),
                  ).animate().fadeIn(duration: 600.ms, curve: Curves.easeOut).slideY(begin: -0.2),
                  AppSpacing.gap8,
                  Text(
                    'Ngày ${now.day} Tháng ${now.month} Năm ${now.year}',
                    style: AppTypography.body.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ).animate().fadeIn(delay: 200.ms, duration: 600.ms),
                ],
              ),
            ),
            
            AppSpacing.gap48,
            
            // Middle Section: Lunar Highlighting
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: AppColors.white.withValues(alpha:0.5),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.gold.withValues(alpha:0.2)),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.gold.withValues(alpha:0.05),
                    blurRadius: 30,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    'ÂM LỊCH',
                    style: AppTypography.caption.copyWith(
                      letterSpacing: 2,
                    ),
                  ),
                  AppSpacing.gap16,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        '${lunarDate.lunarDay}',
                        style: AppTypography.hero.copyWith(
                          fontSize: 84,
                          height: 1.0,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      AppSpacing.gap8,
                      Text(
                        '/${lunarDate.lunarMonth}',
                        style: AppTypography.title.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  if (lunarDate.lunarLeap == '1') ...[
                    AppSpacing.gap4,
                    Text('(Tháng Nhuận)', style: AppTypography.small),
                  ],
                  AppSpacing.gap24,
                  // Divider
                  Container(
                    height: 1,
                    width: 60,
                    color: AppColors.gold.withValues(alpha:0.5),
                  ),
                  AppSpacing.gap24,
                  Text(
                    lunarDate.hoangDaoTime.isNotEmpty
                        ? '${lunarDate.hoangDaoTime.split(' ').take(5).join(' ')}...' 
                        : 'Năm ${lunarDate.lunarYear}',
                    textAlign: TextAlign.center,
                    style: AppTypography.body.copyWith(
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 400.ms, duration: 800.ms).scale(begin: const Offset(0.95, 0.95)),

            AppSpacing.gap48,

            // Bottom Section: Details
            _buildDetailRow('Ngũ Hành', lunarDate.nguHanh)
                .animate().fadeIn(delay: 600.ms).slideX(begin: 0.1),
            AppSpacing.gap16,
            _buildDetailRow('Hướng Xuất Hành', lunarDate.huongXuatHanh)
                .animate().fadeIn(delay: 700.ms).slideX(begin: 0.1),
            AppSpacing.gap16,
            _buildDetailRow('Giờ Hoàng Đạo', lunarDate.hoangDaoTime)
                .animate().fadeIn(delay: 800.ms).slideX(begin: 0.1),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    if (value.isEmpty) return const SizedBox.shrink();
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: AppTypography.small.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            value,
            style: AppTypography.body,
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}
