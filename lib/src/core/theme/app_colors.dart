import 'package:flutter/material.dart';

class _RadialEllipseGradientTransform extends GradientTransform {
  final double radiusX;
  final double radiusY;

  const _RadialEllipseGradientTransform(this.radiusX, this.radiusY);

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.diagonal3Values(radiusX, radiusY, 1.0);
  }
}

class AppColors {
  static const primary = Color(0xFF90B000);
  static const secondary = Color(0xFF8E2DE2);

  static const background = Color(0xFFFAFAFA);
  static const surface = Colors.white;

  static const textPrimary = Color(0xFF1A1A1A);
  static const textSecondary = Color(0xFF757575);

  static const disabled = Color(0xFFE0E0E0);
  static const error = Color(0xFFD32F2F);
  static const success = Color(0xFF4CAF50);
}

class AppGradient {
  static const mainGradient = LinearGradient(
    begin: Alignment(0.216, -0.976),
    end: Alignment(-0.216, 0.976),
    stops: [0.028, 0.4012, 0.8533],
    colors: [
      Color(0x00F7FFBB),
      Color(0xFFF3F1E9),
      Color(0xFFEEEDF0),
    ],
  );

  static const secondGradient = LinearGradient(
    begin: Alignment(0.216, -0.976),
    end: Alignment(-0.216, 0.976),
    stops: [0.028, 0.4012, 0.8533],
    colors: [
      Color(0x00DBD0F9),
      Color(0xFFF3F1E9),
      Color(0xFFF1E8ED),
    ],
  );

  static const thirdGradient = RadialGradient(
    center: Alignment(2.1328, -0.5124),
    stops: [0.4423, 1.0],
    colors: [
      Color(0x33C2928B),
      Color(0x00FFFFFF),
    ],
    transform: _RadialEllipseGradientTransform(1.3555, 0.6071),
  );
}