import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../data/repositories/lunar_calendar_repository.dart';
import '../../domain/models/lunar_date.dart';
import '../../core/utils/lunar_time_helper.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  String _getVietnameseWeekday(int weekday) {
    switch (weekday) {
      case DateTime.monday:
        return 'Thứ Hai';
      case DateTime.tuesday:
        return 'Thứ Ba';
      case DateTime.wednesday:
        return 'Thứ Tư';
      case DateTime.thursday:
        return 'Thứ Năm';
      case DateTime.friday:
        return 'Thứ Sáu';
      case DateTime.saturday:
        return 'Thứ Bảy';
      case DateTime.sunday:
        return 'Chủ Nhật';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todayLunarAsync = ref.watch(todayLunarDateProvider);
    final now = ref.watch(currentDateProvider);

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
            return _buildContent(context, ref, lunarDate, now);
          },
          loading: () => const Center(
            child: CircularProgressIndicator(color: AppColors.templeRed),
          ),
          error: (err, stack) =>
              Center(child: Text('Lỗi tải dữ liệu', style: AppTypography.body)),
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    WidgetRef ref,
    LunarDate lunarDate,
    DateTime now,
  ) {
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
                  GestureDetector(
                    onDoubleTap: () async {
                      final selectedDate = await showDatePicker(
                        context: context,
                        initialDate: now,
                        firstDate: DateTime(2026, 1, 1),
                        lastDate: DateTime(2026, 12, 31),
                      );
                      if (selectedDate == null || !context.mounted) return;

                      final selectedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.fromDateTime(now),
                      );
                      if (selectedTime == null) return;

                      final overridenDateTime = DateTime(
                        selectedDate.year,
                        selectedDate.month,
                        selectedDate.day,
                        selectedTime.hour,
                        selectedTime.minute,
                      );
                      ref.read(currentDateProvider.notifier).state = overridenDateTime;
                    },
                    child: Text(
                          _getVietnameseWeekday(now.weekday).toUpperCase(),
                          style: AppTypography.small.copyWith(
                            color: AppColors.templeRed,
                            letterSpacing: 3,
                            fontWeight: FontWeight.w600,
                          ),
                        )
                        .animate()
                        .fadeIn(duration: 600.ms, curve: Curves.easeOut)
                        .slideY(begin: -0.2),
                  ),
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
            GestureDetector(
              onTap: () => context.push('/date-detail', extra: lunarDate),
              child:
                  Container(
                        padding: const EdgeInsets.all(32),
                        decoration: BoxDecoration(
                          color: AppColors.white.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: AppColors.gold.withValues(alpha: 0.2),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.gold.withValues(alpha: 0.05),
                              blurRadius: 30,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Text(
                              'ÂM LỊCH (Nhấn xem luận giải)',
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
                              color: AppColors.gold.withValues(alpha: 0.5),
                            ),
                            AppSpacing.gap24,
                            Text(
                              lunarDate.rawDate[3].isNotEmpty
                                  ? LunarTimeHelper.formatZodiacTimeString(
                                      lunarDate.rawDate[3],
                                    )
                                  : 'Năm ${lunarDate.lunarYear}',
                              textAlign: TextAlign.center,
                              style: AppTypography.body.copyWith(
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      )
                      .animate()
                      .fadeIn(delay: 400.ms, duration: 800.ms)
                      .scale(begin: const Offset(0.95, 0.95)),
            ),

            AppSpacing.gap16,

            // Present Time Indicator Card
            Builder(
              builder: (context) {
                final isHoangDao = LunarTimeHelper.isCurrentTimeHoangDao(
                  lunarDate.hoangDaoTime,
                  time: now,
                );
                final timeSlotString =
                    LunarTimeHelper.getCurrentTimeSlotString(time: now);
                final statusText = isHoangDao ? 'Giờ hoàng đạo' : 'Giờ hắc đạo';
                final bgColor = isHoangDao
                    ? Colors.green.withValues(alpha: 0.1)
                    : Colors.red.withValues(alpha: 0.1);
                final borderColor = isHoangDao
                    ? Colors.green.withValues(alpha: 0.3)
                    : Colors.red.withValues(alpha: 0.3);
                final iconColor = isHoangDao
                    ? Colors.green[700]
                    : Colors.red[700];
                final icon = isHoangDao
                    ? Icons.wb_sunny_rounded
                    : Icons.nights_stay_rounded;

                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: borderColor),
                  ),
                  child: Row(
                    children: [
                      Icon(icon, color: iconColor),
                      AppSpacing.gap16,
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            style: AppTypography.body.copyWith(
                              color: AppColors.textPrimary,
                            ),
                            children: [
                              const TextSpan(text: 'Hiện tại: '),
                              TextSpan(
                                text: '$statusText ',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: timeSlotString,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ).animate().fadeIn(delay: 450.ms).slideY(begin: 0.1);
              },
            ),

            AppSpacing.gap16,

            // Nên - Không Nên Card
            if (lunarDate.rawData.length > 2 && lunarDate.rawData[2].isNotEmpty) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.warmPaper,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.gold.withValues(alpha: 0.1),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Nên - Không Nên',
                      style: AppTypography.body.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    AppSpacing.gap8,
                    Text(
                      lunarDate.rawData[2],
                      style: AppTypography.body.copyWith(
                        color: AppColors.textSecondary,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 450.ms).slideY(begin: 0.1),
              AppSpacing.gap16,
            ],

            // Raw Date Array Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.warmPaper,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.gold.withValues(alpha: 0.1),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: () {
                  final widgets = <Widget>[];

                  // Display parsed rawDate items
                  for (
                    int index = 0;
                    index < lunarDate.rawDate.length - 1;
                    index++
                  ) {
                    if (index == 3) continue;

                    String text = lunarDate.rawDate[index];
                    if (index == 0) text = 'Dương lịch: $text';
                    if (index == 1) text = 'Âm lịch: $text';

                    widgets.add(
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: _buildFormattedDateText(text),
                      ),
                    );
                  }

                  // Append Giờ Hoàng Đạo from rawData
                  if (lunarDate.rawData.length > 1) {
                    final hoangDaoText =
                        'Giờ Hoàng Đạo: ${lunarDate.rawData[0]}'.replaceAll(
                          ';',
                          ',',
                        );
                    widgets.add(
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: _buildFormattedDateText(hoangDaoText),
                      ),
                    );
                  }

                  // Append Giờ Hắc Đạo from rawData
                  if (lunarDate.rawData.length > 1) {
                    final hacDaoText = 'Giờ Hắc Đạo: ${lunarDate.rawData[1]}'
                        .replaceAll(';', ',');
                    widgets.add(
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: _buildFormattedDateText(hacDaoText),
                      ),
                    );
                  }

                  return widgets;
                }(),
              ),
            ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.1),

            AppSpacing.gap48,
          ],
        ),
      ),
    );
  }

  Widget _buildFormattedDateText(String text) {
    int colonIndex = text.indexOf(':');

    if (colonIndex != -1) {
      final prefix = text.substring(0, colonIndex + 1);
      final rest = text.substring(colonIndex + 1);

      final spans = <InlineSpan>[
        TextSpan(
          text: prefix,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
      ];

      // Bold specific items for entries containing bracketed times
      if (prefix.toLowerCase().contains('giờ')) {
        final regex = RegExp(r'([^,()]+)\(([^)]+)\)');
        final matches = regex.allMatches(rest);

        if (matches.isNotEmpty) {
          int lastMatchEnd = 0;
          for (final match in matches) {
            if (match.start > lastMatchEnd) {
              spans.add(
                TextSpan(text: rest.substring(lastMatchEnd, match.start)),
              );
            }

            final namePart = match.group(1)!;
            final timePart = match.group(2)!;

            final trimmedName = namePart.trim();
            final indexOfName = namePart.indexOf(trimmedName);
            final beforeName = namePart.substring(0, indexOfName);
            final afterName = namePart.substring(
              indexOfName + trimmedName.length,
            );

            spans.add(TextSpan(text: beforeName));
            spans.add(
              TextSpan(
                text: trimmedName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            );
            spans.add(TextSpan(text: '$afterName($timePart)'));

            lastMatchEnd = match.end;
          }
          if (lastMatchEnd < rest.length) {
            spans.add(TextSpan(text: rest.substring(lastMatchEnd)));
          }
        } else {
          spans.add(TextSpan(text: rest));
        }
      } else {
        spans.add(TextSpan(text: rest));
      }

      return RichText(
        text: TextSpan(
          style: AppTypography.body.copyWith(
            color: AppColors.textSecondary,
            height: 1.5,
          ),
          children: spans,
        ),
      );
    } else {
      return Text(
        text,
        style: AppTypography.body.copyWith(
          color: AppColors.textSecondary,
          height: 1.5,
        ),
      );
    }
  }
}
