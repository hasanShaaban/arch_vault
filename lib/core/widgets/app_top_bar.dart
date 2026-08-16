import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../constants/app_routes.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../../features/auth/presentation/manager/visitor_session_cubit/visitor_session_cubit.dart';
import 'auth_gate_dialog.dart';

class AppTopBar extends StatelessWidget {
  const AppTopBar({super.key, this.searchController, this.onSearchChanged});

  final TextEditingController? searchController;
  final ValueChanged<String>? onSearchChanged;

  void _submitSearch(BuildContext context, String value) {
    final query = value.trim();
    if (query.isEmpty) {
      context.go(AppRoutes.browse);
      return;
    }
    context.go('${AppRoutes.browse}?q=${Uri.encodeQueryComponent(query)}');
  }

  // bool _isAdmin(BuildContext context) {//TODO: implement is admin
  //   try {
  //     final session = context.read<AuthSessionCubit>().state;
  //     return session is AuthSessionAuthenticated && session.user.isAdmin;
  //   } catch (_) {
  //     return false;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final isCompact = MediaQuery.sizeOf(context).width < 980;
    return BlocBuilder<VisitorSessionCubit, VisitorSessionState>(
      builder: (context, sessionState) {
        final isGuest = sessionState is VisitorSessionGuest;
        final isAdmin = sessionState is VisitorSessionAuthenticated &&
            sessionState.isAdmin;

        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: isCompact ? 12 : 24,
            vertical: 12,
          ),
          decoration: BoxDecoration(
            color: AppColors.brandPrimaryBackground.withValues(alpha: 0.95),
            border: Border(
              bottom: BorderSide(
                color: AppColors.textWhite.withValues(alpha: 0.05),
              ),
            ),
          ),
          child: Row(
            children: [
              InkWell(
                onTap: () => context.go(AppRoutes.home),
                child: Text(
                  'ArchVault',
                  style: AppTextStyles.headlineSm.copyWith(
                    color: AppColors.brandAccentPrimary,
                    fontSize: 20,
                  ),
                ),
              ),
              SizedBox(width: isCompact ? 12 : 32),
              Expanded(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: TextField(
                    controller: searchController,
                    onChanged: onSearchChanged,
                    onSubmitted: (value) => _submitSearch(context, value),
                    textInputAction: TextInputAction.search,
                    style: AppTextStyles.bodyMd.copyWith(
                      color: AppColors.textWhite,
                    ),
                    decoration: const InputDecoration(
                      hintText: 'Search models...',
                      prefixIcon: Icon(
                        Icons.search,
                        color: AppColors.onSurfaceVariant,
                      ),
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 10),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // ── Compact (mobile) menu ──────────────────────────────────────
              if (isCompact)
                PopupMenuButton<String>(
                  tooltip: 'Menu',
                  icon: const Icon(Icons.menu, color: AppColors.textWhite),
                  onSelected: (value) {
                    switch (value) {
                      case 'browse':
                        context.go(AppRoutes.browse);
                      case 'collections':
                        context.go(AppRoutes.collections);
                      case 'upload':
                        if (isGuest) {
                          showAuthGateDialog(context, action: 'upload a model');
                        } else {
                          context.go(AppRoutes.upload);
                        }
                      case 'uploads':
                        if (isGuest) {
                          showAuthGateDialog(
                            context,
                            action: 'view your uploads',
                          );
                        } else {
                          context.go(AppRoutes.uploads);
                        }
                      case 'admin':
                        context.go(AppRoutes.admin);
                      case 'profile':
                        if (isGuest) {
                          showAuthGateDialog(
                            context,
                            action: 'view your profile',
                          );
                        } else {
                          context.go(AppRoutes.profile);
                        }
                      case 'sign_in':
                        context.go(AppRoutes.signIn);
                      case 'sign_up':
                        context.go(AppRoutes.signUp);
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(value: 'browse', child: Text('Browse')),
                    const PopupMenuItem(
                      value: 'collections',
                      child: Text('Collections'),
                    ),
                    // Visitors don't see upload options
                    if (!isGuest) ...[
                      const PopupMenuItem(
                        value: 'upload',
                        child: Text('Upload'),
                      ),
                      const PopupMenuItem(
                        value: 'uploads',
                        child: Text('My Uploads'),
                      ),
                    ],
                    if (isAdmin)
                      const PopupMenuItem(value: 'admin', child: Text('Admin')),
                    if (isGuest) ...[
                      const PopupMenuDivider(),
                      const PopupMenuItem(
                        value: 'sign_in',
                        child: Text('Sign In'),
                      ),
                      const PopupMenuItem(
                        value: 'sign_up',
                        child: Text('Sign Up'),
                      ),
                    ] else
                      const PopupMenuItem(
                        value: 'profile',
                        child: Text('Profile'),
                      ),
                  ],
                )
              // ── Desktop nav ───────────────────────────────────────────────
              else ...[
                _NavLink(
                  label: 'Browse',
                  onTap: () => context.go(AppRoutes.browse),
                ),
                _NavLink(
                  label: 'Collections',
                  onTap: () => context.go(AppRoutes.collections),
                ),
                // Upload links only for authenticated users
                if (!isGuest) ...[
                  _NavLink(
                    label: 'Upload',
                    onTap: () => context.go(AppRoutes.upload),
                  ),
                  _NavLink(
                    label: 'My Uploads',
                    onTap: () => context.go(AppRoutes.uploads),
                  ),
                ],
                if (isAdmin)
                  _NavLink(
                    label: 'Admin',
                    onTap: () => context.go(AppRoutes.admin),
                  ),

                // ── Visitor: Sign In + Sign Up buttons ──────────────────────
                if (isGuest) ...[
                  const SizedBox(width: 8),
                  OutlinedButton(
                    onPressed: () => context.go(AppRoutes.signIn),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.textWhite,
                      side: BorderSide(
                        color: AppColors.outlineVariant.withValues(alpha: 0.6),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text('Sign In'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () => context.go(AppRoutes.signUp),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text('Sign Up'),
                  ),
                ]
                // ── Authenticated: profile icon ──────────────────────────────
                else
                  IconButton(
                    tooltip: 'Profile',
                    onPressed: () => context.go(AppRoutes.profile),
                    icon: const Icon(
                      Icons.person_outline,
                      color: AppColors.textWhite,
                    ),
                  ),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _NavLink extends StatelessWidget {
  const _NavLink({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      child: Text(
        label,
        style: AppTextStyles.bodyMd.copyWith(color: AppColors.textWhite),
      ),
    );
  }
}
