import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/di/service_locator.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/widgets/app_widgets.dart';
import '../../manager/report_model_cubit/report_model_cubit.dart';
import '../../manager/report_model_cubit/report_model_state.dart';

class ReportModelDialog extends StatefulWidget {
  const ReportModelDialog({super.key, required this.modelId});

  final String modelId;

  static Future<void> show(BuildContext context, {required String modelId}) {
    return showDialog(
      context: context,
      builder: (_) => BlocProvider(
        create: (_) => sl<ReportModelCubit>(),
        child: ReportModelDialog(modelId: modelId),
      ),
    );
  }

  @override
  State<ReportModelDialog> createState() => _ReportModelDialogState();
}

class _ReportModelDialogState extends State<ReportModelDialog> {
  final _formKey = GlobalKey<FormState>();
  final _reasonController = TextEditingController();

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<ReportModelCubit>().reportModel(
            id: widget.modelId,
            reason: _reasonController.text.trim(),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ReportModelCubit, ReportModelState>(
      listener: (context, state) {
        if (state is ReportModelSuccess) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Report submitted successfully to admin.'),
              backgroundColor: AppColors.brandAccentPrimary,
            ),
          );
        } else if (state is ReportModelFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      },
      child: Dialog(
        backgroundColor: AppColors.brandSecondarySurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          width: 440,
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.flag_outlined,
                          color: Colors.redAccent,
                          size: 22,
                        ),
                        const SizedBox(width: 8),
                        Text('Report Model', style: AppTextStyles.headlineSm),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.close,
                        color: AppColors.onSurfaceVariant,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'Please enter the reason for reporting this model to the admin.',
                  style: AppTextStyles.bodyMd.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _reasonController,
                  maxLines: 4,
                  style: AppTextStyles.bodyMd.copyWith(color: AppColors.textWhite),
                  decoration: InputDecoration(
                    hintText:
                        'Describe the issue (e.g., copyright violation, offensive content, corrupted mesh)...',
                    hintStyle: AppTextStyles.bodyMd.copyWith(
                      color: AppColors.onSurfaceVariant.withValues(alpha: 0.6),
                    ),
                    filled: true,
                    fillColor: AppColors.brandPrimaryBackground,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: AppColors.outlineVariant),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a reason';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 12),
                    BlocBuilder<ReportModelCubit, ReportModelState>(
                      builder: (context, state) {
                        return SizedBox(
                          width: 140,
                          child: PrimaryButton(
                            label: 'Submit',
                            isLoading: state is ReportModelLoading,
                            onPressed: _submit,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
