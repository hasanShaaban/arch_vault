import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_state_views.dart';
import '../../../../core/widgets/preview_image.dart';
import '../../domain/entities/label_review_entity.dart';

class AdminLabelsTab extends StatelessWidget {
  const AdminLabelsTab({
    super.key,
    required this.items,
    required this.onUpdateLabel,
    this.busy = false,
  });

  final List<LabelReviewEntity> items;
  final void Function(String modelId, String label) onUpdateLabel;
  final bool busy;

  static const _labels = [
    'Residential',
    'Commercial',
    'Public',
    'Unassigned',
  ];

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const AppEmptyState(
        title: 'No label reviews',
        message: 'Models needing label review will appear here.',
        icon: Icons.label_outline,
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(24),
      itemCount: items.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final item = items[index];
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainer,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.outlineVariant),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 96,
                height: 72,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: PreviewImage(image: item.image),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: AppTextStyles.headlineSm.copyWith(fontSize: 18),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Current: ${item.currentLabel}',
                      style: AppTextStyles.bodyMd.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      'Suggested: ${item.suggestedLabel}',
                      style: AppTextStyles.bodyMd.copyWith(
                        color: AppColors.brandAccentPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final label in _labels)
                          OutlinedButton(
                            onPressed: busy || item.currentLabel == label
                                ? null
                                : () => onUpdateLabel(item.modelId, label),
                            child: Text(label),
                          ),
                        FilledButton(
                          onPressed: busy
                              ? null
                              : () => onUpdateLabel(
                                    item.modelId,
                                    item.suggestedLabel,
                                  ),
                          child: const Text('Apply suggested'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
