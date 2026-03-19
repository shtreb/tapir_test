import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:tapir_test/gen/assets.gen.dart';
import 'package:tapir_test/src/core/constants/app_constants.dart';
import 'package:tapir_test/src/core/l10n/app_strings.dart';
import 'package:tapir_test/src/core/theme/app_colors.dart';
import 'package:tapir_test/src/core/theme/app_spacing.dart';
import 'package:tapir_test/src/di/injection.dart';
import 'package:tapir_test/src/presentation/features/auth/cubit/auth_cubit.dart';
import 'package:tapir_test/src/presentation/features/registration/cubit/registration_cubit.dart';
import 'package:tapir_test/src/presentation/widgets/code_input.dart';
import 'package:tapir_test/src/presentation/widgets/custom_scaffold.dart';
import 'package:tapir_test/src/presentation/widgets/custom_text_form_field.dart';
import 'package:tapir_test/src/presentation/widgets/email_input.dart';
import 'package:tapir_test/src/presentation/widgets/gender_selector.dart';
import 'package:tapir_test/src/presentation/widgets/gradient_button.dart';
import 'package:tapir_test/src/presentation/widgets/onboarding_slide.dart';
import 'package:tapir_test/src/presentation/widgets/page_indicator.dart';
import 'package:tapir_test/src/presentation/widgets/responsive_wrapper.dart';

@RoutePage()
class RegistrationScreen extends StatelessWidget {
  const RegistrationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RegistrationCubit>(create: (_) => di<RegistrationCubit>(), child: const _RegistrationBody());
  }
}

class _RegistrationBody extends StatefulWidget {
  const _RegistrationBody();

  @override
  State<_RegistrationBody> createState() => _RegistrationBodyState();
}

class _RegistrationBodyState extends State<_RegistrationBody> {
  final PageController _slides = PageController();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _birthDate = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _code = TextEditingController();

  final _formatter = DateFormat('dd.MM.yyyy');

  int _slide = 0;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegistrationCubit, RegistrationState>(
      builder: (BuildContext context, RegistrationState state) {
        final reg = context.read<RegistrationCubit>();
        Widget child;
        if (state.step == 0) {
          child = _buildOnboardingTab(reg);
        } else if (state.step == 1) {
          child = _buildFormTab(context, state, reg);
        } else {
          child = _buildCodeTab(context, state, reg);
        }

        return CustomScaffold(
          gradient: state.step == 1 ? AppGradient.mainGradient : AppGradient.secondGradient,
          child: ResponsiveWrapper(
            child: Column(
              children: <Widget>[
                Assets.delite.svg(height: 46),
                Expanded(child: child),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildOnboardingTab(RegistrationCubit reg) {
    return Column(
      children: <Widget>[
        Expanded(
          child: PageView.builder(
            controller: _slides,
            itemCount: AppConstants.onboardingSlides.length,
            onPageChanged: (int value) => setState(() => _slide = value),
            itemBuilder: (_, int index) {
              final slide = AppConstants.onboardingSlides[index];
              return OnboardingSlide(title: slide['title']!, description: slide['description']!);
            },
          ),
        ),
        AppSpacing.verticalMd,
        PageIndicator(count: AppConstants.onboardingSlides.length, current: _slide),
        AppSpacing.verticalLg,
        GradientButton(
          text: AppStrings.continueButton,
          width: 146,
          onPressed: () {
            if (_slide < AppConstants.onboardingSlides.length - 1) {
              _slides.nextPage(duration: const Duration(milliseconds: 250), curve: Curves.easeInOut);
            } else {
              reg.nextStep();
            }
          },
        ),
        AppSpacing.verticalMd,
        TextButton(
          onPressed: () {
            if (_slide > 0) {
              _slides.animateToPage(_slide - 1, duration: const Duration(milliseconds: 250), curve: Curves.easeInOut);
            } else {
              context.router.maybePop();
            }
          },
          child: const Text(AppStrings.backButton),
        ),
        AppSpacing.verticalMd,
      ],
    );
  }

  Widget _buildFormTab(BuildContext context, RegistrationState state, RegistrationCubit reg) {
    final viewInsetsBottom = MediaQuery.of(context).viewInsets.bottom;

    return CustomScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      slivers: <Widget>[
        SliverPadding(
          padding: AppSpacing.paddingHorizontalMd.copyWith(top: AppSpacing.md),
          sliver: SliverToBoxAdapter(
            child: GenderSelector(selected: state.gender, onChanged: reg.setGender),
          ),
        ),
        SliverPadding(
          padding: AppSpacing.paddingHorizontalMd.copyWith(top: AppSpacing.md),
          sliver: SliverToBoxAdapter(
            child: CustomTextFormField(
              controller: _name,
              hint: AppStrings.enterName,
              isRequired: true,
              onChanged: reg.setName,
              label: AppStrings.nameLabel,
            ),
          ),
        ),
        SliverPadding(
          padding: AppSpacing.paddingHorizontalMd.copyWith(top: AppSpacing.md),
          sliver: SliverToBoxAdapter(
            child: CustomTextFormField(
              controller: _birthDate,
              hint: AppStrings.selectBirthDate,
              label: AppStrings.birthDateLabel,
              isRequired: true,
              readOnly: true,
              onTap: () async {
                final current = DateTime.now();
                final lastDate = DateTime(current.year - 18, current.month, current.day);
                final selected = await showDatePicker(
                  context: context,
                  firstDate: DateTime(1900),
                  currentDate: state.birthDate,
                  lastDate: lastDate,
                );
                if (selected != null) {
                  _birthDate.value = TextEditingValue(text: _formatter.format(selected));
                  reg.setBirthDate(selected);
                }
              },
            ),
          ),
        ),
        SliverToBoxAdapter(child: AppSpacing.verticalMd),
        SliverPadding(
          padding: AppSpacing.paddingHorizontalMd.copyWith(top: AppSpacing.md),
          sliver: SliverToBoxAdapter(
            child: EmailInput(controller: _email, onChanged: reg.setEmail),
          ),
        ),
        SliverToBoxAdapter(child: AppSpacing.verticalLg),
        SliverFillRemaining(
          hasScrollBody: false,
          fillOverscroll: true,
          child: Padding(
            padding: EdgeInsets.only(bottom: viewInsetsBottom),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                GradientButton(
                  text: AppStrings.continueButton,
                  onPressed: state.isFormValid ? reg.nextStep : null,
                  width: 146,
                ),
                AppSpacing.verticalMd,
                TextButton(onPressed: reg.previousStep, child: const Text(AppStrings.backButton)),
                AppSpacing.verticalMd,
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCodeTab(BuildContext context, RegistrationState state, RegistrationCubit reg) {
    return Padding(
      padding: AppSpacing.paddingMd,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RichText(
                  text: TextSpan(
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 15),
                    children: <InlineSpan>[
                      TextSpan(
                        text: AppStrings.codeSentTo,
                      ),
                      TextSpan(
                        text: state.email,
                        style: TextStyle(color: Theme.of(context).colorScheme.primary),
                      ),
                    ],
                  ),
                ),
                AppSpacing.verticalMd,
                CodeInput(controller: _code, onChanged: reg.setCode),
                AppSpacing.verticalMd,
                SizedBox(
                  width: 240,
                  height: 30,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.grey.shade300),
                    onPressed: () {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(AppStrings.resendCodeNotConfigured)));
                    },
                    child: const Text(AppStrings.resendCode, style: TextStyle(color: Colors.black)),
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: <Widget>[
              if (state.error != null)
                Padding(
                  padding: AppSpacing.paddingVerticalMd,
                  child: Text(
                    state.error!,
                    style: const TextStyle(color: Colors.red, fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                ),
              GradientButton(
                text: state.isLoading ? AppStrings.verifying : AppStrings.continueButton,
                width: 146,
                onPressed: state.canContinueCode && !state.isLoading
                    ? () async {
                        final isValid = await reg.verifyCode();
                        if (!context.mounted) return;

                        if (isValid) {
                          final user = reg.buildUser();
                          await context.read<AuthCubit>().authorize(user);
                        }
                      }
                    : null,
              ),
              AppSpacing.verticalMd,
              TextButton(
                onPressed: state.isLoading ? null : reg.previousStep,
                child: const Text(AppStrings.backButton),
              ),
            ],
          ),
          AppSpacing.verticalMd,
        ],
      ),
    );
  }

  @override
  void dispose() {
    _slides.dispose();
    _name.dispose();
    _birthDate.dispose();
    _email.dispose();
    _code.dispose();
    super.dispose();
  }
}
