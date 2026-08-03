import 'package:flutter/material.dart';
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
  final _tagsController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _tagsController.dispose();
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
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.errorMessage!)),
                  );
                }
                if (state.submitted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Upload submitted (mock). Opening My Uploads…'),
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
                            tagsController: _tagsController,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        InkWell(
          onTap: form.isBusy ? null : cubit.pickModelFile,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            height: 180,
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
                  const Icon(
                    Icons.upload_file_outlined,
                    size: 42,
                    color: AppColors.brandAccentPrimary,
                  ),
                const SizedBox(height: 12),
                Text(
                  form.draft.fileName ?? 'Tap to choose a 3D model file',
                  style: AppTextStyles.bodyMd.copyWith(
                    color: AppColors.textWhite,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Supported: GLTF, GLB, OBJ, FBX, BLEND',
                  style: AppTextStyles.labelMd.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        PrimaryButton(
          label: 'Continue',
          isLoading: form.isBusy,
          onPressed: cubit.goToDetails,
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
    required this.tagsController,
  });

  final UploadFormState form;
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final TextEditingController tagsController;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<UploadCubit>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'File: ${form.draft.fileName}',
          style: AppTextStyles.labelMd,
        ),
        const SizedBox(height: 16),
        AppTextField(controller: titleController, hintText: 'Model title'),
        const SizedBox(height: 12),
        AppTextField(
          controller: descriptionController,
          hintText: 'Description',
        ),
        const SizedBox(height: 12),
        AppTextField(
          controller: tagsController,
          hintText: 'Tags (comma separated)',
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
                label: 'Run AI Review',
                isLoading: form.isBusy,
                onPressed: () => cubit.runAiReview(
                  title: titleController.text,
                  description: descriptionController.text,
                  tagsCsv: tagsController.text,
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
    final labels = form.draft.aiLabels;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('AI classification results', style: AppTextStyles.headlineSm),
        const SizedBox(height: 8),
        Text(
          'Mock Vision labels — will be replaced by the real AI pipeline.',
          style: AppTextStyles.bodyMd,
        ),
        const SizedBox(height: 16),
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
                style: AppTextStyles.bodyMd.copyWith(color: AppColors.textWhite),
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
