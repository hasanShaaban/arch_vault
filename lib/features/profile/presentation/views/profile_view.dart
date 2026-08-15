import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_state_views.dart';
import '../../../../core/widgets/app_top_bar.dart';
import '../../../../core/widgets/app_widgets.dart';
import '../../domain/entities/profile_entity.dart';
import '../manager/profile_cubit/profile_cubit.dart';
import '../manager/profile_cubit/profile_state.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<ProfileCubit>().load();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const AppTopBar(),
          Expanded(
            child: BlocBuilder<ProfileCubit, ProfileState>(
              builder: (context, state) {
                if (state is ProfileLoading || state is ProfileInitial) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is ProfileFailureState) {
                  return AppErrorState(
                    message: state.message,
                    onRetry: () => context.read<ProfileCubit>().load(),
                  );
                }
                if (state is! ProfileLoaded) {
                  return const SizedBox.shrink();
                }
                return _ProfileBody(state: state);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileBody extends StatelessWidget {
  const _ProfileBody({required this.state});

  final ProfileLoaded state;

  @override
  Widget build(BuildContext context) {
    final profile = state.profile;
    final assets = state.visibleAssets;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.brandSecondarySurface,
                  AppColors.brandPrimaryBackground,
                ],
              ),
              border: Border.all(
                color: AppColors.brandAccentPrimary.withValues(alpha: 0.15),
              ),
            ),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor:
                      AppColors.brandAccentPrimary.withValues(alpha: 0.2),
                  child: Text(
                    profile.displayName.isNotEmpty
                        ? profile.displayName[0].toUpperCase()
                        : '?',
                    style: AppTextStyles.headlineSm.copyWith(
                      color: AppColors.brandAccentPrimary,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(profile.displayName, style: AppTextStyles.headlineSm),
                const SizedBox(height: 4),
                Text('@${profile.username}', style: AppTextStyles.labelMd),
                const SizedBox(height: 12),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 560),
                  child: Text(
                    profile.bio,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodyMd,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _StatBox(value: '${profile.modelsCount}', label: 'Models'),
                    const SizedBox(width: 12),
                    _StatBox(
                      value: profile.rating.toStringAsFixed(1),
                      label: 'Rating',
                    ),
                    const SizedBox(width: 12),
                    _StatBox(
                      value: '${profile.downloadsCount}',
                      label: 'Downloads',
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: 180,
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      if (context.mounted) {
                        context.go(AppRoutes.signIn);
                      }
                    },
                    icon: const Icon(Icons.logout),
                    label: const Text('Log out'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              ChoiceChip(
                label: const Text('All Assets'),
                selected: state.tab == ProfileTab.all,
                onSelected: (_) =>
                    context.read<ProfileCubit>().selectTab(ProfileTab.all),
                selectedColor:
                    AppColors.brandAccentPrimary.withValues(alpha: 0.2),
                labelStyle: AppTextStyles.labelMd.copyWith(
                  color: state.tab == ProfileTab.all
                      ? AppColors.brandAccentPrimary
                      : AppColors.textWhite,
                ),
                backgroundColor: AppColors.brandSecondarySurface,
                side: BorderSide(
                  color: state.tab == ProfileTab.all
                      ? AppColors.brandAccentPrimary
                      : AppColors.outlineVariant,
                ),
              ),
              const SizedBox(width: 8),
              ChoiceChip(
                label: const Text('Popular'),
                selected: state.tab == ProfileTab.popular,
                onSelected: (_) =>
                    context.read<ProfileCubit>().selectTab(ProfileTab.popular),
                selectedColor:
                    AppColors.brandAccentPrimary.withValues(alpha: 0.2),
                labelStyle: AppTextStyles.labelMd.copyWith(
                  color: state.tab == ProfileTab.popular
                      ? AppColors.brandAccentPrimary
                      : AppColors.textWhite,
                ),
                backgroundColor: AppColors.brandSecondarySurface,
                side: BorderSide(
                  color: state.tab == ProfileTab.popular
                      ? AppColors.brandAccentPrimary
                      : AppColors.outlineVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (assets.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 48),
              child: AppEmptyState(
                icon: Icons.view_in_ar_outlined,
                title: 'No assets in this tab',
                message: 'Uploaded models for this filter will show up here.',
              ),
            )
          else
            GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: assets.length,
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 280,
              mainAxisExtent: 260,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemBuilder: (context, index) {
              final asset = assets[index];
              return AssetCard(
                title: asset.title,
                subtitle: asset.label,
                rating: asset.rating,
                image: asset.image,
                onTap: () => context.go(AppRoutes.modelDetailPath(asset.id)),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  const _StatBox({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 110,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: AppColors.brandPrimaryBackground.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.outlineVariant.withValues(alpha: 0.4),
        ),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: AppTextStyles.headlineSm.copyWith(
              color: AppColors.brandAccentPrimary,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 4),
          Text(label, style: AppTextStyles.labelMd),
        ],
      ),
    );
  }
}
