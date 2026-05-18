import 'package:flutter/material.dart';

class AppColors {
  // Warna Branding
  static const Color primary = Color(0xFFE50914); // Merah Netflix

  // Palet Cokelat Baru
  static const Color background = Color(
    0xFF3E2723,
  ); // Cokelat Tua (Background Utama)
  static const Color surface = Color(
    0xFF4E342E,
  ); // Cokelat Sedikit Terang (Card/TextField)
  static const Color accent = Color(0xFFFBE488); // Kuning Pudar (Tombol Play)

  // Warna Teks
  static const Color textWhite = Colors.white;
  static const Color textGrey = Color(0xFFD7CCC8); // Krem Abu-abu (Subtitle)
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
