import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_widgets.dart';
import 'widget/auth_form_fields.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _emailFocus = FocusNode();

  @override
  void dispose() {
    _emailController.dispose();
    _emailFocus.dispose();
    super.dispose();
  }

  // void _submit() {
  //   if (!(_formKey.currentState?.validate() ?? false)) return;
  //   context.read<ForgotPasswordCubit>().submit(
  //         email: _emailController.text.trim(),
  //       );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.brandPrimaryBackground,
              AppColors.brandSecondarySurface,
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.brandSecondarySurface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.outlineVariant.withValues(alpha: 0.5),
                  ),
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'ArchVault',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.headlineSm.copyWith(
                          color: AppColors.brandAccentPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Forgot password',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.headlineSm,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Enter your email and we will send a reset link.',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.bodyMd,
                      ),
                      const SizedBox(height: 24),
                      EmailTextField(
                        controller: _emailController,
                        focusNode: _emailFocus,
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) {},
                      ),
                      const SizedBox(height: 24),
                      PrimaryButton(label: 'Send reset link', onPressed: () {}),
                      const SizedBox(height: 12),
                      TextButton(
                        onPressed: () => context.go(AppRoutes.signIn),
                        child: const Text('Back to Sign In'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
