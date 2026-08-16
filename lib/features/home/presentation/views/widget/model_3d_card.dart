import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../domain/entities/model_3d_entity.dart';

class Model3dCard extends StatelessWidget {
  const Model3dCard({super.key, required this.model, this.onTap});

  final Model3dEntity model;
  final VoidCallback? onTap;

  /// Derives a human-readable title from the source_file filename.
  /// e.g. "modern__sofa.glb" → "Modern Sofa"
  // String get _displayTitle {
  //   final name = model.sourceFile
  //       .replaceAll(RegExp(r'\.glb$', caseSensitive: false), '')
  //       .replaceAll(RegExp(r'[_\-]+'), ' ')
  //       .trim();
  //   return name
  //       .split(' ')
  //       .map((w) => w.isEmpty ? '' : '${w[0].toUpperCase()}${w.substring(1)}')
  //       .join(' ');
  // }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Ink(
        decoration: BoxDecoration(
          color: AppColors.brandSecondarySurface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: AppColors.brandAccentPrimary.withValues(alpha: 0.1),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Thumbnail / placeholder ──────────────────────────────────
            Expanded(
              child: _ThumbnailPlaceholder(title: 'TODO:ModleName'),
            ), //TODO:Model name
            // ── Info row ─────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title (derived from filename)
                  Text(
                    "TODO:ModelName",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.bodyMd.copyWith(
                      color: AppColors.textWhite,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Category · downloads
                  Text(
                    _subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.labelMd.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 6),

                  // Rating + mesh stats
                  Row(
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        size: 16,
                        color: AppColors.tertiaryContainer,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        model.ratingScore.toString(),
                        style: AppTextStyles.labelMd,
                      ),
                      if (model.faces != null) ...[
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.grid_on_rounded,
                          size: 13,
                          color: AppColors.onSurfaceVariant,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          _formatFaces(model.faces!),
                          style: AppTextStyles.labelMd.copyWith(
                            color: AppColors.onSurfaceVariant,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String get _subtitle {
    final category = model.category ?? model.aiLabel ?? 'Uncategorised';
    return '$category · ${model.downloadsCount} downloads';
  }

  String _formatFaces(int faces) {
    if (faces >= 1000000) return '${(faces / 1000000).toStringAsFixed(1)}M';
    if (faces >= 1000) return '${(faces / 1000).toStringAsFixed(0)}K';
    return faces.toString();
  }
}

// ── Placeholder widget ────────────────────────────────────────────────────────

class _ThumbnailPlaceholder extends StatelessWidget {
  const _ThumbnailPlaceholder({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
      child: Container(
        color: AppColors.brandPrimaryBackground,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Decorative 3-D grid pattern
            CustomPaint(painter: _GridPainter()),

            // Centre icon
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.view_in_ar_outlined,
                  size: 36,
                  color: AppColors.brandAccentPrimary.withValues(alpha: 0.5),
                ),
                const SizedBox(height: 6),
                // TODO(thumbnail): replace with actual model preview image
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.brandAccentPrimary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: AppColors.brandAccentPrimary.withValues(
                        alpha: 0.3,
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.construction_rounded,
                        size: 11,
                        color: AppColors.brandAccentPrimary.withValues(
                          alpha: 0.7,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Preview TODO',
                        style: AppTextStyles.labelMd.copyWith(
                          fontSize: 10,
                          color: AppColors.brandAccentPrimary.withValues(
                            alpha: 0.7,
                          ),
                          letterSpacing: 0.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Draws a subtle isometric-style grid on the placeholder background.
class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.brandAccentPrimary.withValues(alpha: 0.04)
      ..strokeWidth = 1;

    const step = 24.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter _) => false;
}
