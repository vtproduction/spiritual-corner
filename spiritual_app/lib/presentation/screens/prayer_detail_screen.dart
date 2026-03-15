import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../data/repositories/prayer_repository.dart';

class PrayerDetailScreen extends ConsumerWidget {
  final String prayerId;

  const PrayerDetailScreen({super.key, required this.prayerId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prayerItemAsync = ref.watch(prayerItemFamily(prayerId));

    return Scaffold(
      backgroundColor: AppColors.ivory,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: const Text('Chi Tiết Văn Khấn'),
        backgroundColor: AppColors.ivory,
        elevation: 0,
      ),
      body: prayerItemAsync.when(
        data: (item) {
          if (item == null) {
            return Center(child: Text('Không tìm thấy bài khấn', style: AppTypography.body));
          }

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: AppTypography.title.copyWith(fontSize: 26, color: AppColors.templeRed),
                ).animate().fadeIn().slideY(begin: 0.1),
                
                AppSpacing.gap24,

                // Setup/Preparation Section (if available)
                if (item.prepare != null && item.prepare!.isNotEmpty) ...[
                  _buildSectionCard(
                    title: 'Sắm Lễ',
                    icon: Icons.local_florist_outlined,
                    children: [
                      Text(
                        item.prepare!,
                        style: AppTypography.body,
                      )
                    ],
                  ).animate().fadeIn(delay: 100.ms),
                  AppSpacing.gap24,
                ],

                // Sub-prayers list (Văn khấn thực tế)
                ...item.prayers.asMap().entries.map((entry) {
                  final index = entry.key;
                  final prayer = entry.value;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 24),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.warmPaper,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.gold.withValues(alpha: 0.2)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          prayer.name,
                          style: AppTypography.section.copyWith(color: AppColors.textPrimary),
                        ),
                        AppSpacing.gap16,
                        if (prayer.intro.isNotEmpty) ...[
                          Text(
                            prayer.intro,
                            style: AppTypography.body.copyWith(fontStyle: FontStyle.italic),
                          ),
                          AppSpacing.gap16,
                        ],
                        
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.templeRed,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            onPressed: () {
                              context.push('/teleprompter', extra: prayer);
                            },
                            child: const Text('Đọc Văn Khấn', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          ),
                        )
                      ],
                    ),
                  ).animate().fadeIn(delay: (200 + (index * 100)).ms).slideX(begin: 0.05);
                }),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.templeRed)),
        error: (_, __) => Center(child: Text('Lỗi tải dữ liệu', style: AppTypography.body)),
      ),
    );
  }

  Widget _buildSectionCard({required String title, required IconData icon, required List<Widget> children}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimary.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.gold, size: 24),
              AppSpacing.gap8,
              Text(
                title,
                style: AppTypography.section.copyWith(color: AppColors.textPrimary),
              ),
            ],
          ),
          AppSpacing.gap16,
          ...children,
        ],
      ),
    );
  }

} // EOF
