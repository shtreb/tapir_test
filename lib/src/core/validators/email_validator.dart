class EmailValidator {
  static final RegExp _emailRegex = RegExp(
    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
  );

  static bool isValid(String email) {
    return _emailRegex.hasMatch(email.trim());
  }

  static String? validate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Введите email';
    }
    if (!isValid(value)) {
      return 'Некорректный email';
    }
    return null;
  }
}
