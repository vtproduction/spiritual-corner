import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../data/repositories/lunar_calendar_repository.dart';
import '../../domain/models/lunar_date.dart';

final selectedDateProvider = StateProvider<DateTime>((ref) => DateTime.now());
final displayedMonthProvider = StateProvider<DateTime>((ref) {
  final now = DateTime.now();
  return DateTime(now.year, now.month, 1);
});

class CalendarScreen extends ConsumerWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final calendarAsync = ref.watch(lunarCalendarProvider);
    final displayedMonth = ref.watch(displayedMonthProvider);

    return Scaffold(
      backgroundColor: AppColors.ivory,
      body: SafeArea(
        child: calendarAsync.when(
          data: (calendar) {
            if (calendar.isEmpty) {
              return Center(child: Text('Không có dữ liệu lịch', style: AppTypography.body));
            }
            return _buildContent(context, ref, calendar, displayedMonth);
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

  Widget _buildContent(BuildContext context, WidgetRef ref, List<LunarDate> calendar, DateTime displayedMonth) {
    final selectedDate = ref.watch(selectedDateProvider);
    
    // Find the current selected LunarDate
    LunarDate? selectedLunar;
    try {
      selectedLunar = calendar.firstWhere(
        (date) => 
            date.solarDate.year == selectedDate.year &&
            date.solarDate.month == selectedDate.month &&
            date.solarDate.day == selectedDate.day,
      );
    } catch (_) {}

    return Column(
      children: [
        // Header (Month / Year Selection)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left, color: AppColors.textPrimary),
                onPressed: () {
                  ref.read(displayedMonthProvider.notifier).state = 
                    DateTime(displayedMonth.year, displayedMonth.month - 1, 1);
                },
              ),
              Text(
                'Tháng ${displayedMonth.month}, ${displayedMonth.year}',
                style: AppTypography.title.copyWith(fontSize: 22),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right, color: AppColors.textPrimary),
                onPressed: () {
                  ref.read(displayedMonthProvider.notifier).state = 
                    DateTime(displayedMonth.year, displayedMonth.month + 1, 1);
                },
              ),
            ],
          ),
        ),
        
        // Weekdays Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'].map((day) {
              return Expanded(
                child: Center(
                  child: Text(
                    day,
                    style: AppTypography.caption.copyWith(
                      color: day == 'CN' ? AppColors.templeRed : AppColors.textSecondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        
        AppSpacing.gap16,

        // Calendar Grid
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: _buildGrid(ref, calendar, displayedMonth, selectedDate),
        ),
        
        AppSpacing.gap24,

        // Specific Item Details
        Expanded(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.warmPaper,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(32),
                topRight: Radius.circular(32),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.textPrimary.withValues(alpha: 0.05),
                  blurRadius: 20,
                  offset: const Offset(0, -5),
                )
              ],
            ),
            child: selectedLunar != null 
                ? _buildDetailSection(selectedLunar)
                : Center(child: Text("Chọn một ngày", style: AppTypography.body)),
          ),
        ),
      ],
    );
  }

  Widget _buildGrid(WidgetRef ref, List<LunarDate> calendar, DateTime displayedMonth, DateTime selectedDate) {
    // Determine days in month and starting weekday
    final daysInMonth = DateUtils.getDaysInMonth(displayedMonth.year, displayedMonth.month);
    final firstDayOfMonth = DateTime(displayedMonth.year, displayedMonth.month, 1);
    
    // DateTime.weekday returns 1 for Monday, 7 for Sunday.
    int emptyLeadingSlots = firstDayOfMonth.weekday - 1; 

    final totalSlots = emptyLeadingSlots + daysInMonth;
    final rows = (totalSlots / 7).ceil();

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: rows * 7,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        childAspectRatio: 0.85,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
      itemBuilder: (context, index) {
        if (index < emptyLeadingSlots || index >= totalSlots) {
          return const SizedBox.shrink();
        }

        final dayNumber = index - emptyLeadingSlots + 1;
        final cellDate = DateTime(displayedMonth.year, displayedMonth.month, dayNumber);
        
        // Find Lunar Info (this could be optimized, but ok for a year array)
        LunarDate? lunarForCell;
        try {
          lunarForCell = calendar.firstWhere(
            (l) => l.solarDate.year == cellDate.year && l.solarDate.month == cellDate.month && l.solarDate.day == cellDate.day
          );
        } catch (_) {}

        final isSelected = cellDate.year == selectedDate.year && cellDate.month == selectedDate.month && cellDate.day == selectedDate.day;
        final isToday = cellDate.year == DateTime.now().year && cellDate.month == DateTime.now().month && cellDate.day == DateTime.now().day;
        final isSunday = cellDate.weekday == DateTime.sunday;

        return GestureDetector(
          onTap: () {
            ref.read(selectedDateProvider.notifier).state = cellDate;
          },
          child: AnimatedContainer(
            duration: 200.ms,
            decoration: BoxDecoration(
              color: isSelected 
                  ? AppColors.templeRed 
                  : (isToday ? AppColors.gold.withValues(alpha: 0.2) : Colors.transparent),
              borderRadius: BorderRadius.circular(12),
              border: isToday && !isSelected ? Border.all(color: AppColors.gold) : null,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$dayNumber',
                  style: AppTypography.body.copyWith(
                    color: isSelected 
                        ? AppColors.white 
                        : (isSunday ? AppColors.templeRed : AppColors.textPrimary),
                    fontWeight: isSelected || isToday ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                if (lunarForCell != null) ...[
                  AppSpacing.gap4,
                  Text(
                    '${lunarForCell.lunarDay}',
                    style: AppTypography.caption.copyWith(
                      color: isSelected ? AppColors.white.withValues(alpha: 0.8) : AppColors.textSecondary,
                      fontSize: 10,
                    ),
                  ),
                ]
              ],
            ),
          ),
        ).animate().fadeIn(delay: (index * 15).ms).scale(begin: const Offset(0.9, 0.9));
      },
    );
  }

  Widget _buildDetailSection(LunarDate lunarDate) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ngày ${lunarDate.solarDate.day} tháng ${lunarDate.solarDate.month}',
                    style: AppTypography.small.copyWith(color: AppColors.textSecondary),
                  ),
                  AppSpacing.gap4,
                  Text(
                    'Âm lịch: ${lunarDate.lunarDay}/${lunarDate.lunarMonth}',
                    style: AppTypography.section,
                  ),
                ],
              ),
              Text(
                lunarDate.canChiDay.split('tháng').first.trim(), // Extracted clean short can-chi
                style: AppTypography.body.copyWith(
                  color: AppColors.templeRed,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          
          AppSpacing.gap24,
          
          _buildInfoRow('Giờ Hoàng Đạo', lunarDate.hoangDaoTime),
          AppSpacing.gap16,
          _buildInfoRow('Giờ Hắc Đạo', lunarDate.hacDaoTime),
          AppSpacing.gap16,
          _buildInfoRow('Ngũ Hành', lunarDate.nguHanh),
          AppSpacing.gap16,
          _buildInfoRow('Hướng Xuất Hành', lunarDate.huongXuatHanh),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1);
  }

  Widget _buildInfoRow(String title, String content) {
    if (content.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTypography.caption.copyWith(
            color: AppColors.textSecondary,
            letterSpacing: 1.2,
          ),
        ),
        AppSpacing.gap4,
        Text(
          content,
          style: AppTypography.body,
        ),
      ],
    );
  }
}
