import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_state_views.dart';
import '../../../../core/widgets/app_top_bar.dart';
import '../../../../core/widgets/app_widgets.dart';
import '../../domain/entities/model_asset_entity.dart';
import '../manager/home_cubit/home_cubit.dart';
import '../manager/home_cubit/home_state.dart';
import 'widget/home_sections.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  static const _categories = ['All', 'Residential', 'Commercial', 'Public'];
  String _selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<HomeCubit>().loadFeatured();
    });
  }

  List<ModelAssetEntity> _filter(List<ModelAssetEntity> models) {
    if (_selectedCategory == 'All') return models;
    return models.where((m) => m.label == _selectedCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.sizeOf(context).width >= 900;

    return Scaffold(
      body: Column(
        children: [
          const AppTopBar(),
          Expanded(
            child: BlocBuilder<HomeCubit, HomeState>(
              builder: (context, state) {
                if (state is HomeLoading || state is HomeInitial) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is HomeFailureState) {
                  return AppErrorState(
                    message: state.message,
                    onRetry: () => context.read<HomeCubit>().loadFeatured(),
                  );
                }
                if (state is! HomeLoaded) {
                  return const SizedBox.shrink();
                }

                final models = _filter(state.models);

                return Column(
                  children: [
                    const HomeHeroSection(),
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          if (isWide)
                            CategorySidebar(
                              categories: _categories,
                              selected: _selectedCategory,
                              onSelected: (value) {
                                setState(() => _selectedCategory = value);
                              },
                            ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(24),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (!isWide) ...[
                                    SizedBox(
                                      height: 40,
                                      child: ListView.separated(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: _categories.length,
                                        separatorBuilder: (_, _) =>
                                            const SizedBox(width: 8),
                                        itemBuilder: (context, index) {
                                          final category = _categories[index];
                                          final selected =
                                              category == _selectedCategory;
                                          return ChoiceChip(
                                            label: Text(category),
                                            selected: selected,
                                            onSelected: (_) {
                                              setState(
                                                () =>
                                                    _selectedCategory = category,
                                              );
                                            },
                                            selectedColor: AppColors
                                                .brandAccentPrimary
                                                .withValues(alpha: 0.2),
                                            labelStyle:
                                                AppTextStyles.labelMd.copyWith(
                                              color: selected
                                                  ? AppColors.brandAccentPrimary
                                                  : AppColors.textWhite,
                                            ),
                                            backgroundColor:
                                                AppColors.brandSecondarySurface,
                                            side: BorderSide(
                                              color: selected
                                                  ? AppColors.brandAccentPrimary
                                                  : AppColors.outlineVariant,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                  ],
                                  Text(
                                    'Featured models',
                                    style: AppTextStyles.headlineSm,
                                  ),
                                  const SizedBox(height: 16),
                                  Expanded(
                                    child: models.isEmpty
                                        ? AppEmptyState(
                                            icon: Icons.view_in_ar_outlined,
                                            title: state.models.isEmpty
                                                ? 'No featured models'
                                                : 'No models in $_selectedCategory',
                                            message: state.models.isEmpty
                                                ? 'Featured models will appear here once available.'
                                                : 'Try another category or browse all assets.',
                                            actionLabel: 'Browse assets',
                                            onAction: () =>
                                                context.go(AppRoutes.browse),
                                          )
                                        : GridView.builder(
                                      gridDelegate:
                                          const SliverGridDelegateWithMaxCrossAxisExtent(
                                        maxCrossAxisExtent: 280,
                                        mainAxisExtent: 260,
                                        crossAxisSpacing: 16,
                                        mainAxisSpacing: 16,
                                      ),
                                      itemCount: models.length,
                                      itemBuilder: (context, index) {
                                        final model = models[index];
                                        return AssetCard(
                                          title: model.title,
                                          subtitle:
                                              '${model.label} · ${model.downloadCount} downloads',
                                          rating: model.rating,
                                          imageUrl: model.imageUrl,
                                          onTap: () => context.go(
                                            AppRoutes.modelDetailPath(model.id),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
