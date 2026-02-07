import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF8A1D20); // Brand Red from Repo
  static const Color primaryVariant = Color(0xFF700C11);
  static const Color secondary = Color(0xFF03DAC6);
  static const Color background = Colors.white;
  static const Color surface = Colors.white;
  static const Color error = Color(0xFFB00020);

  static const Color inputFill = Color(0xFFFFF8E7); // Pale Yellowish
  static const Color inputBorder = Color(0xFFE0E0E0);

  static const Color textPrimary = Colors.black87;
  static const Color textSecondary = Colors.black54;

  static const Color sentMessageRaw = Color(0xFF9E1C22); // Brand Red for me
  static const Color sentMessageText = Colors.white;
  static const Color receivedMessageRaw = Colors.white;
  static const Color receivedMessageText =
      Colors.black87; // Black text for white bubble

  // Gradients
  static const List<Color> scoreGradient = [
    Colors.red,
    Colors.orange,
    Colors.green,
  ];
  // Gauge Colors
  static const Color success = Colors.green;
  static const Color gradientLightGrey = Color(0xFFEEEEEE);
  static const Color gradientOrange = Color(0xFFFFB700);
  static const Color gradientGreen = Color(0xFF00FF15);
  static const Color gradientCyan = Color(0xFF00E6FF);
}
