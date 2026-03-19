class AppConstants {
  static const String userProfileKey = 'user_profile';
  static const String onboardingCompletedKey = 'onboarding_completed';
  static const String partnerCodeKey = 'partner_code';

  static const int minAge = 18;
  static const int minNameLength = 2;
  static const int codeLength = 6;

  static String shareCodeMessage(String code) {
    return 'Хочу быть с тобой в гармонии каждый день. '
        'Скачай приложение "МЫ.ГАРМОНИЯ" и введи наш код пары $code';
  }

  static const List<Map<String, String>> onboardingSlides = <Map<String, String>>[
    <String, String>{
      'title': 'Слайд1',
      'description': 'Приложение для семейной гармонии',
    },
    <String, String>{
      'title': 'Слайд2',
      'description': 'Делитесь моментами с любимыми',
    },
    <String, String>{
      'title': 'Слайд3',
      'description': 'Создайте профиль и пригласите партнера',
    },
  ];
}
