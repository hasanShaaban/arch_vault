import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../constants/app_routes.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

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
    final isAdmin = false; //TODO: set it to is admin function

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
                    context.go(AppRoutes.upload);
                  case 'uploads':
                    context.go(AppRoutes.uploads);
                  case 'admin':
                    context.go(AppRoutes.admin);
                  case 'profile':
                    context.go(AppRoutes.profile);
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(value: 'browse', child: Text('Browse')),
                const PopupMenuItem(
                  value: 'collections',
                  child: Text('Collections'),
                ),
                const PopupMenuItem(value: 'upload', child: Text('Upload')),
                const PopupMenuItem(
                  value: 'uploads',
                  child: Text('My Uploads'),
                ),
                if (isAdmin)
                  const PopupMenuItem(value: 'admin', child: Text('Admin')),
                const PopupMenuItem(value: 'profile', child: Text('Profile')),
              ],
            )
          else ...[
            _NavLink(
              label: 'Browse',
              onTap: () => context.go(AppRoutes.browse),
            ),
            _NavLink(
              label: 'Collections',
              onTap: () => context.go(AppRoutes.collections),
            ),
            _NavLink(
              label: 'Upload',
              onTap: () => context.go(AppRoutes.upload),
            ),
            _NavLink(
              label: 'My Uploads',
              onTap: () => context.go(AppRoutes.uploads),
            ),
            if (isAdmin)
              _NavLink(
                label: 'Admin',
                onTap: () => context.go(AppRoutes.admin),
              ),
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
