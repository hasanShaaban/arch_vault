import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_state_views.dart';
import '../../../../core/widgets/app_top_bar.dart';
import '../../../home/presentation/views/widget/model_3d_card.dart';
import '../../domain/constants/browse_categories.dart';
import '../manager/search_cubit/search_cubit.dart';
import '../manager/search_cubit/search_state.dart';
import 'widget/browse_filter_sidebar.dart';

class BrowseView extends StatelessWidget {
  const BrowseView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<SearchCubit>(),
      child: const _BrowseViewBody(),
    );
  }
}

class _BrowseViewBody extends StatefulWidget {
  const _BrowseViewBody();

  @override
  State<_BrowseViewBody> createState() => _BrowseViewBodyState();
}

class _BrowseViewBodyState extends State<_BrowseViewBody> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      String? query;
      try {
        query = GoRouterState.of(context).uri.queryParameters['q'];
      } catch (_) {
        query = null;
      }
      if (query != null && query.isNotEmpty) {
        _searchController.text = query;
      }
      final queryText = query?.trim();
      context.read<SearchCubit>().search(
            q: (queryText != null && queryText.isNotEmpty) ? queryText : null,
          );
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final pos = _scrollController.position;
    if (pos.pixels >= pos.maxScrollExtent - 200) {
      context.read<SearchCubit>().loadMore();
    }
  }

  void _triggerSearch({
    String? superCategory,
    String? subFamily,
    String? styleClass,
  }) {
    final queryText = _searchController.text.trim();
    context.read<SearchCubit>().search(
          q: queryText.isEmpty ? null : queryText,
          superCategory: superCategory,
          subFamily: subFamily,
          styleClass: styleClass,
        );
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.sizeOf(context).width >= 900;

    return Scaffold(
      body: Column(
        children: [
          AppTopBar(
            searchController: _searchController,
            onSearchChanged: (value) {
              final current = context.read<SearchCubit>().state;
              final superCat = current is SearchLoaded ? current.superCategory : null;
              final subFam = current is SearchLoaded ? current.subFamily : null;
              final style = current is SearchLoaded ? current.styleClass : null;

              context.read<SearchCubit>().search(
                    q: value.trim().isEmpty ? null : value.trim(),
                    superCategory: superCat,
                    subFamily: subFam,
                    styleClass: style,
                  );
            },
          ),
          Expanded(
            child: BlocBuilder<SearchCubit, SearchState>(
              builder: (context, state) {
                if (state is SearchLoading || state is SearchInitial) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is SearchFailure) {
                  return AppErrorState(
                    message: state.message,
                    onRetry: () {
                      final queryText = _searchController.text.trim();
                      context.read<SearchCubit>().search(
                            q: queryText.isEmpty ? null : queryText,
                          );
                    },
                  );
                }
                if (state is! SearchLoaded) {
                  return const SizedBox.shrink();
                }

                final models = state.models;

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (isWide)
                      BrowseFilterSidebar(
                        selectedSuperCategory: state.superCategory,
                        selectedSubCategory: state.subFamily,
                        selectedStyleClass: state.styleClass,
                        onSuperCategorySelected: (cat) {
                          _triggerSearch(
                            superCategory: cat,
                            subFamily: null,
                            styleClass: state.styleClass,
                          );
                        },
                        onSubCategorySelected: (sub) {
                          _triggerSearch(
                            superCategory: state.superCategory,
                            subFamily: sub,
                            styleClass: state.styleClass,
                          );
                        },
                        onStyleClassSelected: (style) {
                          _triggerSearch(
                            superCategory: state.superCategory,
                            subFamily: state.subFamily,
                            styleClass: style,
                          );
                        },
                      ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Browse Assets', style: AppTextStyles.headlineSm),
                            const SizedBox(height: 4),
                            Text(
                              '${models.length} models',
                              style: AppTextStyles.bodyMd,
                            ),
                            if (!isWide) ...[
                              const SizedBox(height: 16),
                              _MobileFilters(state: state),
                            ],
                            const SizedBox(height: 16),
                            Expanded(
                              child: models.isEmpty
                                  ? AppEmptyState(
                                      icon: Icons.search_off_outlined,
                                      title: 'No models found',
                                      message:
                                          'No models match your filters. Clear filters or try another search.',
                                      actionLabel: 'Clear search',
                                      onAction: () {
                                        _searchController.clear();
                                        context.read<SearchCubit>().search();
                                      },
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
                                      itemCount: models.length + (state.isLoadingMore ? 1 : 0),
                                      itemBuilder: (context, index) {
                                        if (index == models.length) {
                                          return const Center(
                                            child: Padding(
                                              padding: EdgeInsets.all(16),
                                              child: CircularProgressIndicator(),
                                            ),
                                          );
                                        }
                                        final model = models[index];
                                        return Model3dCard(
                                          model: model,
                                          onTap: () => context.go(
                                            AppRoutes.modelDetailPath(model.id),
                                            extra: model,
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
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _MobileFilters extends StatelessWidget {
  const _MobileFilters({required this.state});

  final SearchLoaded state;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SearchCubit>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 40,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              for (final cat in ['All', ...kSuperCategories.keys]) ...[
                ChoiceChip(
                  label: Text(cat),
                  selected: cat == 'All'
                      ? state.superCategory == null
                      : state.superCategory == cat,
                  onSelected: (_) {
                    final selectedCat = cat == 'All' ? null : cat;
                    cubit.search(
                      q: state.q,
                      superCategory: selectedCat,
                      subFamily: null,
                      styleClass: state.styleClass,
                    );
                  },
                  selectedColor:
                      AppColors.brandAccentPrimary.withValues(alpha: 0.2),
                  labelStyle: AppTextStyles.labelMd.copyWith(
                    color: (cat == 'All'
                                ? state.superCategory == null
                                : state.superCategory == cat)
                        ? AppColors.brandAccentPrimary
                        : AppColors.textWhite,
                  ),
                  backgroundColor: AppColors.brandSecondarySurface,
                  side: BorderSide(
                    color: (cat == 'All'
                                ? state.superCategory == null
                                : state.superCategory == cat)
                        ? AppColors.brandAccentPrimary
                        : AppColors.outlineVariant,
                  ),
                ),
                const SizedBox(width: 8),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
