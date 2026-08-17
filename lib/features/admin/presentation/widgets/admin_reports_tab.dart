import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_state_views.dart';
import '../../domain/entities/report_entity.dart';

class AdminReportsTab extends StatelessWidget {
  const AdminReportsTab({
    super.key,
    required this.reports,
    this.onDelete,
    this.onUpdate,
    this.onDismiss,
    this.busy = false,
  });

  final List<ReportEntity> reports;
  final ValueChanged<ReportEntity>? onDelete;
  final void Function(
    ReportEntity report,
    Map<String, String> updatedPredictions,
  )? onUpdate;
  final ValueChanged<ReportEntity>? onDismiss;
  final bool busy;

  @override
  Widget build(BuildContext context) {
    if (reports.isEmpty) {
      return const AppEmptyState(
        title: 'No reports found',
        message: 'Incoming model reports will show up here.',
        icon: Icons.flag_outlined,
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(24),
      itemCount: reports.length,
      separatorBuilder: (_, _) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final report = reports[index];
        final reporter = report.reporter;

        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              context.push(
                AppRoutes.modelDetailPath(report.model.id),
                extra: report.model,
              );
            },
            borderRadius: BorderRadius.circular(12),
            child: Ink(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.brandSecondarySurface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.brandAccentPrimary.withValues(alpha: 0.15),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    report.modelTitle,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppTextStyles.headlineSm.copyWith(
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                _StatusBadge(status: report.status),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Reported by @${reporter.username.split('@').first} (${reporter.email})',
                              style: AppTextStyles.labelMd.copyWith(
                                color: AppColors.brandAccentPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _formatDate(report.createdAt),
                            style: AppTextStyles.labelMd.copyWith(
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.chevron_right,
                            color: AppColors.onSurfaceVariant,
                            size: 20,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.brandPrimaryBackground,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppColors.outlineVariant.withValues(alpha: 0.5),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Reason:',
                          style: AppTextStyles.labelMd.copyWith(
                            color: AppColors.onSurfaceVariant,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          report.reason,
                          style: AppTextStyles.bodyMd.copyWith(
                            color: AppColors.textWhite,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (report.adminNote != null &&
                      report.adminNote!.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      'Admin Note: ${report.adminNote}',
                      style: AppTextStyles.labelMd.copyWith(
                        color: AppColors.onSurfaceVariant,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),
                  // Action buttons: Delete, Update, Dismiss
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ElevatedButton.icon(
                        onPressed: busy ? null : () => onDelete?.call(report),
                        icon: const Icon(Icons.delete_outline, size: 16),
                        label: const Text('Delete'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          foregroundColor: Colors.white,
                        ),
                      ),
                      FilledButton.icon(
                        onPressed: busy
                            ? null
                            : () => _showUpdateDialog(context, report),
                        icon: const Icon(Icons.edit_outlined, size: 16),
                        label: const Text('Update'),
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.brandAccentPrimary,
                        ),
                      ),
                      OutlinedButton.icon(
                        onPressed: busy ? null : () => onDismiss?.call(report),
                        icon: const Icon(Icons.close_rounded, size: 16),
                        label: const Text('Dismiss'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showUpdateDialog(BuildContext context, ReportEntity report) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return _UpdatePredictionsDialog(
          report: report,
          onConfirm: (updatedPredictions) {
            onUpdate?.call(report, updatedPredictions);
          },
        );
      },
    );
  }

  static String _formatDate(DateTime dt) {
    return '${dt.day}/${dt.month}/${dt.year} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color text;

    switch (status.toLowerCase()) {
      case 'pending':
        bg = Colors.orange.withValues(alpha: 0.2);
        text = Colors.orangeAccent;
      case 'resolved':
        bg = Colors.green.withValues(alpha: 0.2);
        text = Colors.greenAccent;
      case 'dismissed':
        bg = Colors.grey.withValues(alpha: 0.2);
        text = Colors.grey;
      default:
        bg = AppColors.brandAccentPrimary.withValues(alpha: 0.2);
        text = AppColors.brandAccentPrimary;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        status.toUpperCase(),
        style: AppTextStyles.labelMd.copyWith(
          color: text,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _UpdatePredictionsDialog extends StatefulWidget {
  const _UpdatePredictionsDialog({
    required this.report,
    required this.onConfirm,
  });

  final ReportEntity report;
  final void Function(Map<String, String> updatedPredictions) onConfirm;

  @override
  State<_UpdatePredictionsDialog> createState() =>
      _UpdatePredictionsDialogState();
}

class _UpdatePredictionsDialogState
    extends State<_UpdatePredictionsDialog> {
  late final TextEditingController _superCategoryController;
  late final TextEditingController _subFamilyController;
  late final TextEditingController _primaryMaterialController;
  late final TextEditingController _secondaryMaterialsController;
  late final TextEditingController _styleClassController;

  @override
  void initState() {
    super.initState();
    final model = widget.report.model;
    final pred = model.predictions;

    _superCategoryController = TextEditingController(
      text: pred?.superCategory?.label ?? model.category ?? '',
    );
    _subFamilyController = TextEditingController(
      text: pred?.objectCategory?.label ??
          model.objectCategory ??
          model.aiLabel ??
          '',
    );
    _primaryMaterialController = TextEditingController(
      text: pred?.materialsPrimary?.label ?? '',
    );
    _secondaryMaterialsController = TextEditingController(
      text: pred?.materialsSecondary.map((e) => e.label).join(', ') ?? '',
    );
    _styleClassController = TextEditingController(
      text: pred?.styleClass.map((e) => e.label).join(', ') ?? '',
    );
  }

  @override
  void dispose() {
    _superCategoryController.dispose();
    _subFamilyController.dispose();
    _primaryMaterialController.dispose();
    _secondaryMaterialsController.dispose();
    _styleClassController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.brandPrimaryBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: AppColors.brandAccentPrimary.withValues(alpha: 0.3),
        ),
      ),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500),
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.auto_awesome,
                    color: AppColors.brandAccentPrimary,
                    size: 24,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Update AI Predictions',
                      style: AppTextStyles.headlineSm.copyWith(
                        color: AppColors.textWhite,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(
                      Icons.close,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'Model: ${widget.report.modelTitle}',
                style: AppTextStyles.bodyMd.copyWith(
                  color: AppColors.onSurfaceVariant,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 20),
              _buildField(
                label: 'Super Category',
                controller: _superCategoryController,
                hint: 'e.g., Table, Chair, Furniture',
              ),
              const SizedBox(height: 14),
              _buildField(
                label: 'Sub Family (Object Category)',
                controller: _subFamilyController,
                hint: 'e.g., Dinner Table, Office Chair',
              ),
              const SizedBox(height: 14),
              _buildField(
                label: 'Primary Material',
                controller: _primaryMaterialController,
                hint: 'e.g., Wood, Metal, Glass',
              ),
              const SizedBox(height: 14),
              _buildField(
                label: 'Secondary Materials',
                controller: _secondaryMaterialsController,
                hint: 'e.g., Steel, Leather (comma separated)',
              ),
              const SizedBox(height: 14),
              _buildField(
                label: 'Style Class',
                controller: _styleClassController,
                hint: 'e.g., Modern, Minimalist',
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.onSurfaceVariant,
                      side: const BorderSide(color: AppColors.outlineVariant),
                    ),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 12),
                  FilledButton(
                    onPressed: () {
                      final updated = {
                        'super_category': _superCategoryController.text.trim(),
                        'sub_family': _subFamilyController.text.trim(),
                        'primary_material':
                            _primaryMaterialController.text.trim(),
                        'secondary_materials':
                            _secondaryMaterialsController.text.trim(),
                        'style_class': _styleClassController.text.trim(),
                      };
                      widget.onConfirm(updated);
                      Navigator.of(context).pop();
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.brandAccentPrimary,
                      foregroundColor: Colors.black,
                    ),
                    child: const Text('Confirm Update'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField({
    required String label,
    required TextEditingController controller,
    required String hint,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.labelMd.copyWith(
            color: AppColors.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          style: AppTextStyles.bodyMd.copyWith(color: AppColors.textWhite),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTextStyles.bodyMd.copyWith(
              color: AppColors.onSurfaceVariant.withValues(alpha: 0.5),
            ),
            filled: true,
            fillColor: AppColors.brandSecondarySurface,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: AppColors.outlineVariant.withValues(alpha: 0.6),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: AppColors.brandAccentPrimary,
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
