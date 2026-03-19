import 'package:flutter/widgets.dart';

/// Design tokens для отступов и размеров
class AppSpacing {
  AppSpacing._();

  // Базовые отступы (8px grid system)
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
  static const double xxxl = 64.0;

  // Специфичные отступы
  static const double buttonHeight = 48.0;
  static const double inputHeight = 56.0;
  static const double appBarHeight = 56.0;
  static const double bottomNavHeight = 64.0;

  // Радиусы скругления
  static const double radiusXs = 4.0;
  static const double radiusSm = 8.0;
  static const double radiusMd = 12.0;
  static const double radiusLg = 16.0;
  static const double radiusXl = 24.0;
  static const double radiusFull = 9999.0;

  // Размеры иконок
  static const double iconXs = 16.0;
  static const double iconSm = 20.0;
  static const double iconMd = 24.0;
  static const double iconLg = 32.0;
  static const double iconXl = 48.0;

  // Padding EdgeInsets
  static const EdgeInsets paddingXs = EdgeInsets.all(xs);
  static const EdgeInsets paddingSm = EdgeInsets.all(sm);
  static const EdgeInsets paddingMd = EdgeInsets.all(md);
  static const EdgeInsets paddingLg = EdgeInsets.all(lg);
  static const EdgeInsets paddingXl = EdgeInsets.all(xl);

  static const EdgeInsets paddingHorizontalXs = EdgeInsets.symmetric(horizontal: xs);
  static const EdgeInsets paddingHorizontalSm = EdgeInsets.symmetric(horizontal: sm);
  static const EdgeInsets paddingHorizontalMd = EdgeInsets.symmetric(horizontal: md);
  static const EdgeInsets paddingHorizontalLg = EdgeInsets.symmetric(horizontal: lg);
  static const EdgeInsets paddingHorizontalXl = EdgeInsets.symmetric(horizontal: xl);

  static const EdgeInsets paddingVerticalXs = EdgeInsets.symmetric(vertical: xs);
  static const EdgeInsets paddingVerticalSm = EdgeInsets.symmetric(vertical: sm);
  static const EdgeInsets paddingVerticalMd = EdgeInsets.symmetric(vertical: md);
  static const EdgeInsets paddingVerticalLg = EdgeInsets.symmetric(vertical: lg);
  static const EdgeInsets paddingVerticalXl = EdgeInsets.symmetric(vertical: xl);

  // SizedBox для вертикальных отступов
  static const Widget verticalXs = SizedBox(height: xs);
  static const Widget verticalSm = SizedBox(height: sm);
  static const Widget verticalMd = SizedBox(height: md);
  static const Widget verticalLg = SizedBox(height: lg);
  static const Widget verticalXl = SizedBox(height: xl);
  static const Widget verticalXxl = SizedBox(height: xxl);

  // SizedBox для горизонтальных отступов
  static const Widget horizontalXs = SizedBox(width: xs);
  static const Widget horizontalSm = SizedBox(width: sm);
  static const Widget horizontalMd = SizedBox(width: md);
  static const Widget horizontalLg = SizedBox(width: lg);
  static const Widget horizontalXl = SizedBox(width: xl);

  // Breakpoints для адаптивности
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 900;
  static const double desktopBreakpoint = 1200;

  // Максимальная ширина контента
  static const double maxContentWidth = 600;
  static const double maxWideContentWidth = 1200;
}

/// Extension для удобной работы с адаптивностью
extension ResponsiveContext on BuildContext {
  bool get isMobile => MediaQuery.of(this).size.width < AppSpacing.mobileBreakpoint;
  bool get isTablet =>
      MediaQuery.of(this).size.width >= AppSpacing.mobileBreakpoint &&
      MediaQuery.of(this).size.width < AppSpacing.tabletBreakpoint;
  bool get isDesktop => MediaQuery.of(this).size.width >= AppSpacing.desktopBreakpoint;

  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;

  /// Адаптивное значение в зависимости от размера экрана
  T responsive<T>({
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    if (isDesktop && desktop != null) return desktop;
    if (isTablet && tablet != null) return tablet;
    return mobile;
  }
}
