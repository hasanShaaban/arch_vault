import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_state_views.dart';
import '../../domain/entities/report_entity.dart';

class AdminReportsTab extends StatelessWidget {
  const AdminReportsTab({
    super.key,
    required this.reports,
    required this.onResolve,
    required this.onDismiss,
    this.busy = false,
  });

  final List<ReportEntity> reports;
  final ValueChanged<String> onResolve;
  final ValueChanged<String> onDismiss;
  final bool busy;

  @override
  Widget build(BuildContext context) {
    final open = reports.where((r) => r.status == 'open').toList();
    if (open.isEmpty) {
      return const AppEmptyState(
        title: 'No open reports',
        message: 'Incoming model reports will show up here.',
        icon: Icons.flag_outlined,
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(24),
      itemCount: open.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final report = open[index];
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainer,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.outlineVariant),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(report.modelTitle, style: AppTextStyles.headlineSm.copyWith(fontSize: 18)),
              const SizedBox(height: 6),
              Text(
                report.reason,
                style: AppTextStyles.bodyMd.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Reported by @${report.reporterUsername}',
                style: AppTextStyles.labelMd.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  FilledButton(
                    onPressed: busy ? null : () => onResolve(report.id),
                    child: const Text('Resolve'),
                  ),
                  const SizedBox(width: 8),
                  OutlinedButton(
                    onPressed: busy ? null : () => onDismiss(report.id),
                    child: const Text('Dismiss'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
