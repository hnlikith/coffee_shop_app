import 'package:flutter/material.dart';

/// App color constants — matches reference design
/// Splash: dark theme | Home/Detail/Checkout: light theme
class AppColors {
  AppColors._();

  // Primary (warm brown/orange from reference)
  static const Color primary = Color(0xFFC67C4E);
  static const Color primaryLight = Color(0xFFEDD6C8);
  static const Color primaryDark = Color(0xFF9A5B2F);

  // ─── Light Theme (Home, Detail, Checkout) ───
  static const Color lightBackground = Color(0xFFF9F9F9);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightCard = Color(0xFFF2F2F2);
  static const Color lightBorder = Color(0xFFE3E3E3);
  static const Color lightTextPrimary = Color(0xFF2F2D2C);
  static const Color lightTextSecondary = Color(0xFF9B9B9B);
  static const Color lightTextMuted = Color(0xFFAAAAAA);

  // ─── Dark Theme (Splash + Home top section) ───
  static const Color darkBackground = Color(0xFF131313);
  static const Color darkSurface = Color(0xFF2A2A2A);
  static const Color darkSurfaceLight = Color(0xFF313131);

  // Text (dark theme)
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB7B7B7);
  static const Color textMuted = Color(0xFF808080);

  // Accent
  static const Color star = Color(0xFFFBBE21);
  static const Color success = Color(0xFF36D399);
  static const Color error = Color(0xFFFF6B6B);
  static const Color red = Color(0xFFED5151);

  // Delivery badge
  static const Color deliverBg = Color(0xFFF1F1F1);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFFC67C4E), Color(0xFF9A5B2F)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF131313),
      Color(0xFF313131),
    ],
  );
}
