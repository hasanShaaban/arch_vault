import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../domain/constants/browse_categories.dart';
import '../../../domain/entities/browse_asset_entity.dart';

class BrowseFilterSidebar extends StatelessWidget {
  const BrowseFilterSidebar({
    super.key,
    this.selectedLabel = 'All',
    this.selectedFormat = 'All',
    this.sortOption = BrowseSortOption.topRated,
    this.onLabelSelected,
    this.onFormatSelected,
    this.onSortSelected,
    required this.selectedSuperCategory,
    required this.selectedSubCategory,
    required this.selectedStyleClass,
    required this.onSuperCategorySelected,
    required this.onSubCategorySelected,
    required this.onStyleClassSelected,
  });

  final String selectedLabel;
  final String selectedFormat;
  final BrowseSortOption sortOption;
  final ValueChanged<String>? onLabelSelected;
  final ValueChanged<String>? onFormatSelected;
  final ValueChanged<BrowseSortOption>? onSortSelected;

  final String? selectedSuperCategory;
  final String? selectedSubCategory;
  final String? selectedStyleClass;
  final ValueChanged<String?> onSuperCategorySelected;
  final ValueChanged<String?> onSubCategorySelected;
  final ValueChanged<String?> onStyleClassSelected;

  static const formats = ['All', 'GLTF', 'FBX', 'OBJ'];

  /// Sub-families for the currently selected super category.
  List<String> get _subFamilies =>
      selectedSuperCategory != null
          ? kSuperCategories[selectedSuperCategory!] ?? []
          : [];

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
          // ── Super Category ───────────────────────────────────────────────
          _SectionTitle('Category'),
          _FilterTile(
            label: 'All',
            selected: selectedSuperCategory == null,
            onTap: () => onSuperCategorySelected(null),
          ),
          ...kSuperCategories.keys.map(
            (cat) => _FilterTile(
              label: cat,
              selected: cat == selectedSuperCategory,
              onTap: () => onSuperCategorySelected(cat),
            ),
          ),

          // ── Sub-family (cascades from super category) ────────────────────
          if (_subFamilies.isNotEmpty) ...[
            const SizedBox(height: 16),
            _SectionTitle('Sub-family'),
            _FilterTile(
              label: 'All',
              selected: selectedSubCategory == null,
              onTap: () => onSubCategorySelected(null),
              indent: true,
            ),
            ..._subFamilies.map(
              (sub) => _FilterTile(
                label: sub,
                selected: sub == selectedSubCategory,
                onTap: () => onSubCategorySelected(sub),
                indent: true,
              ),
            ),
          ],

          // ── Style Class (independent) ────────────────────────────────────
          const SizedBox(height: 16),
          _SectionTitle('Style'),
          _FilterTile(
            label: 'All',
            selected: selectedStyleClass == null,
            onTap: () => onStyleClassSelected(null),
          ),
          ...kStyleClasses.map(
            (style) => _FilterTile(
              label: style,
              selected: style == selectedStyleClass,
              onTap: () => onStyleClassSelected(style),
            ),
          ),

          // ── Sort ─────────────────────────────────────────────────────────
          const SizedBox(height: 16),
          _SectionTitle('Sort by'),
          _FilterTile(
            label: 'Top rated',
            selected: sortOption == BrowseSortOption.topRated,
            onTap: () => onSortSelected?.call(BrowseSortOption.topRated),
          ),
          _FilterTile(
            label: 'Most downloaded',
            selected: sortOption == BrowseSortOption.mostDownloaded,
            onTap: () => onSortSelected?.call(BrowseSortOption.mostDownloaded),
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
        text.toUpperCase(),
        style: AppTextStyles.labelMd.copyWith(
          color: AppColors.onSurfaceVariant,
          letterSpacing: 0.8,
          fontSize: 10,
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
    this.indent = false,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final bool indent;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 2, left: indent ? 12 : 0),
      child: Material(
        color: selected
            ? AppColors.brandAccentPrimary.withValues(alpha: 0.12)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
            child: Row(
              children: [
                if (selected)
                  Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: Container(
                      width: 4,
                      height: 14,
                      decoration: BoxDecoration(
                        color: AppColors.brandAccentPrimary,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                Expanded(
                  child: Text(
                    label,
                    style: AppTextStyles.bodyMd.copyWith(
                      color: selected
                          ? AppColors.brandAccentPrimary
                          : AppColors.textWhite,
                      fontWeight:
                          selected ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
