import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/constants/app_routes.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';

class HomeHeroSection extends StatelessWidget {
  const HomeHeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 40, 24, 32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.brandPrimaryBackground,
            AppColors.brandSecondarySurface.withValues(alpha: 0.9),
          ],
        ),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 720),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'High-Fidelity 3D Assets\nfor Modern Architecture',
              style: AppTextStyles.headlineMd,
            ),
            const SizedBox(height: 12),
            Text(
              'Browse, classify, and share architectural models with AI-assisted labels.',
              style: AppTextStyles.bodyLg,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: 180,
              child: ElevatedButton(
                onPressed: () => context.go(AppRoutes.browse),
                child: const Text('Browse Assets'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CategorySidebar extends StatelessWidget {
  const CategorySidebar({
    super.key,
    required this.categories,
    required this.selected,
    required this.onSelected,
  });

  final List<String> categories;
  final String selected;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.brandSecondarySurface.withValues(alpha: 0.45),
        border: Border(
          right: BorderSide(
            color: AppColors.textWhite.withValues(alpha: 0.05),
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Text(
              'Categories',
              style: AppTextStyles.labelMd.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ),
          ...categories.map((category) {
            final isSelected = category == selected;
            return Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Material(
                color: isSelected
                    ? AppColors.brandAccentPrimary.withValues(alpha: 0.12)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                child: InkWell(
                  onTap: () => onSelected(category),
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    child: Text(
                      category,
                      style: AppTextStyles.bodyMd.copyWith(
                        color: isSelected
                            ? AppColors.brandAccentPrimary
                            : AppColors.textWhite,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
