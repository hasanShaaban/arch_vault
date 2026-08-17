import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_3d_controller/flutter_3d_controller.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_state_views.dart';
import '../../../../core/widgets/app_top_bar.dart';
import '../../../../core/widgets/app_widgets.dart';
import '../../../../core/widgets/auth_gate_dialog.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/widgets/preview_image.dart';
import '../../../../features/auth/presentation/manager/visitor_session_cubit/visitor_session_cubit.dart';
import '../../../home/domain/entities/model_3d_entity.dart';
import '../../../home/presentation/views/widget/model_3d_card.dart';
import '../manager/similar_models_cubit/similar_models_cubit.dart';
import '../manager/similar_models_cubit/similar_models_state.dart';
import 'widget/report_model_dialog.dart';

class ModelDetailView extends StatelessWidget {
  const ModelDetailView({super.key, required this.modelId, this.model});

  final String modelId;
  final Model3dEntity? model;

  @override
  Widget build(BuildContext context) {
    if (model == null) {
      return const Scaffold(
        body: Column(
          children: [
            AppTopBar(),
            Expanded(child: Center(child: CircularProgressIndicator())),
          ],
        ),
      );
    }

    return BlocProvider(
      create: (context) =>
          sl<SimilarModelsCubit>()..fetchSimilarModels(modelId),
      child: Scaffold(
        body: Column(
          children: [
            const AppTopBar(),
            Expanded(child: _ModelDetailBody(model: model!)),
          ],
        ),
      ),
    );
  }
}

class _ModelDetailBody extends StatelessWidget {
  const _ModelDetailBody({required this.model});

  final Model3dEntity model;

  @override
  Widget build(BuildContext context) {
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

          // ── Preview + Info ───────────────────────────────────────────────
          if (isWide)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 3, child: _PreviewPanel(model: model)),
                const SizedBox(width: 24),
                Expanded(flex: 2, child: _InfoCard(model: model)),
              ],
            )
          else ...[
            _PreviewPanel(model: model),
            const SizedBox(height: 16),
            _InfoCard(model: model),
          ],

          // ── Description ─────────────────────────────────────────────────
          const SizedBox(height: 32),
          Text('Description', style: AppTextStyles.headlineSm),
          const SizedBox(height: 8),
          if (model.description != null && model.description!.isNotEmpty)
            Text(model.description!, style: AppTextStyles.bodyLg)
          else
            _PlaceholderField(label: 'Description'),

          // ── AI Predictions ───────────────────────────────────────────────
          if (model.predictions != null || model.aiLabel != null) ...[
            const SizedBox(height: 28),
            Text('AI Predictions', style: AppTextStyles.headlineSm),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                if (model.aiLabel != null)
                  _SpecChip(label: 'AI Label', value: model.aiLabel!),
                if (model.predictions?.superCategory != null)
                  _SpecChip(
                    label: 'Super Category',
                    value: model.predictions!.superCategory!.label,
                  ),
                if (model.predictions?.objectCategory != null)
                  _SpecChip(
                    label: 'Object Category',
                    value: model.predictions!.objectCategory!.label,
                  ),
                if (model.predictions?.styleClass != null &&
                    model.predictions!.styleClass.isNotEmpty)
                  _SpecChip(
                    label: 'Style Class',
                    value: model.predictions!.styleClass
                        .map((e) => e.label)
                        .join(', '),
                  ),
                if (model.predictions?.materialsPrimary != null)
                  _SpecChip(
                    label: 'Primary Material',
                    value: model.predictions!.materialsPrimary!.label,
                  ),
                if (model.predictions?.materialsSecondary != null &&
                    model.predictions!.materialsSecondary.isNotEmpty)
                  _SpecChip(
                    label: 'Secondary Materials',
                    value: model.predictions!.materialsSecondary
                        .map((e) => e.label)
                        .join(', '),
                  ),
              ],
            ),
          ],

          // ── Specifications ───────────────────────────────────────────────
          const SizedBox(height: 28),
          Text('Specifications', style: AppTextStyles.headlineSm),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              if (model.category != null)
                _SpecChip(label: 'Category', value: model.category!),
              if (model.vertices != null)
                _SpecChip(
                  label: 'Vertices',
                  value: _formatCount(model.vertices!),
                ),
              if (model.faces != null)
                _SpecChip(label: 'Faces', value: _formatCount(model.faces!)),
              if (model.tags.isNotEmpty)
                _SpecChip(label: 'Tags', value: model.tags.join(', ')),
              _SpecChip(
                label: 'Uploaded',
                value: _formatDate(model.uploadedAt),
              ),
            ],
          ),

          // ── Similar models ───────────────────────────────────
          const SizedBox(height: 32),
          Text('Similar models', style: AppTextStyles.headlineSm),
          const SizedBox(height: 16),
          BlocBuilder<SimilarModelsCubit, SimilarModelsState>(
            builder: (context, state) {
              if (state is SimilarModelsLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is SimilarModelsSuccess) {
                if (state.models.isEmpty) {
                  return const AppEmptyState(
                    icon: Icons.auto_awesome_outlined,
                    title: 'No similar models found',
                    message:
                        'We could not find any models similar to this one.',
                  );
                }
                return SizedBox(
                  height: 280,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: state.models.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: 16),
                    itemBuilder: (context, index) {
                      return SizedBox(
                        width: 220,
                        child: Model3dCard(
                          model: state.models[index],
                          onTap: () => context.push(
                            AppRoutes.modelDetailPath(state.models[index].id),
                            extra: state.models[index],
                          ),
                        ),
                      );
                    },
                  ),
                );
              } else if (state is SimilarModelsFailure) {
                return AppEmptyState(
                  icon: Icons.error_outline,
                  title: 'Error loading similar models',
                  message: state.message,
                );
              }
              return const SizedBox();
            },
          ),
        ],
      ),
    );
  }

  String _formatCount(int n) {
    if (n >= 1000000) return '${(n / 1000000).toStringAsFixed(1)}M';
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}K';
    return n.toString();
  }

  String _formatDate(DateTime dt) =>
      '${dt.day.toString().padLeft(2, '0')}/'
      '${dt.month.toString().padLeft(2, '0')}/'
      '${dt.year}';
}

// ────────────────────────────────────────────────────────────────────────────
// Preview panel — 3D model viewer (falls back to banner image on error)
// ────────────────────────────────────────────────────────────────────────────
class _PreviewPanel extends StatefulWidget {
  const _PreviewPanel({required this.model});

  final Model3dEntity model;

  @override
  State<_PreviewPanel> createState() => _PreviewPanelState();
}

class _PreviewPanelState extends State<_PreviewPanel> {
  // TODO: replace with the real network URL for the model's GLB/GLTF file
  // once the detail API exposes it (e.g. widget.model.modelUrl).
  static String _modelUrl(Model3dEntity model) =>
      'http://127.0.0.1:8000/media/${model.id}/${model.modelUrl}';

  late final Flutter3DController _controller;

  bool _isRotating = false;
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _controller = Flutter3DController();
    if (_modelUrl(widget.model).isEmpty) {
      _isLoading = false;
      _hasError = true;
    }
  }

  void _toggleRotation() {
    setState(() => _isRotating = !_isRotating);
    if (_isRotating) {
      _controller.startRotation(rotationSpeed: 20);
    } else {
      _controller.pauseRotation();
    }
  }

  void _resetView() {
    _controller.resetCameraOrbit();
    _controller.resetCameraTarget();
    _controller.stopRotation();
    setState(() => _isRotating = false);
  }

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
          // Banner image sits underneath as a fallback / while loading.
          PreviewImage(
            image: widget.model.bannerUrl ?? '',
            borderRadius: BorderRadius.circular(12),
          ),
          if (!_hasError)
            Flutter3DViewer(
              activeGestureInterceptor: true,
              enableTouch: true,
              progressBarColor: AppColors.brandAccentPrimary,
              controller: _controller,
              src: _modelUrl(widget.model),
              onProgress: (_) {
                if (!_isLoading) setState(() => _isLoading = true);
              },
              onLoad: (_) => setState(() {
                _isLoading = false;
                _hasError = false;
              }),
              onError: (_) => setState(() {
                _isLoading = false;
                _hasError = true;
              }),
            ),
          if (_isLoading)
            const Positioned.fill(
              child: ColoredBox(
                color: Colors.black26,
                child: Center(child: CircularProgressIndicator()),
              ),
            ),
          if (!_hasError)
            Positioned(
              top: 12,
              right: 12,
              child: _ViewerControls(
                isRotating: _isRotating,
                onToggleRotation: _toggleRotation,
                onReset: _resetView,
              ),
            ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: Text(
              widget.model.title ?? 'Untitled',
              style: AppTextStyles.bodyMd.copyWith(
                color: AppColors.textWhite,
                fontWeight: FontWeight.w600,
                shadows: const [Shadow(blurRadius: 8, color: Colors.black54)],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ViewerControls extends StatelessWidget {
  const _ViewerControls({
    required this.isRotating,
    required this.onToggleRotation,
    required this.onReset,
  });

  final bool isRotating;
  final VoidCallback onToggleRotation;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            tooltip: isRotating ? 'Pause rotation' : 'Auto-rotate',
            onPressed: onToggleRotation,
            icon: Icon(
              isRotating ? Icons.pause_circle_outline : Icons.threesixty,
              color: AppColors.textWhite,
            ),
          ),
          IconButton(
            tooltip: 'Reset view',
            onPressed: onReset,
            icon: const Icon(Icons.refresh, color: AppColors.textWhite),
          ),
        ],
      ),
    );
  }
}

// ────────────────────────────────────────────────────────────────────────────
// Info card
// ────────────────────────────────────────────────────────────────────────────
class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.model});

  final Model3dEntity model;

  @override
  Widget build(BuildContext context) {
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
          // Title & Report button
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(model.title ?? 'Untitled', style: AppTextStyles.headlineSm),
                    if (model.uploadedBy != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        'by @${model.uploadedBy!.username.split('@').first}',
                        style: AppTextStyles.labelMd.copyWith(
                          color: AppColors.brandAccentPrimary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.flag_outlined,
                  color: Colors.redAccent,
                  size: 22,
                ),
                tooltip: 'Report model',
                onPressed: () {
                  final isGuest =
                      context.read<VisitorSessionCubit>().state
                          is VisitorSessionGuest;
                  if (isGuest) {
                    showAuthGateDialog(context, action: 'report this model');
                  } else {
                    ReportModelDialog.show(context, modelId: model.id);
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            [
              if (model.category != null) model.category!,
              if (model.objectCategory != null) model.objectCategory!,
              if (model.aiLabel != null) model.aiLabel!,
            ].join(' · '),
            style: AppTextStyles.bodyMd,
          ),

          // Stats row
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(
                Icons.star_rounded,
                color: AppColors.tertiaryContainer,
              ),
              const SizedBox(width: 6),
              Text(
                model.ratingScore.toString(),
                style: AppTextStyles.bodyMd.copyWith(
                  color: AppColors.textWhite,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 16),
              const Icon(Icons.download_outlined, size: 18),
              const SizedBox(width: 4),
              Text(
                '${model.downloadsCount} downloads',
                style: AppTextStyles.bodyMd,
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.remove_red_eye_outlined, size: 18),
              const SizedBox(width: 4),
              Text('${model.viewsCount} views', style: AppTextStyles.bodyMd),
              const SizedBox(width: 16),
              const Icon(Icons.hub_outlined, size: 18),
              const SizedBox(width: 4),
              Text('${model.usageCount} uses', style: AppTextStyles.bodyMd),
            ],
          ),

          // AI confidence
          if (model.aiConfidence != null) ...[
            const SizedBox(height: 8),
            Text(
              'AI confidence: ${(model.aiConfidence! * 100).toStringAsFixed(1)}%',
              style: AppTextStyles.labelMd.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ],

          // Rating — TODO: requires cubit
          const SizedBox(height: 20),
          Text('Your rating', style: AppTextStyles.labelMd),
          const SizedBox(height: 8),
          Row(
            children: [
              for (var i = 1; i <= 5; i++)
                Icon(
                  Icons.star_outline_rounded,
                  color: AppColors.tertiaryContainer,
                ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'TODO: Rating interaction requires detail API integration',
            style: AppTextStyles.labelMd.copyWith(
              color: AppColors.onSurfaceVariant,
              fontStyle: FontStyle.italic,
            ),
          ),

          // Download button
          const SizedBox(height: 16),
          Builder(
            builder: (context) {
              final isGuest =
                  context.read<VisitorSessionCubit>().state
                      is VisitorSessionGuest;
              return PrimaryButton(
                label: 'Download model',
                isLoading: false,
                onPressed: isGuest
                    ? () => showAuthGateDialog(
                        context,
                        action: 'download this model',
                      )
                    : () {
                        Dio().download(
                          'http://127.0.0.1:8000/media/${model.id}/${model.modelUrl}',
                          'storage/emulated/0/Download/${model.title}.glb',
                        );
                        // ScaffoldMessenger.of(context).showSnackBar(
                        //   const SnackBar(
                        //     content: Text(
                        //       'TODO: Download will be available once the detail API is integrated.',
                        //     ),
                        //   ),
                        // );
                      },
              );
            },
          ),
        ],
      ),
    );
  }
}

// ────────────────────────────────────────────────────────────────────────────
// Spec chip
// ────────────────────────────────────────────────────────────────────────────
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

// ────────────────────────────────────────────────────────────────────────────
// Placeholder field for optional empty data
// ────────────────────────────────────────────────────────────────────────────
class _PlaceholderField extends StatelessWidget {
  const _PlaceholderField({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.brandSecondarySurface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Text(
        'TODO: $label — will be populated from the API',
        style: AppTextStyles.bodyMd.copyWith(
          color: AppColors.onSurfaceVariant,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }
}
