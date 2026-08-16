import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_state_views.dart';
import '../../../../core/widgets/app_top_bar.dart';
import '../../domain/entities/model_3d_entity.dart';
import '../manager/get_models_cubit/get_models_cubit.dart';
import '../manager/get_models_cubit/get_models_state.dart';
import 'widget/home_sections.dart';
import 'widget/model_3d_card.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<GetModelsCubit>()..loadInitial(),
      child: const _HomeViewBody(),
    );
  }
}

class _HomeViewBody extends StatefulWidget {
  const _HomeViewBody();

  @override
  State<_HomeViewBody> createState() => _HomeViewBodyState();
}

class _HomeViewBodyState extends State<_HomeViewBody> {
  static const _categories = ['All', 'Residential', 'Commercial', 'Public'];
  String _selectedCategory = 'All';
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final pos = _scrollController.position;
    // Trigger load-more when within 200 px of the bottom.
    if (pos.pixels >= pos.maxScrollExtent - 200) {
      context.read<GetModelsCubit>().loadMore();
    }
  }

  List<Model3dEntity> _filter(List<Model3dEntity> models) {
    if (_selectedCategory == 'All') return models;
    return models
        .where((m) => (m.category ?? '').toLowerCase() ==
            _selectedCategory.toLowerCase())
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.sizeOf(context).width >= 900;

    return Scaffold(
      body: Column(
        children: [
          const AppTopBar(),
          Expanded(
            child: BlocBuilder<GetModelsCubit, GetModelsState>(
              builder: (context, state) {
                // ── Loading (first fetch) ────────────────────────────────────
                if (state is GetModelsInitial || state is GetModelsLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                // ── Error (first fetch only — load-more errors keep the list)
                if (state is GetModelsFailure) {
                  return AppErrorState(
                    message: state.message,
                    onRetry: () =>
                        context.read<GetModelsCubit>().loadInitial(),
                  );
                }

                if (state is! GetModelsLoaded) return const SizedBox.shrink();

                final models = _filter(state.models);

                return Column(
                  children: [
                    const HomeHeroSection(),
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // ── Desktop sidebar ────────────────────────────────
                          if (isWide)
                            CategorySidebar(
                              categories: _categories,
                              selected: _selectedCategory,
                              onSelected: (v) =>
                                  setState(() => _selectedCategory = v),
                            ),

                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(24),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // ── Mobile chips ────────────────────────
                                  if (!isWide) ...[
                                    SizedBox(
                                      height: 40,
                                      child: ListView.separated(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: _categories.length,
                                        separatorBuilder: (_, _) =>
                                            const SizedBox(width: 8),
                                        itemBuilder: (context, index) {
                                          final category =
                                              _categories[index];
                                          final selected =
                                              category == _selectedCategory;
                                          return ChoiceChip(
                                            label: Text(category),
                                            selected: selected,
                                            onSelected: (_) => setState(
                                              () => _selectedCategory =
                                                  category,
                                            ),
                                            selectedColor: AppColors
                                                .brandAccentPrimary
                                                .withValues(alpha: 0.2),
                                            labelStyle: AppTextStyles.labelMd
                                                .copyWith(
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

                                  // ── Section header + count ───────────────
                                  Row(
                                    children: [
                                      Text(
                                        'All Models',
                                        style: AppTextStyles.headlineSm,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        '(${state.models.length} / ${state.totalPages * 20})',
                                        style: AppTextStyles.labelMd.copyWith(
                                          color: AppColors.onSurfaceVariant,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),

                                  // ── Grid ────────────────────────────────
                                  Expanded(
                                    child: models.isEmpty
                                        ? AppEmptyState(
                                            icon: Icons.view_in_ar_outlined,
                                            title: state.models.isEmpty
                                                ? 'No models yet'
                                                : 'No models in "$_selectedCategory"',
                                            message: state.models.isEmpty
                                                ? 'Models will appear here once available.'
                                                : 'Try another category or select All.',
                                            actionLabel: 'Browse assets',
                                            onAction: () =>
                                                context.go(AppRoutes.browse),
                                          )
                                        : GridView.builder(
                                            controller: _scrollController,
                                            gridDelegate:
                                                const SliverGridDelegateWithMaxCrossAxisExtent(
                                              maxCrossAxisExtent: 280,
                                              mainAxisExtent: 260,
                                              crossAxisSpacing: 16,
                                              mainAxisSpacing: 16,
                                            ),
                                            // +1 for the load-more spinner row
                                            itemCount: models.length +
                                                (state.isLoadingMore ? 1 : 0),
                                            itemBuilder: (context, index) {
                                              // Spinner tile at the end
                                              if (index == models.length) {
                                                return const Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                );
                                              }
                                              return Model3dCard(
                                                model: models[index],
                                                onTap: () => context.go(
                                                  AppRoutes.modelDetailPath(
                                                    models[index].id,
                                                  ),
                                                  extra: models[index],
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
