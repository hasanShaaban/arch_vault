import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/admin_stats_entity.dart';

class AdminOverviewTab extends StatelessWidget {
  const AdminOverviewTab({super.key, required this.stats});

  final AdminStatsEntity stats;

  @override
  Widget build(BuildContext context) {
    final items = [
      _StatItem('Users', stats.usersCount.toString(), Icons.people_outline),
      _StatItem('Models', stats.modelsCount.toString(), Icons.view_in_ar),
      _StatItem(
        'Downloads',
        stats.downloadsCount.toString(),
        Icons.download_outlined,
      ),
      _StatItem(
        'Open reports',
        stats.pendingReports.toString(),
        Icons.flag_outlined,
      ),
      _StatItem(
        'Pending labels',
        stats.pendingLabels.toString(),
        Icons.label_outline,
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth >= 900
            ? 3
            : constraints.maxWidth >= 600
                ? 2
                : 1;
        return GridView.builder(
          padding: const EdgeInsets.all(24),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 2.2,
          ),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainer,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.outlineVariant),
              ),
              child: Row(
                children: [
                  Icon(item.icon, color: AppColors.brandAccentPrimary),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          item.label,
                          style: AppTextStyles.bodyMd.copyWith(
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item.value,
                          style: AppTextStyles.headlineSm.copyWith(
                            fontSize: 28,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _StatItem {
  const _StatItem(this.label, this.value, this.icon);

  final String label;
  final String value;
  final IconData icon;
}
