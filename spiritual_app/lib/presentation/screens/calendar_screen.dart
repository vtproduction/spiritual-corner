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

class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({super.key});

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  late final PageController _pageController;
  final int _initialPage = 1200; // Large center point for infinite scrolling

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _initialPage);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            return _buildContent(context, calendar, displayedMonth);
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

  Widget _buildContent(BuildContext context, List<LunarDate> calendar, DateTime displayedMonth) {
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

    // Calculate grid height precisely
    final daysInMonth = DateUtils.getDaysInMonth(displayedMonth.year, displayedMonth.month);
    final firstDayOfMonth = DateTime(displayedMonth.year, displayedMonth.month, 1);
    final emptyLeadingSlots = firstDayOfMonth.weekday - 1; 
    final totalSlots = emptyLeadingSlots + daysInMonth;
    final int rows = (totalSlots / 7).ceil();

    final gridWidth = MediaQuery.of(context).size.width - 32; // 16 horizontal padding
    final itemWidth = (gridWidth - 6 * 8) / 7; // subtract 6 crossAxisSpacings of 8
    final itemHeight = itemWidth / 1.1; // aspect ratio
    final gridHeight = rows * itemHeight + (rows - 1) * 8; // add mainAxisSpacings

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
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
                    _pageController.previousPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                ),
                Text(
                  'Tháng ${displayedMonth.month}, ${displayedMonth.year}',
                  style: AppTypography.title.copyWith(fontSize: 22),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right, color: AppColors.textPrimary),
                  onPressed: () {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
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

          // Calendar Grid PageView
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            height: gridHeight,
            child: PageView.builder(
              controller: _pageController,
              physics: const BouncingScrollPhysics(),
              onPageChanged: (index) {
                final offset = index - _initialPage;
                final now = DateTime.now();
                // Update the state so the header text catches up
                ref.read(displayedMonthProvider.notifier).state = 
                  DateTime(now.year, now.month + offset, 1);
              },
              itemBuilder: (context, index) {
                final offset = index - _initialPage;
                final now = DateTime.now();
                final month = DateTime(now.year, now.month + offset, 1);
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: _buildGrid(calendar, month, selectedDate),
                );
              },
            ),
          ),
          
          AppSpacing.gap24,

          // Specific Item Details
          Container(
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
                : Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      child: Text("Chọn một ngày", style: AppTypography.body),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildGrid(List<LunarDate> calendar, DateTime displayedMonth, DateTime selectedDate) {
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
        childAspectRatio: 1.1,
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
                    height: 1.0,
                  ),
                ),
                if (lunarForCell != null) ...[
                  const SizedBox(height: 2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${lunarForCell.lunarDay}',
                        style: AppTypography.caption.copyWith(
                          color: isSelected ? AppColors.white.withValues(alpha: 0.8) : AppColors.textSecondary,
                          fontSize: 10,
                          height: 1.0,
                        ),
                      ),
                      if (lunarForCell.dayType != null) ...[
                        const SizedBox(width: 4),
                        Container(
                          width: 4,
                          height: 4,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: lunarForCell.dayType == 1 
                                ? Colors.green.withValues(alpha: isSelected ? 1.0 : 0.6) 
                                : Colors.red.withValues(alpha: isSelected ? 1.0 : 0.6),
                          ),
                        ),
                      ],
                    ],
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
    return Column(
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
          
          if ((lunarDate.holiday != null && lunarDate.holiday!.isNotEmpty) || lunarDate.dayType != null) ...[
            AppSpacing.gap16,
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                if (lunarDate.holiday != null && lunarDate.holiday!.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.templeRed.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.templeRed.withValues(alpha: 0.3)),
                    ),
                    child: Text(
                      lunarDate.holiday!,
                      style: AppTypography.caption.copyWith(
                        color: AppColors.templeRed,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                if (lunarDate.dayType != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: lunarDate.dayType == 1 
                          ? Colors.green.withValues(alpha: 0.1) 
                          : Colors.black.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: lunarDate.dayType == 1 
                          ? Colors.green.withValues(alpha: 0.3) 
                          : Colors.black.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Text(
                      lunarDate.dayType == 1 ? 'Ngày Hoàng Đạo' : 'Ngày Hắc Đạo',
                      style: AppTypography.caption.copyWith(
                        color: lunarDate.dayType == 1 ? Colors.green[700] : Colors.black87,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ],
          
          AppSpacing.gap24,
          
          _buildInfoRow('Giờ Hoàng Đạo', lunarDate.hoangDaoTime),
          AppSpacing.gap16,
          _buildInfoRow('Giờ Hắc Đạo', lunarDate.hacDaoTime),
          AppSpacing.gap16,
          _buildInfoRow('Ngũ Hành', lunarDate.nguHanh),
          AppSpacing.gap16,
          _buildInfoRow('Hướng Xuất Hành', lunarDate.huongXuatHanh),
        ],
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
