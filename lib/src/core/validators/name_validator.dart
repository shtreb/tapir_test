class NameValidator {
  static bool isValid(String name) {
    return name.trim().isNotEmpty && name.trim().length >= 2;
  }

  static String? validate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Введите имя';
    }
    if (value.trim().length < 2) {
      return 'Имя должно содержать минимум 2 символа';
    }
    return null;
  }
}
