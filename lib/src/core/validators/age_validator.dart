class AgeValidator {
  static bool isAdult(DateTime birthDate, {int minAge = 18}) {
    final now = DateTime.now();
    final age = now.year - birthDate.year;

    final hadBirthday = now.month > birthDate.month ||
        (now.month == birthDate.month && now.day >= birthDate.day);

    final actualAge = hadBirthday ? age : age - 1;
    return actualAge >= minAge;
  }

  static String? validate(DateTime? birthDate, {int minAge = 18}) {
    if (birthDate == null) {
      return 'Выберите дату рождения';
    }
    if (!isAdult(birthDate, minAge: minAge)) {
      return 'Вам должно быть не менее $minAge лет';
    }
    return null;
  }
}
