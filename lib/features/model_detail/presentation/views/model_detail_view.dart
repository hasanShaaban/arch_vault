import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_state_views.dart';
import '../../../../core/widgets/app_top_bar.dart';
import '../../../../core/widgets/app_widgets.dart';
import '../../../../core/widgets/preview_image.dart';
import '../../domain/entities/model_detail_entity.dart';
import '../manager/model_detail_cubit/model_detail_cubit.dart';
import '../manager/model_detail_cubit/model_detail_state.dart';

class ModelDetailView extends StatelessWidget {
  const ModelDetailView({super.key, required this.modelId});

  final String modelId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const AppTopBar(),
          Expanded(
            child: BlocConsumer<ModelDetailCubit, ModelDetailState>(
              listenWhen: (previous, current) {
                if (current is! ModelDetailLoaded) return false;
                if (current.statusMessage == null) return false;
                if (previous is! ModelDetailLoaded) return true;
                return previous.statusMessage != current.statusMessage;
              },
              listener: (context, state) {
                if (state is ModelDetailLoaded &&
                    state.statusMessage != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.statusMessage!)),
                  );
                }
              },
              builder: (context, state) {
                if (state is ModelDetailLoading ||
                    state is ModelDetailInitial) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is ModelDetailFailureState) {
                  return AppErrorState(
                    message: state.message,
                    onRetry: () =>
                        context.read<ModelDetailCubit>().load(modelId),
                  );
                }
                if (state is! ModelDetailLoaded) {
                  return const SizedBox.shrink();
                }
                return _ModelDetailBody(state: state);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ModelDetailBody extends StatelessWidget {
  const _ModelDetailBody({required this.state});

  final ModelDetailLoaded state;

  @override
  Widget build(BuildContext context) {
    final model = state.model;
    final similar = state.similar;
    final isWide = MediaQuery.sizeOf(context).width >= 960;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextButton.icon(
            onPressed: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go(AppRoutes.browse);
              }
            },
            icon: const Icon(Icons.arrow_back),
            label: const Text('Back'),
          ),
          const SizedBox(height: 8),
          if (isWide)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 3, child: _PreviewPanel(model: model)),
                const SizedBox(width: 24),
                Expanded(
                  flex: 2,
                  child: _InfoCard(state: state),
                ),
              ],
            )
          else ...[
            _PreviewPanel(model: model),
            const SizedBox(height: 16),
            _InfoCard(state: state),
          ],
          const SizedBox(height: 32),
          Text('Description', style: AppTextStyles.headlineSm),
          const SizedBox(height: 8),
          Text(model.description, style: AppTextStyles.bodyLg),
          const SizedBox(height: 28),
          Text('Specifications', style: AppTextStyles.headlineSm),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _SpecChip(label: 'Category', value: model.label),
              _SpecChip(label: 'Format', value: model.fileFormat),
              _SpecChip(
                label: 'Polygons',
                value: model.polygonCount.toString(),
              ),
              _SpecChip(label: 'Author', value: model.author),
            ],
          ),
          const SizedBox(height: 32),
          Text('Similar models', style: AppTextStyles.headlineSm),
          const SizedBox(height: 16),
          if (similar.isEmpty)
            const AppEmptyState(
              icon: Icons.auto_awesome_outlined,
              title: 'No similar models',
              message: 'Related models will show here when available.',
            )
          else
            SizedBox(
              height: 260,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: similar.length,
                separatorBuilder: (context, index) => const SizedBox(width: 16),
                itemBuilder: (context, index) {
                  final item = similar[index];
                  return SizedBox(
                    width: 240,
                    child: AssetCard(
                      title: item.title,
                      subtitle: item.label,
                      rating: item.rating,
                      imageUrl: item.imageUrl,
                      onTap: () => context.go(
                        AppRoutes.modelDetailPath(item.id),
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

class _PreviewPanel extends StatelessWidget {
  const _PreviewPanel({required this.model});

  final ModelDetailEntity model;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 360,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          PreviewImage(
            imageUrl: model.imageUrl,
            borderRadius: BorderRadius.circular(12),
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: Text(
              model.title,
              style: AppTextStyles.bodyMd.copyWith(
                color: AppColors.textWhite,
                fontWeight: FontWeight.w600,
                shadows: const [
                  Shadow(blurRadius: 8, color: Colors.black54),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.state});

  final ModelDetailLoaded state;

  @override
  Widget build(BuildContext context) {
    final model = state.model;
    final cubit = context.read<ModelDetailCubit>();
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.brandSecondarySurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.brandAccentPrimary.withValues(alpha: 0.15),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(model.title, style: AppTextStyles.headlineSm),
          const SizedBox(height: 8),
          Text(
            '${model.label} · ${model.fileFormat}',
            style: AppTextStyles.bodyMd,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(
                Icons.star_rounded,
                color: AppColors.tertiaryContainer,
              ),
              const SizedBox(width: 6),
              Text(
                model.rating.toStringAsFixed(1),
                style: AppTextStyles.bodyMd.copyWith(
                  color: AppColors.textWhite,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 16),
              Text(
                '${model.downloadCount} downloads',
                style: AppTextStyles.bodyMd,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text('by @${model.author}', style: AppTextStyles.labelMd),
          const SizedBox(height: 20),
          Text('Your rating', style: AppTextStyles.labelMd),
          const SizedBox(height: 8),
          Row(
            children: [
              for (var i = 1; i <= 5; i++)
                IconButton(
                  onPressed: state.isRating ? null : () => cubit.rate(i),
                  icon: Icon(
                    (state.userRating ?? 0) >= i
                        ? Icons.star_rounded
                        : Icons.star_outline_rounded,
                    color: AppColors.tertiaryContainer,
                  ),
                ),
              if (state.isRating)
                const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
            ],
          ),
          const SizedBox(height: 16),
          PrimaryButton(
            label: 'Download model',
            isLoading: state.isDownloading,
            onPressed: cubit.download,
          ),
        ],
      ),
    );
  }
}

class _SpecChip extends StatelessWidget {
  const _SpecChip({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.brandSecondarySurface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.labelMd.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: AppTextStyles.bodyMd.copyWith(
              color: AppColors.textWhite,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
