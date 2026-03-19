import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tapir_test/gen/assets.gen.dart';
import 'package:tapir_test/src/core/errors/error_handler.dart';
import 'package:tapir_test/src/core/errors/failures.dart';
import 'package:tapir_test/src/core/l10n/app_strings.dart';
import 'package:tapir_test/src/core/theme/app_colors.dart';
import 'package:tapir_test/src/core/theme/app_spacing.dart';
import 'package:tapir_test/src/presentation/features/auth/cubit/auth_cubit.dart';
import 'package:tapir_test/src/presentation/features/profile/cubit/profile_cubit.dart';
import 'package:tapir_test/src/presentation/widgets/custom_scaffold.dart';
import 'package:tapir_test/src/presentation/widgets/error_snackbar.dart';
import 'package:tapir_test/src/presentation/widgets/gradient_button.dart';
import 'package:tapir_test/src/presentation/widgets/logout_dialog.dart';
import 'package:tapir_test/src/presentation/widgets/responsive_wrapper.dart';

@RoutePage()
class AddPhotoScreen extends StatefulWidget {
  const AddPhotoScreen({super.key});

  @override
  State<StatefulWidget> createState() => _AddPhotoScreen();
}

class _AddPhotoScreen extends State<AddPhotoScreen> {
  String? _path;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, dynamic result) async {
        if (didPop) return;
        await _showLogoutDialog(context);
      },
      child: CustomScaffold(
        gradient: AppGradient.mainGradient,
        child: ResponsiveWrapper(
          child: BlocBuilder<ProfileCubit, ProfileState>(
            builder: (BuildContext context, ProfileState state) {
              final isLoading = state is ProfileLoading;
              return Column(
              children: <Widget>[
                Assets.delite.svg(height: 46),
                AppSpacing.verticalXl,
                _path == null
                    ? GestureDetector(onTap: _getPhoto, child: Assets.circleAvatar.svg())
                    : CircleAvatar(
                        radius: 217 / 2,
                        backgroundImage: _path != null ? FileImage(File(_path!)) : null,
                        child: _path == null ? const Icon(Icons.person, size: 48) : null,
                      ),
                AppSpacing.verticalLg,
                TextButton(
                  onPressed: _getPhoto,
                  child: Text(_path != null ? AppStrings.changePhoto : AppStrings.addPhoto),
                ),
                const Spacer(),
              GradientButton(
                text: isLoading ? AppStrings.loading : AppStrings.continueButton,
                width: 146,
                onPressed: _path != null && !isLoading
                    ? () async {
                        try {
                          final updated = await context.read<ProfileCubit>().updatePhoto(_path!);
                          if (!context.mounted) return;
                          await context.read<AuthCubit>().authorize(updated);
                          if (!context.mounted) return;
                          SuccessSnackbar.show(context, message: AppStrings.photoSaved);
                        } catch (e) {
                          if (!context.mounted) return;
                          final failure = ErrorHandler.handleException(e);
                          ErrorSnackbar.showFailure(
                            context,
                            failure: failure,
                            onRetry: ErrorHandler.isRetryable(failure)
                                ? () async {
                                    try {
                                      final updated = await context.read<ProfileCubit>().updatePhoto(_path!);
                                      if (!context.mounted) return;
                                      await context.read<AuthCubit>().authorize(updated);
                                    } catch (_) {}
                                  }
                                : null,
                          );
                        }
                      }
                    : null,
                ),
                AppSpacing.verticalMd,
                TextButton(
                  onPressed: () => _showLogoutDialog(context),
                  child: const Text(AppStrings.backButton),
                ),
              ],
            );
            },
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

  Future<void> _getPhoto() async {
    try {
      final picker = ImagePicker();
      final file = await picker.pickImage(source: ImageSource.gallery);
      
      // Пользователь отменил выбор
      if (file == null) {
        if (!context.mounted) return;
        InfoSnackbar.show(context, message: AppStrings.operationCancelled);
        return;
      }
      
      if (!context.mounted) return;
      
      final cropped = await ImageCropper().cropImage(
        sourcePath: file.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: '',
            hideBottomControls: true,
            lockAspectRatio: true,
          ),
        ],
      );
      
      // Пользователь отменил обрезку
      if (cropped == null) {
        if (!context.mounted) return;
        InfoSnackbar.show(context, message: AppStrings.operationCancelled);
        return;
      }
      
      if (!context.mounted) return;
      setState(() => _path = cropped.path);
    } on ImagePickerFailure catch (e) {
      if (!context.mounted) return;
      ErrorSnackbar.show(context, message: e.message, onRetry: _getPhoto);
    } on ImageCropperFailure catch (e) {
      if (!context.mounted) return;
      ErrorSnackbar.show(context, message: e.message, onRetry: _getPhoto);
    } catch (e) {
      if (!context.mounted) return;
      final failure = ErrorHandler.handleException(e);
      ErrorSnackbar.showFailure(
        context,
        failure: failure,
        onRetry: ErrorHandler.isRetryable(failure) ? _getPhoto : null,
      );
    }
  }
}
