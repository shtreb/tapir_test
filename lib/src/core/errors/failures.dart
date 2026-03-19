import 'package:equatable/equatable.dart';

/// Базовый класс для ошибок
abstract class Failure extends Equatable {
  const Failure(this.message);

  final String message;

  @override
  List<Object?> get props => <Object?>[message];
}

/// Ошибка хранилища (SharedPreferences)
class StorageFailure extends Failure {
  const StorageFailure([super.message = 'Ошибка сохранения данных']);
}

/// Ошибка валидации
class ValidationFailure extends Failure {
  const ValidationFailure([super.message = 'Ошибка валидации']);
}

/// Ошибка выбора изображения
class ImagePickerFailure extends Failure {
  const ImagePickerFailure([super.message = 'Ошибка выбора фото']);
}

/// Ошибка обрезки изображения
class ImageCropperFailure extends Failure {
  const ImageCropperFailure([super.message = 'Ошибка обрезки фото']);
}

/// Операция отменена пользователем
class CancelledFailure extends Failure {
  const CancelledFailure([super.message = 'Операция отменена']);
}

/// Данные повреждены
class DataCorruptedFailure extends Failure {
  const DataCorruptedFailure([super.message = 'Данные повреждены']);
}

/// Доступ запрещен
class PermissionDeniedFailure extends Failure {
  const PermissionDeniedFailure([super.message = 'Доступ запрещен']);
}

/// Неизвестная ошибка
class UnknownFailure extends Failure {
  const UnknownFailure([super.message = 'Произошла неизвестная ошибка']);
}
