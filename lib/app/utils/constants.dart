import 'package:flutter/material.dart';

class AppColors {
  // Warna Branding Fillix (Biasanya identik dengan warna bioskop/film)
  static const Color primary = Color(0xFFE50914); // Merah Netflix
  static const Color background = Color(0xFF141414); // Hitam Gelap
  static const Color surface = Color(0xFF2F2F2F); // Abu-abu Gelap (Card)
  static const Color textWhite = Colors.white;
  static const Color textGrey = Color(0xFFB3B3B3);
}

class AppPadding {
  static const double small = 8.0;
  static const double medium = 16.0;
  static const double large = 24.0;
}

class AppTextStyle {
  static const TextStyle heading = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textWhite,
  );

  static const TextStyle body = TextStyle(
    fontSize: 16,
    color: AppColors.textWhite,
  );

  static const TextStyle subtitle = TextStyle(
    fontSize: 14,
    color: AppColors.textGrey,
  );
}