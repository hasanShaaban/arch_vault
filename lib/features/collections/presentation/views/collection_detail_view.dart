import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_state_views.dart';
import '../../../../core/widgets/app_top_bar.dart';
import '../../../../core/widgets/app_widgets.dart';
import '../../domain/entities/collection_detail_entity.dart';
import '../manager/collection_detail_cubit/collection_detail_cubit.dart';
import '../manager/collection_detail_cubit/collection_detail_state.dart';

class CollectionDetailView extends StatelessWidget {
  const CollectionDetailView({super.key, required this.collectionId});

  final String collectionId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const AppTopBar(),
          Expanded(
            child: BlocBuilder<CollectionDetailCubit, CollectionDetailState>(
              builder: (context, state) {
                if (state is CollectionDetailLoading ||
                    state is CollectionDetailInitial) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is CollectionDetailFailureState) {
                  return AppErrorState(
                    message: state.message,
                    onRetry: () => context
                        .read<CollectionDetailCubit>()
                        .load(collectionId),
                  );
                }
                if (state is! CollectionDetailLoaded) {
                  return const SizedBox.shrink();
                }
                return _CollectionDetailBody(detail: state.detail);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _CollectionDetailBody extends StatelessWidget {
  const _CollectionDetailBody({required this.detail});

  final CollectionDetailEntity detail;

  @override
  Widget build(BuildContext context) {
    final collection = detail.collection;
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextButton.icon(
            onPressed: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go(AppRoutes.collections);
              }
            },
            icon: const Icon(Icons.arrow_back),
            label: const Text('Back to collections'),
          ),
          const SizedBox(height: 8),
          Text(collection.name, style: AppTextStyles.headlineSm),
          const SizedBox(height: 4),
          Text(collection.description, style: AppTextStyles.bodyMd),
          const SizedBox(height: 8),
          Text(
            '${detail.models.length} models in this collection',
            style: AppTextStyles.labelMd,
          ),
          const SizedBox(height: 20),
          Expanded(
            child: detail.models.isEmpty
                ? const AppEmptyState(
                    icon: Icons.view_in_ar_outlined,
                    title: 'No models in this collection',
                    message: 'Models added to this collection will appear here.',
                  )
                : GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 280,
                      mainAxisExtent: 260,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: detail.models.length,
                    itemBuilder: (context, index) {
                      final model = detail.models[index];
                      return AssetCard(
                        title: model.title,
                        subtitle: model.label,
                        rating: model.rating,
                        imageUrl: model.imageUrl,
                        onTap: () =>
                            context.go(AppRoutes.modelDetailPath(model.id)),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
