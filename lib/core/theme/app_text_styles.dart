import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  static const TextStyle headlineLg = TextStyle(
    fontFamily: 'Geist',
    fontSize: 48,
    fontWeight: FontWeight.w700,
    height: 56 / 48, // 1.166
    letterSpacing: -0.96, // -0.02em * 48
    color: AppColors.textWhite,
  );

  static const TextStyle headlineMd = TextStyle(
    fontFamily: 'Geist',
    fontSize: 32,
    fontWeight: FontWeight.w600,
    height: 40 / 32, // 1.25
    letterSpacing: -0.32, // -0.01em * 32
    color: AppColors.textWhite,
  );

  static const TextStyle headlineSm = TextStyle(
    fontFamily: 'Geist',
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 32 / 24, // 1.333
    color: AppColors.textWhite,
  );

  static const TextStyle bodyLg = TextStyle(
    fontFamily: 'Geist',
    fontSize: 18,
    fontWeight: FontWeight.w400,
    height: 28 / 18, // 1.555
    color: AppColors.textGrayBlue,
  );

  static const TextStyle bodyMd = TextStyle(
    fontFamily: 'Geist',
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 24 / 16, // 1.5
    color: AppColors.textGrayBlue,
  );

  static const TextStyle labelMd = TextStyle(
    fontFamily: 'Geist',
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 20 / 14, // 1.428
    letterSpacing: 0.28, // 0.02em * 14
    color: AppColors.brandAccentPrimary,
  );

  static const TextStyle headlineLgMobile = TextStyle(
    fontFamily: 'Geist',
    fontSize: 32,
    fontWeight: FontWeight.w700,
    height: 40 / 32, // 1.25
    color: AppColors.textWhite,
  );
}
