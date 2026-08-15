import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/app_widgets.dart';
import '../../../../../generated/assets.dart';

class UsernameTextField extends StatelessWidget {
  const UsernameTextField({
    super.key,
    required this.controller,
    this.focusNode,
    this.textInputAction,
    this.onFieldSubmitted,
  });

  final TextEditingController controller;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onFieldSubmitted;

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: controller,
      focusNode: focusNode,
      textInputAction: textInputAction,
      onFieldSubmitted: onFieldSubmitted,
      hintText: 'Username',
      prefixIcon: const Icon(
        Icons.person_outline,
        color: AppColors.onSurfaceVariant,
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Username is required';
        }
        if (value.trim().length < 3) {
          return 'At least 3 characters';
        }
        return null;
      },
    );
  }
}

class EmailTextField extends StatelessWidget {
  const EmailTextField({
    super.key,
    required this.controller,
    this.focusNode,
    this.textInputAction,
    this.onFieldSubmitted,
  });

  final TextEditingController controller;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onFieldSubmitted;

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: controller,
      focusNode: focusNode,
      textInputAction: textInputAction,
      onFieldSubmitted: onFieldSubmitted,
      hintText: 'Email',
      keyboardType: TextInputType.emailAddress,
      prefixIcon: Padding(
        padding: const EdgeInsets.all(12),
        child: SvgPicture.asset(
          Assets.iconsEmail,
          width: 20,
          height: 20,
          colorFilter: const ColorFilter.mode(
            AppColors.onSurfaceVariant,
            BlendMode.srcIn,
          ),
        ),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Email is required';
        }
        if (!value.contains('@')) {
          return 'Enter a valid email';
        }
        return null;
      },
    );
  }
}

class PasswordTextField extends StatefulWidget {
  const PasswordTextField({
    super.key,
    required this.controller,
    this.focusNode,
    this.textInputAction,
    this.onFieldSubmitted,
  });

  final TextEditingController controller;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onFieldSubmitted;

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: widget.controller,
      focusNode: widget.focusNode,
      textInputAction: widget.textInputAction,
      onFieldSubmitted: widget.onFieldSubmitted,
      hintText: 'Password',
      obscureText: _obscure,
      prefixIcon: Padding(
        padding: const EdgeInsets.all(12),
        child: SvgPicture.asset(
          Assets.iconsPassword,
          width: 20,
          height: 20,
          colorFilter: const ColorFilter.mode(
            AppColors.onSurfaceVariant,
            BlendMode.srcIn,
          ),
        ),
      ),
      suffixIcon: IconButton(
        onPressed: () => setState(() => _obscure = !_obscure),
        icon: Icon(
          _obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
          color: AppColors.onSurfaceVariant,
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Password is required';
        }
        if (value.length < 6) {
          return 'At least 6 characters';
        }
        return null;
      },
    );
  }
}

class ConfirmPasswordTextField extends StatefulWidget {
  const ConfirmPasswordTextField({
    super.key,
    required this.controller,
    required this.passwordController,
    this.focusNode,
    this.textInputAction,
    this.onFieldSubmitted,
  });

  final TextEditingController controller;
  final TextEditingController passwordController;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onFieldSubmitted;

  @override
  State<ConfirmPasswordTextField> createState() =>
      _ConfirmPasswordTextFieldState();
}

class _ConfirmPasswordTextFieldState extends State<ConfirmPasswordTextField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: widget.controller,
      focusNode: widget.focusNode,
      textInputAction: widget.textInputAction,
      onFieldSubmitted: widget.onFieldSubmitted,
      hintText: 'Confirm Password',
      obscureText: _obscure,
      prefixIcon: Padding(
        padding: const EdgeInsets.all(12),
        child: SvgPicture.asset(
          Assets.iconsPassword,
          width: 20,
          height: 20,
          colorFilter: const ColorFilter.mode(
            AppColors.onSurfaceVariant,
            BlendMode.srcIn,
          ),
        ),
      ),
      suffixIcon: IconButton(
        onPressed: () => setState(() => _obscure = !_obscure),
        icon: Icon(
          _obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
          color: AppColors.onSurfaceVariant,
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please confirm your password';
        }
        if (value != widget.passwordController.text) {
          return 'Passwords do not match';
        }
        return null;
      },
    );
  }
}

class RoleDropdownField extends StatelessWidget {
  const RoleDropdownField({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final String value;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: 'Select Role',
        prefixIcon: const Icon(
          Icons.badge_outlined,
          color: AppColors.onSurfaceVariant,
        ),
        filled: true,
        fillColor: AppColors.brandPrimaryBackground,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: AppColors.brandAccentPrimary,
            width: 1.5,
          ),
        ),
      ),
      dropdownColor: AppColors.brandSecondarySurface,
      items: const [
        DropdownMenuItem(value: 'designer', child: Text('Designer')),
        DropdownMenuItem(value: 'admin', child: Text('Admin')),
      ],
    );
  }
}
