import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Shows a network/asset preview with a graceful fallback placeholder.
class PreviewImage extends StatelessWidget {
  const PreviewImage({
    super.key,
    this.imageUrl,
    this.borderRadius,
    this.fit = BoxFit.cover,
  });

  final String? imageUrl;
  final BorderRadius? borderRadius;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? BorderRadius.zero;
    final url = imageUrl?.trim();

    Widget child;
    if (url == null || url.isEmpty) {
      child = const _PreviewFallback();
    } else if (url.startsWith('assets/')) {
      child = Image.asset(
        url,
        fit: fit,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (context, error, stackTrace) => const _PreviewFallback(),
      );
    } else {
      child = Image.network(
        url,
        fit: fit,
        width: double.infinity,
        height: double.infinity,
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return const _PreviewFallback(showSpinner: true);
        },
        errorBuilder: (context, error, stackTrace) => const _PreviewFallback(),
      );
    }

    return ClipRRect(borderRadius: radius, child: child);
  }
}

class _PreviewFallback extends StatelessWidget {
  const _PreviewFallback({this.showSpinner = false});

  final bool showSpinner;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.brandAccentPrimary.withValues(alpha: 0.12),
            AppColors.secondaryContainer.withValues(alpha: 0.45),
          ],
        ),
      ),
      child: Center(
        child: showSpinner
            ? const SizedBox(
                width: 28,
                height: 28,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(
                Icons.view_in_ar_rounded,
                size: 40,
                color: AppColors.brandAccentPrimary,
              ),
      ),
    );
  }
}
