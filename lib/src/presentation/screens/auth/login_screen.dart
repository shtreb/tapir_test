import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tapir_test/gen/assets.gen.dart';
import 'package:tapir_test/src/core/l10n/app_strings.dart';
import 'package:tapir_test/src/core/theme/app_colors.dart';
import 'package:tapir_test/src/core/theme/app_spacing.dart';
import 'package:tapir_test/src/core/validators/email_validator.dart';
import 'package:tapir_test/src/presentation/features/auth/cubit/auth_cubit.dart';
import 'package:tapir_test/src/presentation/widgets/code_input.dart';
import 'package:tapir_test/src/presentation/widgets/custom_scaffold.dart';
import 'package:tapir_test/src/presentation/widgets/email_input.dart';
import 'package:tapir_test/src/presentation/widgets/gradient_button.dart';
import 'package:tapir_test/src/presentation/widgets/responsive_wrapper.dart';

@RoutePage()
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  late final TabController _tabs = TabController(length: 2, vsync: this);
  final TextEditingController _email = TextEditingController();
  final TextEditingController _code = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  bool get _validEmail => EmailValidator.isValid(_email.text);

  bool get _validCode => _code.text.trim().isNotEmpty;

  @override
  void dispose() {
    _tabs.dispose();
    _email.dispose();
    _code.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 15);
    return CustomScaffold(
      gradient: AppGradient.secondGradient,
      child: ResponsiveWrapper(
        child: Column(
          children: <Widget>[
            Assets.delite.svg(height: 47),
            Expanded(
              child: TabBarView(
                controller: _tabs,
                physics: const NeverScrollableScrollPhysics(),
                children: <Widget>[
                  Padding(
                    padding: AppSpacing.paddingHorizontalMd,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[EmailInput(controller: _email, onChanged: (_) => setState(() {}))],
                    ),
                  ),
                  Padding(
                    padding: AppSpacing.paddingHorizontalMd,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        RichText(
                          text: TextSpan(
                            style: titleStyle,
                            children: <InlineSpan>[
                              TextSpan(text: AppStrings.codeSentTo),
                              TextSpan(
                                text: _email.text,
                                style: TextStyle(color: Theme.of(context).colorScheme.primary),
                              ),
                            ],
                          ),
                        ),
                        AppSpacing.verticalMd,
                        CodeInput(controller: _code, onChanged: (_) => setState(() {})),
                        AppSpacing.verticalLg,
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (_errorMessage != null && _tabs.index == 1)
              Padding(
                padding: AppSpacing.paddingVerticalSm,
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              ),
            GradientButton(
              text: _isLoading ? AppStrings.loading : AppStrings.continueButton,
              width: 146,
              onPressed: (_tabs.index == 0 && _validEmail || _tabs.index == 1 && _validCode) && !_isLoading
                  ? () async {
                      if (_tabs.index == 0) {
                        _tabs.animateTo(1);
                        setState(() {});
                      } else {
                        setState(() {
                          _isLoading = true;
                          _errorMessage = null;
                        });

                        final success = await context.read<AuthCubit>().loginWithEmailAndCode(
                          _email.text.trim(),
                          _code.text.trim(),
                        );

                        if (!mounted) return;

                        setState(() {
                          _isLoading = false;
                        });

                        if (!success) {
                          setState(() {
                            _errorMessage = AppStrings.invalidCredentials;
                          });
                        }
                      }
                    }
                  : null,
            ),
            AppSpacing.verticalMd,
            Opacity(
              opacity: _tabs.index != 1 ? .0 : 1,
              child: TextButton(
                onPressed: _tabs.index != 0
                    ? () {
                        _tabs.animateTo(0);
                        setState(() {});
                      }
                    : null,
                child: const Text(AppStrings.backButton),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
