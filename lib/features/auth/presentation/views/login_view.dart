import 'dart:developer';

import 'package:arch_vault/features/auth/presentation/manager/login_cubit/login_cubit.dart';
import 'package:arch_vault/features/auth/presentation/manager/login_cubit/login_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_widgets.dart';
import 'widget/auth_form_fields.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key, this.role = 'user'});

  /// The role chosen on the role-selection screen: 'admin' or 'user'.
  final String role;

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    context.read<LoginCubit>().signIn(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );
  }

  String get _role => widget.role;

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
              child: BlocConsumer<LoginCubit, LoginState>(
                listener: (context, state) {
                  if (state is LoginSuccess) {
                    log('Logged in successfully with ${state.token}');
                    if (_role == 'admin') {
                      context.go(AppRoutes.admin);
                    } else {
                      context.go(AppRoutes.home);
                    }
                  } else if (state is LoginFailureState) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(state.message)));
                  }
                },
                builder: (context, state) {
                  final loading = state is LoginLoading;
                  return Container(
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
                            _role == 'admin' ? 'Admin Sign In' : 'Welcome back',
                            textAlign: TextAlign.center,
                            style: AppTextStyles.headlineSm,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _role == 'admin'
                                ? 'Sign in to access the admin dashboard'
                                : 'Sign in to continue to your vault',
                            style: AppTextStyles.bodyMd,
                          ),
                          const SizedBox(height: 24),
                          EmailTextField(
                            controller: _emailController,
                            focusNode: _emailFocus,
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (_) =>
                                _passwordFocus.requestFocus(),
                          ),
                          const SizedBox(height: 12),
                          PasswordTextField(
                            controller: _passwordController,
                            focusNode: _passwordFocus,
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (_) => _submit(),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () => context.go(
                                AppRoutes.forgotPassword,
                                extra: _role,
                              ),
                              child: const Text('Forgot password?'),
                            ),
                          ),
                          const SizedBox(height: 8),
                          PrimaryButton(
                            label: 'Sign In',
                            isLoading: loading,
                            onPressed: _submit,
                          ),
                          if (_role != 'admin') ...[
                            const SizedBox(height: 12),
                            Wrap(
                              alignment: WrapAlignment.center,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                Text(
                                  "Don't have an account?",
                                  style: AppTextStyles.bodyMd,
                                ),
                                TextButton(
                                  onPressed: () => context.go(AppRoutes.signUp),
                                  child: const Text('Create account'),
                                ),
                              ],
                            ),
                          ],
                          const SizedBox(height: 8),
                          Text(
                            'Admin: demo@archvault.com / password123\n'
                            'User: user@archvault.com / password123',
                            textAlign: TextAlign.center,
                            style: AppTextStyles.labelMd.copyWith(
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
