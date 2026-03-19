import 'package:flutter/material.dart';
import 'package:tapir_test/src/core/theme/app_spacing.dart';

/// Адаптивный wrapper для ограничения ширины контента
class ResponsiveWrapper extends StatelessWidget {
  const ResponsiveWrapper({
    required this.child,
    this.maxWidth,
    this.padding,
    super.key,
  });

  final Widget child;
  final double? maxWidth;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final effectiveMaxWidth = maxWidth ?? AppSpacing.maxContentWidth;
    
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: screenWidth < effectiveMaxWidth ? screenWidth : effectiveMaxWidth,
        ),
        child: Padding(
          padding: padding ?? AppSpacing.paddingHorizontalMd,
          child: child,
        ),
      ),
    );
  }
}

/// Адаптивный Padding в зависимости от размера экрана
class ResponsivePadding extends StatelessWidget {
  const ResponsivePadding({
    required this.child,
    this.mobile,
    this.tablet,
    this.desktop,
    super.key,
  });

  final Widget child;
  final EdgeInsetsGeometry? mobile;
  final EdgeInsetsGeometry? tablet;
  final EdgeInsetsGeometry? desktop;

  @override
  Widget build(BuildContext context) {
    final padding = context.responsive<EdgeInsetsGeometry>(
      mobile: mobile ?? AppSpacing.paddingMd,
      tablet: tablet ?? AppSpacing.paddingLg,
      desktop: desktop ?? AppSpacing.paddingXl,
    );

    return Padding(
      padding: padding,
      child: child,
    );
  }
}

/// Адаптивный размер в зависимости от экрана
class ResponsiveValue<T> extends StatelessWidget {
  const ResponsiveValue({
    required this.mobile,
    this.tablet,
    this.desktop,
    required this.builder,
    super.key,
  });

  final T mobile;
  final T? tablet;
  final T? desktop;
  final Widget Function(T value) builder;

  @override
  Widget build(BuildContext context) {
    final value = context.responsive<T>(
      mobile: mobile,
      tablet: tablet,
      desktop: desktop,
    );

    return builder(value);
  }
}
