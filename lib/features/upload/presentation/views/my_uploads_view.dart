import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_state_views.dart';
import '../../../../core/widgets/app_top_bar.dart';
import '../../../../core/widgets/app_widgets.dart';
import '../../domain/entities/upload_draft_entity.dart';
import '../manager/my_uploads_cubit/my_uploads_cubit.dart';
import '../manager/my_uploads_cubit/my_uploads_state.dart';

class MyUploadsView extends StatefulWidget {
  const MyUploadsView({super.key});

  @override
  State<MyUploadsView> createState() => _MyUploadsViewState();
}

class _MyUploadsViewState extends State<MyUploadsView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<MyUploadsCubit>().load();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const AppTopBar(),
          Expanded(
            child: BlocBuilder<MyUploadsCubit, MyUploadsState>(
              builder: (context, state) {
                if (state is MyUploadsLoading || state is MyUploadsInitial) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is MyUploadsFailureState) {
                  return AppErrorState(
                    message: state.message,
                    onRetry: () => context.read<MyUploadsCubit>().load(),
                  );
                }
                if (state is! MyUploadsLoaded) {
                  return const SizedBox.shrink();
                }

                return Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'My Uploads',
                                  style: AppTextStyles.headlineSm,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Track drafts, reviews, and published models.',
                                  style: AppTextStyles.bodyMd,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 160,
                            child: PrimaryButton(
                              label: 'New upload',
                              onPressed: () => context.go(AppRoutes.upload),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Expanded(
                        child: state.uploads.isEmpty
                            ? AppEmptyState(
                                icon: Icons.cloud_upload_outlined,
                                title: 'No uploads yet',
                                message:
                                    'Upload your first 3D model to track reviews and publishing.',
                                actionLabel: 'New upload',
                                onAction: () => context.go(AppRoutes.upload),
                              )
                            : ListView.separated(
                                itemCount: state.uploads.length,
                                separatorBuilder: (context, index) =>
                                    const SizedBox(height: 12),
                                itemBuilder: (context, index) {
                                  return _UploadRow(
                                    upload: state.uploads[index],
                                  );
                                },
                              ),
                      ),
                    ],
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

class _UploadRow extends StatelessWidget {
  const _UploadRow({required this.upload});

  final MyUploadEntity upload;

  Color get _statusColor {
    switch (upload.status) {
      case 'Published':
        return AppColors.brandAccentPrimary;
      case 'Under review':
        return AppColors.tertiaryContainer;
      default:
        return AppColors.onSurfaceVariant;
    }
  }

  @override
  Widget build(BuildContext context) {
    final date =
        '${upload.uploadedAt.year}-${upload.uploadedAt.month.toString().padLeft(2, '0')}-${upload.uploadedAt.day.toString().padLeft(2, '0')}';
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.brandSecondarySurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.outlineVariant.withValues(alpha: 0.45),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: AppColors.brandAccentPrimary.withValues(alpha: 0.12),
            ),
            child: const Icon(
              Icons.view_in_ar_rounded,
              color: AppColors.brandAccentPrimary,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  upload.title,
                  style: AppTextStyles.bodyMd.copyWith(
                    color: AppColors.textWhite,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${upload.fileName} · ${upload.category}',
                  style: AppTextStyles.labelMd.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                upload.status,
                style: AppTextStyles.labelMd.copyWith(color: _statusColor),
              ),
              const SizedBox(height: 4),
              Text(date, style: AppTextStyles.labelMd),
            ],
          ),
        ],
      ),
    );
  }
}
