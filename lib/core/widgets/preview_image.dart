import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// `assets/...` → [Image.asset], otherwise → [Image.network].
class PreviewImage extends StatelessWidget {
  const PreviewImage({
    super.key,
    required this.image,
    this.borderRadius,
    this.fit = BoxFit.cover,
  });

  final String image;
  final BorderRadius? borderRadius;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? BorderRadius.zero;
    final value = image.trim();

    Widget child;
    if (value.isEmpty) {
      child = const _PreviewFallback();
    } else if (value.startsWith('assets/')) {
      child = Image.asset(
        value,
        fit: fit,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (context, error, stackTrace) => const _PreviewFallback(),
      );
    } else {
      child = Image.network(
        value,
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
