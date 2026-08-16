import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../constants/app_routes.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Shows a modal dialog informing the visitor that an action requires login.
///
/// Provides two primary CTAs:
///   • **Sign In** — navigates to the role-selection / login flow.
///   • **Create Account** — navigates directly to the sign-up screen.
///
/// Usage:
/// ```dart
/// showAuthGateDialog(context, action: 'download this model');
/// ```
Future<void> showAuthGateDialog(
  BuildContext context, {
  String action = 'perform this action',
}) {
  return showDialog(
    context: context,
    barrierColor: Colors.black54,
    builder: (ctx) => _AuthGateDialog(action: action),
  );
}

class _AuthGateDialog extends StatelessWidget {
  const _AuthGateDialog({required this.action});

  final String action;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.brandSecondarySurface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 380),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: AppColors.brandAccentPrimary.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.lock_outline_rounded,
                  size: 32,
                  color: AppColors.brandAccentPrimary,
                ),
              ),
              const SizedBox(height: 20),

              // Title
              Text(
                'Login Required',
                style: AppTextStyles.headlineSm,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),

              // Message
              Text(
                'You need to be logged in to $action.\n'
                'Create a free account or sign in to continue.',
                style: AppTextStyles.bodyMd.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 28),

              // Sign In button
              SizedBox(
                width: double.infinity,
                height: 46,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pop();
                    context.go(AppRoutes.roleSelection);
                  },
                  icon: const Icon(Icons.login_rounded, size: 18),
                  label: const Text('Sign In'),
                ),
              ),
              const SizedBox(height: 10),

              // Create Account button
              SizedBox(
                width: double.infinity,
                height: 46,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pop();
                    context.go(AppRoutes.signUp);
                  },
                  icon: const Icon(Icons.person_add_outlined, size: 18),
                  label: const Text('Create Account'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.textWhite,
                    side: BorderSide(
                      color: AppColors.outlineVariant.withValues(alpha: 0.6),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // Cancel
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  'Maybe later',
                  style: AppTextStyles.bodyMd.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
