import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../data/repositories/prayer_repository.dart';
import '../../domain/models/prayer.dart';

final selectedCategoryProvider = StateProvider<String?>((ref) => null);

class PrayerScreen extends ConsumerWidget {
  const PrayerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(prayerCategoriesProvider);
    final itemsAsync = ref.watch(prayerItemsProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);

    return Scaffold(
      backgroundColor: AppColors.ivory,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Văn Khấn Cổ Truyền',
                style: AppTypography.title.copyWith(fontSize: 28),
              ),
            ),
            
            // Categories Row
            categoriesAsync.when(
              data: (categories) => _buildCategoryChips(ref, categories, selectedCategory),
              loading: () => const LinearProgressIndicator(color: AppColors.templeRed),
              error: (_, __) => const SizedBox.shrink(),
            ),

            AppSpacing.gap8,

            // Prayers List
            Expanded(
              child: itemsAsync.when(
                data: (items) {
                  final filteredItems = selectedCategory == null 
                      ? items 
                      : items.where((i) => i.categoryId == selectedCategory).toList();

                  if (filteredItems.isEmpty) {
                    return Center(child: Text("Không có bài khấn nào", style: AppTypography.body));
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: filteredItems.length,
                    separatorBuilder: (context, index) => AppSpacing.gap16,
                    itemBuilder: (context, index) {
                      final item = filteredItems[index];
                      return _buildPrayerCard(context, item, index);
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator(color: AppColors.templeRed)),
                error: (err, stack) => Center(child: Text('Lỗi tải dữ liệu', style: AppTypography.body)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryChips(WidgetRef ref, List<PrayerCategory> categories, String? selectedCategory) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: [
          _buildChip(
            label: 'Tất cả',
            isSelected: selectedCategory == null,
            onTap: () => ref.read(selectedCategoryProvider.notifier).state = null,
          ),
          ...categories.map((c) => Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: _buildChip(
              label: c.name,
              isSelected: selectedCategory == c.id,
              onTap: () => ref.read(selectedCategoryProvider.notifier).state = c.id,
            ),
          )),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms);
  }

  Widget _buildChip({required String label, required bool isSelected, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: 200.ms,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.templeRed : AppColors.warmPaper,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? AppColors.templeRed : AppColors.gold.withValues(alpha: 0.3),
          ),
        ),
        child: Text(
          label,
          style: AppTypography.body.copyWith(
            color: isSelected ? AppColors.white : AppColors.textPrimary,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildPrayerCard(BuildContext context, PrayerItem item, int index) {
    return GestureDetector(
      onTap: () {
        context.push('/prayers/detail/${item.id}');
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.warmPaper,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.textPrimary.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: AppTypography.section.copyWith(color: AppColors.templeRed),
                  ),
                  AppSpacing.gap8,
                  Text(
                    '${item.prayers.length} bài khấn',
                    style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.gold),
          ],
        ),
      ).animate().fadeIn(delay: (50 * index).ms).slideX(begin: 0.05),
    );
  }
} // EOF
