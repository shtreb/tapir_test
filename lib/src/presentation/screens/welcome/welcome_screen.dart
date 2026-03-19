import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:tapir_test/gen/assets.gen.dart';
import 'package:tapir_test/src/core/l10n/app_strings.dart';
import 'package:tapir_test/src/core/theme/app_colors.dart';
import 'package:tapir_test/src/core/theme/app_spacing.dart';
import 'package:tapir_test/src/presentation/router/app_router.dart';
import 'package:tapir_test/src/presentation/widgets/custom_scaffold.dart';
import 'package:tapir_test/src/presentation/widgets/gradient_button.dart';
import 'package:tapir_test/src/presentation/widgets/responsive_wrapper.dart';

@RoutePage()
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return CustomScaffold(
      gradient: AppGradient.mainGradient,
      child: ResponsiveWrapper(
        child: Padding(
          padding: AppSpacing.paddingLg,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Assets.delite.svg(),
              AppSpacing.verticalMd,
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Spacer(),
                    Text(
                      AppStrings.welcomeTitle,
                      style: textTheme.headlineSmall,
                      textAlign: TextAlign.center,
                    ),
                    AppSpacing.verticalMd,
                    Text(
                      AppStrings.welcomeSubtitle,
                      textAlign: TextAlign.center,
                    ),
                    const Spacer(),
                    const Spacer(),
                  ],
                ),
              ),
              SizedBox(
                width: context.responsive<double>(
                  mobile: 174,
                  tablet: 240,
                  desktop: 300,
                ),
                child: Column(
                  children: <Widget>[
                    GradientButton(
                      text: AppStrings.registrationButton,
                      onPressed: () => context.router.push(const RegistrationRoute()),
                    ),
                    AppSpacing.verticalMd,
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => context.router.push(const LoginRoute()),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.grey.shade300),
                        child: const Text(
                          AppStrings.loginButton,
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                    AppSpacing.verticalMd,
                    TextButton(
                      onPressed: () {},
                      child: const Text(AppStrings.restoreButton),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
