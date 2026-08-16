import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class RoleSelectionView extends StatefulWidget {
  const RoleSelectionView({super.key});

  @override
  State<RoleSelectionView> createState() => _RoleSelectionViewState();
}

class _RoleSelectionViewState extends State<RoleSelectionView>
    with TickerProviderStateMixin {
  String? _pressedRole;

  late final AnimationController _fadeCtrl;
  late final Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();
    _fadeAnim = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    super.dispose();
  }

  Future<void> _selectRole(String role) async {
    setState(() => _pressedRole = role);
    await Future.delayed(const Duration(milliseconds: 180));
    if (!mounted) return;
    if (role == 'admin') {
      // Admin must log in
      context.go(AppRoutes.signIn, extra: role);
    } else {
      // Regular user goes straight to home as a visitor
      context.go(AppRoutes.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.brandPrimaryBackground,
              AppColors.brandSecondarySurface,
            ],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // ── Main content ─────────────────────────────────────────────────
              FadeTransition(
                opacity: _fadeAnim,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 40,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Spacer(),
                      Text(
                        'ArchVault',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.headlineSm.copyWith(
                          color: AppColors.brandAccentPrimary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Continue as',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.headlineMd,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Select your role to get started',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.bodyMd,
                      ),
                      const Spacer(),
                      _RoleCard(
                        label: 'Admin',
                        description: 'Manage users, reports and content',
                        icon: Icons.admin_panel_settings_rounded,
                        accentColor: AppColors.tertiary,
                        iconBackground:
                            AppColors.tertiaryContainer.withValues(alpha: 0.15),
                        isPressed: _pressedRole == 'admin',
                        onTap: () => _selectRole('admin'),
                      ),
                      const SizedBox(height: 16),
                      _RoleCard(
                        label: 'User',
                        description: 'Browse and discover 3D models — no login required',
                        icon: Icons.person_rounded,
                        accentColor: AppColors.brandAccentPrimary,
                        iconBackground: AppColors.brandAccentPrimary
                            .withValues(alpha: 0.12),
                        isPressed: _pressedRole == 'user',
                        onTap: () => _selectRole('user'),
                      ),
                      const Spacer(flex: 2),
                    ],
                  ),
                ),
              ),

              // ── Close / Skip button ──────────────────────────────────────────
              Positioned(
                top: 8,
                right: 8,
                child: Tooltip(
                  message: 'Continue as visitor',
                  child: IconButton(
                    onPressed: () => context.go(AppRoutes.home),
                    style: IconButton.styleFrom(
                      backgroundColor:
                          AppColors.brandSecondarySurface.withValues(alpha: 0.7),
                    ),
                    icon: const Icon(
                      Icons.close_rounded,
                      color: AppColors.textWhite,
                    ),
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

class _RoleCard extends StatelessWidget {
  const _RoleCard({
    required this.label,
    required this.description,
    required this.icon,
    required this.accentColor,
    required this.iconBackground,
    required this.isPressed,
    required this.onTap,
  });

  final String label;
  final String description;
  final IconData icon;
  final Color accentColor;
  final Color iconBackground;
  final bool isPressed;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isPressed
              ? accentColor.withValues(alpha: 0.08)
              : AppColors.surfaceContainer,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isPressed
                ? accentColor.withValues(alpha: 0.7)
                : AppColors.outlineVariant.withValues(alpha: 0.5),
            width: isPressed ? 1.5 : 1.0,
          ),
          boxShadow: isPressed
              ? [
                  BoxShadow(
                    color: accentColor.withValues(alpha: 0.15),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: iconBackground,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: accentColor, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: AppTextStyles.headlineSm.copyWith(fontSize: 18),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: AppTextStyles.bodyMd.copyWith(fontSize: 14),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: accentColor,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
