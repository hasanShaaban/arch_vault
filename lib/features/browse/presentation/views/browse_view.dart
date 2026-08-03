import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_state_views.dart';
import '../../../../core/widgets/app_top_bar.dart';
import '../../../../core/widgets/app_widgets.dart';
import '../manager/browse_cubit/browse_cubit.dart';
import '../manager/browse_cubit/browse_state.dart';
import 'widget/browse_filter_sidebar.dart';

class BrowseView extends StatefulWidget {
  const BrowseView({super.key});

  @override
  State<BrowseView> createState() => _BrowseViewState();
}

class _BrowseViewState extends State<BrowseView> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final cubit = context.read<BrowseCubit>();
      String? query;
      try {
        query = GoRouterState.of(context).uri.queryParameters['q'];
      } catch (_) {
        query = null;
      }
      cubit.loadAssets().then((_) {
        if (!mounted) return;
        if (query != null && query.isNotEmpty) {
          _searchController.text = query;
          cubit.search(query);
        }
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.sizeOf(context).width >= 900;

    return Scaffold(
      body: Column(
        children: [
          AppTopBar(
            searchController: _searchController,
            onSearchChanged: (value) => context.read<BrowseCubit>().search(value),
          ),
          Expanded(
            child: BlocBuilder<BrowseCubit, BrowseState>(
              builder: (context, state) {
                if (state is BrowseLoading || state is BrowseInitial) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is BrowseFailureState) {
                  return AppErrorState(
                    message: state.message,
                    onRetry: () => context.read<BrowseCubit>().loadAssets(),
                  );
                }
                if (state is! BrowseLoaded) {
                  return const SizedBox.shrink();
                }

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (isWide)
                      BrowseFilterSidebar(
                        selectedLabel: state.label,
                        selectedFormat: state.fileFormat,
                        sortOption: state.sortOption,
                        onLabelSelected: context.read<BrowseCubit>().filterByLabel,
                        onFormatSelected:
                            context.read<BrowseCubit>().filterByFormat,
                        onSortSelected: context.read<BrowseCubit>().sortBy,
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
                              '${state.visibleAssets.length} models',
                              style: AppTextStyles.bodyMd,
                            ),
                            if (!isWide) ...[
                              const SizedBox(height: 16),
                              _MobileFilters(state: state),
                            ],
                            const SizedBox(height: 16),
                            Expanded(
                              child: state.visibleAssets.isEmpty
                                  ? AppEmptyState(
                                      icon: Icons.search_off_outlined,
                                      title: 'No models found',
                                      message:
                                          'No models match your filters. Clear filters or try another search.',
                                      actionLabel: 'Clear search',
                                      onAction: () {
                                        _searchController.clear();
                                        context.read<BrowseCubit>().search('');
                                      },
                                    )
                                  : GridView.builder(
                                      gridDelegate:
                                          const SliverGridDelegateWithMaxCrossAxisExtent(
                                        maxCrossAxisExtent: 280,
                                        mainAxisExtent: 260,
                                        crossAxisSpacing: 16,
                                        mainAxisSpacing: 16,
                                      ),
                                      itemCount: state.visibleAssets.length,
                                      itemBuilder: (context, index) {
                                        final model = state.visibleAssets[index];
                                        return AssetCard(
                                          title: model.title,
                                          subtitle:
                                              '${model.label} · ${model.fileFormat} · ${model.downloadCount} downloads',
                                          rating: model.rating,
                                          image: model.image,
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

  final BrowseLoaded state;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<BrowseCubit>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 40,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              for (final label in BrowseFilterSidebar.labels) ...[
                ChoiceChip(
                  label: Text(label),
                  selected: state.label == label,
                  onSelected: (_) => cubit.filterByLabel(label),
                  selectedColor:
                      AppColors.brandAccentPrimary.withValues(alpha: 0.2),
                  labelStyle: AppTextStyles.labelMd.copyWith(
                    color: state.label == label
                        ? AppColors.brandAccentPrimary
                        : AppColors.textWhite,
                  ),
                  backgroundColor: AppColors.brandSecondarySurface,
                  side: BorderSide(
                    color: state.label == label
                        ? AppColors.brandAccentPrimary
                        : AppColors.outlineVariant,
                  ),
                ),
                const SizedBox(width: 8),
              ],
            ],
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 40,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              for (final format in BrowseFilterSidebar.formats) ...[
                FilterChip(
                  label: Text(format),
                  selected: state.fileFormat == format,
                  onSelected: (_) => cubit.filterByFormat(format),
                  selectedColor:
                      AppColors.brandAccentPrimary.withValues(alpha: 0.2),
                  labelStyle: AppTextStyles.labelMd.copyWith(
                    color: state.fileFormat == format
                        ? AppColors.brandAccentPrimary
                        : AppColors.textWhite,
                  ),
                  backgroundColor: AppColors.brandSecondarySurface,
                  side: BorderSide(
                    color: state.fileFormat == format
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
