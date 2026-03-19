import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tapir_test/gen/assets.gen.dart';
import 'package:tapir_test/src/core/l10n/app_strings.dart';
import 'package:tapir_test/src/core/theme/app_colors.dart';
import 'package:tapir_test/src/core/theme/app_spacing.dart';
import 'package:tapir_test/src/presentation/features/auth/cubit/auth_cubit.dart';
import 'package:tapir_test/src/presentation/features/profile/cubit/profile_cubit.dart';
import 'package:tapir_test/src/presentation/widgets/code_input.dart';
import 'package:tapir_test/src/presentation/widgets/custom_scaffold.dart';
import 'package:tapir_test/src/presentation/widgets/gradient_button.dart';
import 'package:tapir_test/src/presentation/widgets/logout_dialog.dart';
import 'package:tapir_test/src/presentation/widgets/responsive_wrapper.dart';

@RoutePage()
class AuthorizedHomeScreen extends StatefulWidget {
  const AuthorizedHomeScreen({super.key});

  @override
  State<AuthorizedHomeScreen> createState() => _AuthorizedHomeScreenState();
}

class _AuthorizedHomeScreenState extends State<AuthorizedHomeScreen> {
  final TextEditingController _connectCode = TextEditingController();

  @override
  void dispose() {
    _connectCode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profileState = context.watch<ProfileCubit>().state;
    final user = profileState is ProfileLoaded ? profileState.user : null;
    final code = user?.code ?? '------';
    final textStyle = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, dynamic result) async {
        if (didPop) return;
        await _showLogoutDialog(context);
      },
      child: CustomScaffold(
        gradient: AppGradient.mainGradient,
        child: ResponsiveWrapper(
          child: SizedBox(
            height: double.infinity,
            child: SingleChildScrollView(
              padding: AppSpacing.paddingHorizontalMd,
              child: Column(
                children: <Widget>[
                  Assets.delite.svg(height: 46),
                  AppSpacing.verticalMd,
                  Text(AppStrings.appWorksForPair, textAlign: TextAlign.center),
                  AppSpacing.verticalXl,
                  Card(
                    elevation: 0,
                    child: Padding(
                      padding: AppSpacing.paddingMd,
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            width: double.infinity,
                            child: Text(
                              AppStrings.sendCodeToPartner,
                              textAlign: TextAlign.center,
                              style: textStyle.titleLarge?.copyWith(fontSize: 18),
                            ),
                          ),
                          AppSpacing.verticalMd,
                          Text(code, style: textStyle.titleSmall?.copyWith(fontSize: 28, color: colors.primary)),
                          TextButton(
                            onPressed: () {
                              SharePlus.instance.share(ShareParams(text: AppStrings.shareCodeMessage(code)));
                            },
                            child: Text(AppStrings.sendCode, style: TextStyle(color: colors.primary)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  AppSpacing.verticalLg,
                  Text(AppStrings.or, style: textStyle.titleLarge),
                  AppSpacing.verticalLg,
                  Card(
                    elevation: 0,
                    child: Padding(
                      padding: AppSpacing.paddingMd,
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            width: double.infinity,
                            child: Text(
                              AppStrings.enterPartnerCode,
                              textAlign: TextAlign.center,
                              style: textStyle.titleLarge?.copyWith(fontSize: 18),
                            ),
                          ),
                          CodeInput(controller: _connectCode, hint: AppStrings.enterCode, hintTextAlign: TextAlign.center),
                          AppSpacing.verticalMd,
                          GradientButton(onPressed: () {}, text: AppStrings.connect, width: 150),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showLogoutDialog(BuildContext context) async {
    final logout = await LogoutDialog.show(context);
    if (logout && context.mounted) {
      await context.read<AuthCubit>().logout();
    }
  }
}
