/// Централизованные строки приложения
/// В будущем можно заменить на flutter_localizations
class AppStrings {
  AppStrings._();

  // Общие
  static const String appName = 'МЫ.ГАРМОНИЯ';
  static const String continueButton = 'Продолжить';
  static const String backButton = 'Назад';
  static const String cancelButton = 'Отменить';
  static const String doneButton = 'Готово';
  static const String saveButton = 'Сохранить';
  static const String deleteButton = 'Удалить';
  static const String closeButton = 'Закрыть';
  static const String loading = 'Загрузка...';
  static const String or = 'или';

  // Welcome Screen
  static const String welcomeTitle = 'Это ваше пространство\nдля двоих';
  static const String welcomeSubtitle = 'Спокойно. Шаг за шагом. 5 минут в день';
  static const String registrationButton = 'Регистрация';
  static const String loginButton = 'Войти';
  static const String restoreButton = 'Восстановить';

  // Login Screen
  static const String loginTitle = 'Вход';
  static String codeSentTo = 'Мы отправили код на ';
  static const String enterCode = 'Введите код';
  static const String invalidCredentials = 'Неверный email или код';

  // Registration Screen
  static const String registrationTitle = 'Регистрация';
  static const String onboardingSlide1Title = 'Добро пожаловать';
  static const String onboardingSlide1Description = 'Создайте пару и начните путь к гармонии';
  static const String onboardingSlide2Title = 'Ежедневные задания';
  static const String onboardingSlide2Description = 'Выполняйте задания вместе каждый день';
  static const String onboardingSlide3Title = 'Растите вместе';
  static const String onboardingSlide3Description = 'Укрепляйте отношения шаг за шагом';
  
  static const String selectGender = 'Пол';
  static const String male = 'Муж';
  static const String female = 'Жен';
  static const String enterName = 'Имя';
  static const String nameLabel = 'Как вы хотите чтобы вас называли';
  static const String enterEmail = 'Email';
  static const String selectBirthDate = 'Дата рождения';
  static const String birthDateLabel = 'Важно указать точную дату';
  static const String resendCode = 'Отправить код повторно';
  static const String resendCodeNotConfigured = 'Отправка кода повторно пока не настроена';
  static const String invalidCode = 'Неверный код подтверждения';
  static const String verifying = 'Проверка...';

  // Add Photo Screen
  static const String addPhotoTitle = 'Добавить фото';
  static const String addPhoto = 'Добавить фото';
  static const String changePhoto = 'Изменить';
  static const String photoRequired = 'Фото обязательно';
  static const String selectPhotoError = 'Ошибка выбора фото';
  static const String cropPhotoError = 'Ошибка обрезки фото';
  static const String savePhotoError = 'Ошибка сохранения фото';

  // Authorized Home Screen
  static const String homeTitle = 'Главная';
  static const String appWorksForPair = 'Это приложение работает только\nдля пары';
  static const String sendCodeToPartner = 'Отправь этот код своему партнеру';
  static const String sendCode = 'Отправить код';
  static String shareCodeMessage(String code) =>
      'Хочу быть с тобой в гармонии каждый день. Скачай приложение "$appName" и введи наш код пары $code';
  static const String enterPartnerCode = 'Введите код вашего партнера';
  static const String connect = 'Подключить';

  // Logout Dialog
  static const String logoutTitle = 'Разлогиниться?';
  static const String logoutMessage = 'Вы хотите разлогиниться?';
  static const String logoutConfirm = 'Выйти';
  static const String logoutCancel = 'Продолжить';

  // Validation Messages
  static const String emailRequired = 'Email обязателен';
  static const String emailInvalid = 'Неверный формат email';
  static const String nameRequired = 'Имя обязательно';
  static const String nameTooShort = 'Имя слишком короткое';
  static const String ageRequired = 'Дата рождения обязательна';
  static String ageTooYoung(int minAge) => 'Вам должно быть не менее $minAge лет';
  static const String codeRequired = 'Код обязателен';
  static const String codeInvalid = 'Неверный формат кода';

  // Error Messages
  static const String unknownError = 'Произошла неизвестная ошибка';
  static const String networkError = 'Ошибка сети. Проверьте подключение';
  static const String storageError = 'Ошибка сохранения данных';
  static const String dataCorrupted = 'Данные повреждены';
  static const String permissionDenied = 'Доступ запрещен';
  static const String operationCancelled = 'Операция отменена';
  static String errorWithMessage(String message) => 'Ошибка: $message';

  // Success Messages
  static const String photoSaved = 'Фото сохранено';
  static const String profileUpdated = 'Профиль обновлен';
  static const String codeSent = 'Код отправлен';
}
