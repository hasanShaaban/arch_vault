import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_state_views.dart';
import '../../domain/entities/admin_user_entity.dart';

class AdminUsersTab extends StatelessWidget {
  const AdminUsersTab({
    super.key,
    required this.users,
    required this.onSetRole,
    this.busy = false,
  });

  final List<AdminUserEntity> users;
  final void Function(String id, String role) onSetRole;
  final bool busy;

  @override
  Widget build(BuildContext context) {
    if (users.isEmpty) {
      return const AppEmptyState(
        title: 'No users',
        message: 'Registered users will appear here.',
        icon: Icons.people_outline,
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(24),
      itemCount: users.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final user = users[index];
        final nextRole = user.isAdmin ? 'user' : 'admin';
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainer,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.outlineVariant),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '@${user.username}',
                      style: AppTextStyles.headlineSm.copyWith(fontSize: 18),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user.email,
                      style: AppTextStyles.bodyMd.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${user.role} · ${user.modelsCount} models',
                      style: AppTextStyles.labelMd.copyWith(
                        color: AppColors.brandAccentPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              OutlinedButton(
                onPressed: busy ? null : () => onSetRole(user.id, nextRole),
                child: Text(user.isAdmin ? 'Make user' : 'Make admin'),
              ),
            ],
          ),
        );
      },
    );
  }
}
