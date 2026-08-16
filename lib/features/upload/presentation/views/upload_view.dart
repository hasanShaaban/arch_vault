import 'dart:async';
import 'dart:html' as html;
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_3d_controller/flutter_3d_controller.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_top_bar.dart';
import '../../../../core/widgets/app_widgets.dart';
import '../../domain/entities/upload_draft_entity.dart';
import '../manager/upload_cubit/upload_cubit.dart';
import '../manager/upload_cubit/upload_state.dart';

class UploadView extends StatefulWidget {
  const UploadView({super.key});

  @override
  State<UploadView> createState() => _UploadViewState();
}

class _UploadViewState extends State<UploadView> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const AppTopBar(),
          Expanded(
            child: BlocConsumer<UploadCubit, UploadState>(
              listener: (context, state) {
                if (state is! UploadFormState) return;
                if (state.errorMessage != null) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
                }
                if (state.submitted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Upload submitted (mock). Opening My Uploads…',
                      ),
                    ),
                  );
                  context.read<UploadCubit>().reset();
                  context.go(AppRoutes.uploads);
                }
              },
              builder: (context, state) {
                final form = state as UploadFormState;
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 760),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Upload Wizard', style: AppTextStyles.headlineSm),
                        const SizedBox(height: 4),
                        Text(
                          'Upload a 3D model, add details, then review AI labels.',
                          style: AppTextStyles.bodyMd,
                        ),
                        const SizedBox(height: 20),
                        _StepHeader(step: form.step),
                        const SizedBox(height: 24),
                        if (form.step == UploadStep.file) _FileStep(form: form),
                        if (form.step == UploadStep.details)
                          _DetailsStep(
                            form: form,
                            titleController: _titleController,
                            descriptionController: _descriptionController,
                          ),
                        if (form.step == UploadStep.aiReview)
                          _AiReviewStep(form: form),
                      ],
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

class _StepHeader extends StatelessWidget {
  const _StepHeader({required this.step});

  final UploadStep step;

  @override
  Widget build(BuildContext context) {
    final steps = [
      (UploadStep.file, '1. File'),
      (UploadStep.details, '2. Details'),
      (UploadStep.aiReview, '3. AI Review'),
    ];
    return Row(
      children: [
        for (final entry in steps) ...[
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: entry.$1 == step
                    ? AppColors.brandAccentPrimary.withValues(alpha: 0.15)
                    : AppColors.brandSecondarySurface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: entry.$1 == step
                      ? AppColors.brandAccentPrimary
                      : AppColors.outlineVariant.withValues(alpha: 0.5),
                ),
              ),
              child: Text(
                entry.$2,
                textAlign: TextAlign.center,
                style: AppTextStyles.labelMd.copyWith(
                  color: entry.$1 == step
                      ? AppColors.brandAccentPrimary
                      : AppColors.onSurfaceVariant,
                ),
              ),
            ),
          ),
          if (entry.$1 != UploadStep.aiReview) const SizedBox(width: 8),
        ],
      ],
    );
  }
}

class _FileStep extends StatelessWidget {
  const _FileStep({required this.form});

  final UploadFormState form;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<UploadCubit>();
    final Uint8List? fileBytes = form.draft.fileBytes;
    final hasModel = fileBytes != null && form.draft.fileName != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        InkWell(
          onTap: form.isBusy ? null : cubit.pickModelFile,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            height: hasModel ? 90 : 180,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.brandAccentPrimary.withValues(alpha: 0.35),
                style: BorderStyle.solid,
              ),
              color: AppColors.brandSecondarySurface,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (form.isBusy && form.step == UploadStep.file)
                  const CircularProgressIndicator()
                else
                  Icon(
                    hasModel
                        ? Icons.check_circle_outline
                        : Icons.upload_file_outlined,
                    size: hasModel ? 28 : 42,
                    color: AppColors.brandAccentPrimary,
                  ),
                const SizedBox(height: 12),
                Text(
                  form.draft.fileName ?? 'Tap to choose a 3D model file',
                  style: AppTextStyles.bodyMd.copyWith(
                    color: AppColors.textWhite,
                  ),
                ),
                if (!hasModel) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Supported: GLTF, GLB, OBJ, FBX, BLEND',
                    style: AppTextStyles.labelMd.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
        if (hasModel) ...[
          const SizedBox(height: 16),
          _ModelPreviewCard(
            key: ValueKey(form.draft.fileName),
            bytes: fileBytes,
            fileName: form.draft.fileName!,
          ),
        ],
        const SizedBox(height: 20),
        PrimaryButton(
          label: 'Continue',
          isLoading: form.isBusy,
          onPressed: hasModel ? cubit.goToDetails : null,
        ),
      ],
    );
  }
}

/// Simple inline 3D model preview shown right after a GLB/GLTF file is
/// picked, with basic rotate / zoom / reset controls wired to
/// [Flutter3DController].
class _ModelPreviewCard extends StatefulWidget {
  const _ModelPreviewCard({
    super.key,
    required this.bytes,
    required this.fileName,
  });

  final Uint8List bytes;
  final String fileName;

  @override
  State<_ModelPreviewCard> createState() => _ModelPreviewCardState();
}

class _ModelPreviewCardState extends State<_ModelPreviewCard> {
  late final Flutter3DController _controller;
  late final String _blobUrl;

  bool _isRotating = false;
  bool _isLoading = true;
  String? _loadError;
  double _orbitRadius = 5;

  @override
  void initState() {
    super.initState();
    _controller = Flutter3DController();
    _blobUrl = _createBlobUrl(widget.bytes, widget.fileName);
  }

  // Web only: turn the picked file's bytes into an object URL so
  // Flutter3DViewer (which expects an asset path or a URL) can load it.
  String _createBlobUrl(Uint8List bytes, String fileName) {
    final extension = fileName.split('.').last.toLowerCase();
    final mimeType = extension == 'gltf'
        ? 'model/gltf+json'
        : 'model/gltf-binary';
    final blob = html.Blob([bytes], mimeType);
    return html.Url.createObjectUrlFromBlob(blob);
  }

  @override
  void dispose() {
    html.Url.revokeObjectUrl(_blobUrl);
    super.dispose();
  }

  void _toggleRotation() {
    setState(() => _isRotating = !_isRotating);
    if (_isRotating) {
      _controller.startRotation(rotationSpeed: 25);
    } else {
      _controller.pauseRotation();
    }
  }

  void _zoom(double delta) {
    _orbitRadius = (_orbitRadius + delta).clamp(1.0, 20.0);
    _controller.setCameraOrbit(0, 75, _orbitRadius);
  }

  void _resetView() {
    _controller.resetCameraOrbit();
    _controller.resetCameraTarget();
    setState(() {
      _isRotating = false;
      _orbitRadius = 5;
    });
    _controller.stopRotation();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Container(
            height: 320,
            color: AppColors.brandSecondarySurface,
            child: Stack(
              children: [
                Flutter3DViewer(
                  activeGestureInterceptor: true,
                  enableTouch: true,
                  progressBarColor: AppColors.brandAccentPrimary,
                  controller: _controller,
                  src: _blobUrl,
                  onProgress: (_) {
                    if (!_isLoading) setState(() => _isLoading = true);
                  },
                  onLoad: (_) => setState(() {
                    _isLoading = false;
                    _loadError = null;
                  }),
                  onError: (error) => setState(() {
                    _isLoading = false;
                    _loadError = error;
                  }),
                ),
                if (_loadError != null)
                  Positioned.fill(
                    child: Container(
                      color: AppColors.brandSecondarySurface,
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          'Could not preview this model.\n$_loadError',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.bodyMd,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              tooltip: _isRotating ? 'Pause rotation' : 'Auto-rotate',
              onPressed: _toggleRotation,
              icon: Icon(
                _isRotating ? Icons.pause_circle_outline : Icons.threesixty,
              ),
              color: AppColors.brandAccentPrimary,
            ),
            IconButton(
              tooltip: 'Zoom in',
              onPressed: () => _zoom(-1),
              icon: const Icon(Icons.zoom_in),
              color: AppColors.brandAccentPrimary,
            ),
            IconButton(
              tooltip: 'Zoom out',
              onPressed: () => _zoom(1),
              icon: const Icon(Icons.zoom_out),
              color: AppColors.brandAccentPrimary,
            ),
            IconButton(
              tooltip: 'Reset view',
              onPressed: _resetView,
              icon: const Icon(Icons.refresh),
              color: AppColors.brandAccentPrimary,
            ),
          ],
        ),
      ],
    );
  }
}

class _DetailsStep extends StatelessWidget {
  const _DetailsStep({
    required this.form,
    required this.titleController,
    required this.descriptionController,
  });

  final UploadFormState form;
  final TextEditingController titleController;
  final TextEditingController descriptionController;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<UploadCubit>();
    final bannerName = form.draft.bannerImageName;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('File: ${form.draft.fileName}', style: AppTextStyles.labelMd),
        const SizedBox(height: 16),
        AppTextField(controller: titleController, hintText: 'Model title'),
        const SizedBox(height: 12),
        AppTextField(
          controller: descriptionController,
          hintText: 'Description',
        ),
        const SizedBox(height: 12),
        InkWell(
          onTap: form.isBusy ? null : cubit.pickBannerImage,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.outlineVariant.withValues(alpha: 0.5),
              ),
              color: AppColors.brandSecondarySurface,
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.image_outlined,
                  color: AppColors.brandAccentPrimary,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    bannerName ?? 'Upload banner image (optional)',
                    style: AppTextStyles.bodyMd.copyWith(
                      color: bannerName != null
                          ? AppColors.textWhite
                          : AppColors.onSurfaceVariant,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  bannerName != null ? 'Change' : 'Browse',
                  style: AppTextStyles.labelMd.copyWith(
                    color: AppColors.brandAccentPrimary,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: form.isBusy ? null : cubit.back,
                child: const Text('Back'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: PrimaryButton(
                label: 'Start Analyze',
                isLoading: form.isBusy,
                onPressed: () => cubit.runAiReview(
                  title: titleController.text,
                  description: descriptionController.text,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _AiReviewStep extends StatelessWidget {
  const _AiReviewStep({required this.form});

  final UploadFormState form;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<UploadCubit>();
    if (form.isBusy) {
      return const _AnalysisLoadingWidget();
    }

    final labels = form.draft.aiLabels;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('AI classification results', style: AppTextStyles.headlineSm),
        const SizedBox(height: 8),
        Text(
          'Model category, style, and material classification labels.',
          style: AppTextStyles.bodyMd,
        ),
        const SizedBox(height: 16),
        if (labels.isEmpty)
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.brandSecondarySurface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.outlineVariant.withValues(alpha: 0.5),
              ),
            ),
            child: Text(
              'No classification labels returned from AI analysis.',
              style: AppTextStyles.bodyMd.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          )
        else
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.brandSecondarySurface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.outlineVariant.withValues(alpha: 0.5),
              ),
            ),
            child: Column(
              children: [
                for (final item in labels) ...[
                  _LabelBar(item: item),
                  if (item != labels.last) const SizedBox(height: 12),
                ],
              ],
            ),
          ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: form.isBusy ? null : cubit.back,
                child: const Text('Back'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: PrimaryButton(
                label: 'Submit upload',
                isLoading: form.isBusy,
                onPressed: cubit.submit,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _AnalysisLoadingWidget extends StatefulWidget {
  const _AnalysisLoadingWidget();

  @override
  State<_AnalysisLoadingWidget> createState() => _AnalysisLoadingWidgetState();
}

class _AnalysisLoadingWidgetState extends State<_AnalysisLoadingWidget> {
  late final Timer _timer;
  int _secondsElapsed = 0;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _secondsElapsed++;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final statusText =
        _secondsElapsed < 9 ? 'rendering the model' : 'AI Analyzing';

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: AppColors.brandSecondarySurface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.brandAccentPrimary.withValues(alpha: 0.3),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                width: 56,
                height: 56,
                child: CircularProgressIndicator(
                  strokeWidth: 4,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.brandAccentPrimary,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: Text(
                  statusText,
                  key: ValueKey(statusText),
                  style: AppTextStyles.headlineSm.copyWith(
                    color: AppColors.textWhite,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _secondsElapsed < 9
                    ? 'Preparing 3D environment & generating server-side renders'
                    : 'Running neural network categorization & material detection',
                style: AppTextStyles.bodyMd.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LabelBar extends StatelessWidget {
  const _LabelBar({required this.item});

  final AiLabelScore item;

  @override
  Widget build(BuildContext context) {
    final pct = (item.confidence * 100).round();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                item.label,
                style: AppTextStyles.bodyMd.copyWith(
                  color: AppColors.textWhite,
                ),
              ),
            ),
            Text('$pct%', style: AppTextStyles.labelMd),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: item.confidence,
            minHeight: 8,
            backgroundColor: AppColors.outlineVariant.withValues(alpha: 0.35),
            color: AppColors.brandAccentPrimary,
          ),
        ),
      ],
    );
  }
}
