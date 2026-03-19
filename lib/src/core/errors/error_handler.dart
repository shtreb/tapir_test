import 'dart:io';

import 'package:tapir_test/src/core/errors/failures.dart';
import 'package:tapir_test/src/core/l10n/app_strings.dart';

/// Централизованная обработка ошибок
class ErrorHandler {
  ErrorHandler._();

  /// Преобразует Exception в Failure
  static Failure handleException(Object error, [StackTrace? stackTrace]) {
    if (error is Failure) {
      return error;
    }

    // SharedPreferences errors
    if (error is FileSystemException) {
      return StorageFailure(AppStrings.storageError);
    }

    // Image picker/cropper errors
    if (error.toString().contains('image_picker')) {
      return const ImagePickerFailure();
    }

    if (error.toString().contains('image_cropper')) {
      return const ImageCropperFailure();
    }

    // Permission errors
    if (error.toString().toLowerCase().contains('permission')) {
      return PermissionDeniedFailure(AppStrings.permissionDenied);
    }

    // Cancelled operations
    if (error.toString().toLowerCase().contains('cancel')) {
      return const CancelledFailure();
    }

    // Format/Parse errors
    if (error is FormatException) {
      return DataCorruptedFailure(AppStrings.dataCorrupted);
    }

    // Unknown error
    return UnknownFailure(AppStrings.errorWithMessage(error.toString()));
  }

  /// Получить пользовательское сообщение из Failure
  static String getUserMessage(Failure failure) {
    return failure.message;
  }

  /// Проверить, является ли ошибка критичной
  static bool isCritical(Failure failure) {
    return failure is StorageFailure || failure is DataCorruptedFailure;
  }

  /// Проверить, можно ли повторить операцию
  static bool isRetryable(Failure failure) {
    return failure is! ValidationFailure && 
           failure is! CancelledFailure &&
           failure is! PermissionDeniedFailure;
  }
}
