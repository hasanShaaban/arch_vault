import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../domain/entities/browse_asset_entity.dart';

class BrowseFilterSidebar extends StatelessWidget {
  const BrowseFilterSidebar({
    super.key,
    required this.selectedLabel,
    required this.selectedFormat,
    required this.sortOption,
    required this.onLabelSelected,
    required this.onFormatSelected,
    required this.onSortSelected,
  });

  final String selectedLabel;
  final String selectedFormat;
  final BrowseSortOption sortOption;
  final ValueChanged<String> onLabelSelected;
  final ValueChanged<String> onFormatSelected;
  final ValueChanged<BrowseSortOption> onSortSelected;

  static const labels = ['All', 'Residential', 'Commercial', 'Public'];
  static const formats = ['All', 'GLTF', 'FBX', 'OBJ'];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.brandSecondarySurface.withValues(alpha: 0.45),
        border: Border(
          right: BorderSide(
            color: AppColors.textWhite.withValues(alpha: 0.05),
          ),
        ),
      ),
      child: ListView(
        children: [
          _SectionTitle('Categories'),
          ...labels.map(
            (label) => _FilterTile(
              label: label,
              selected: label == selectedLabel,
              onTap: () => onLabelSelected(label),
            ),
          ),
          const SizedBox(height: 16),
          _SectionTitle('File format'),
          ...formats.map(
            (format) => _FilterTile(
              label: format,
              selected: format == selectedFormat,
              onTap: () => onFormatSelected(format),
            ),
          ),
          const SizedBox(height: 16),
          _SectionTitle('Sort by'),
          _FilterTile(
            label: 'Top rated',
            selected: sortOption == BrowseSortOption.topRated,
            onTap: () => onSortSelected(BrowseSortOption.topRated),
          ),
          _FilterTile(
            label: 'Most downloaded',
            selected: sortOption == BrowseSortOption.mostDownloaded,
            onTap: () => onSortSelected(BrowseSortOption.mostDownloaded),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Text(
        text,
        style: AppTextStyles.labelMd.copyWith(
          color: AppColors.onSurfaceVariant,
        ),
      ),
    );
  }
}

class _FilterTile extends StatelessWidget {
  const _FilterTile({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Material(
        color: selected
            ? AppColors.brandAccentPrimary.withValues(alpha: 0.12)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Text(
              label,
              style: AppTextStyles.bodyMd.copyWith(
                color: selected
                    ? AppColors.brandAccentPrimary
                    : AppColors.textWhite,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
