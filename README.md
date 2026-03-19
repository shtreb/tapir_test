# МЫ.ГАРМОНИЯ — Flutter MVP

> Production-ready приложение для семейной гармонии с Clean Architecture, полноценным domain слоем и production-grade обработкой ошибок.

## 🚀 Быстрый старт

```bash
# Установка зависимостей
flutter pub get

# Генерация кода (Injectable + AutoRoute)
dart run build_runner build --delete-conflicting-outputs

# Запуск приложения
flutter run

# Запуск тестов
flutter test

# Проверка кода
flutter analyze
```

---

## 📋 Обзор

### Глобальные состояния
1. **Неавторизованный:** Welcome → Login/Registration
2. **Авторизованный:** AddPhoto → Home

### Реализованные фичи
- ✅ Регистрация с онбордингом (3 слайда) и валидацией форм
- ✅ Авторизация через email + код (mock: проверка сохраненного пользователя)
- ✅ Добавление и редактирование фото (кроп 1:1) с обработкой ошибок
- ✅ Генерация и share кода пары
- ✅ Сохранение данных в `SharedPreferences` с fallback
- ✅ Восстановление сессии после перезапуска
- ✅ Обработка edge cases (отмена операций, ошибки, поврежденные данные)
- ✅ Unit-тесты для use cases и cubits (22 теста)
- ✅ ResponsiveWrapper и AppStrings на всех экранах
- ✅ Design tokens (AppSpacing, AppColors, AppTextStyles)

---

## 🛠 Технический стек

### State Management
- **flutter_bloc** (Cubit) — реактивное управление состоянием
- **equatable** — сравнение состояний

### Dependency Injection
- **injectable** — аннотации для DI с автогенерацией
- **get_it** — service locator

### Navigation
- **auto_route** — декларативная типобезопасная навигация
- AuthGuard для защиты авторизованных экранов (инъекция AuthCubit через конструктор)
- BlocConsumer для реактивной навигации на основе состояния
- PopScope для защиты от возврата назад через системный жест

### Storage
- **shared_preferences** — локальное хранилище с обработкой ошибок

### Media
- **image_picker** — выбор фото с fallback
- **image_cropper** — редактирование фото с обработкой отмены

### Utilities
- **intl** — форматирование дат
- **share_plus** — шаринг контента

---

## 🏗 Архитектура

### Clean Architecture (полная реализация)

```
lib/src/
├── domain/              # Доменный слой (бизнес-логика)
│   ├── entities/        # Доменные сущности (UserEntity)
│   ├── repositories/    # Интерфейсы репозиториев
│   └── usecases/        # Use Cases (7 шт.)
├── data/                # Слой данных
│   ├── models/          # Модели хранения (UserModel)
│   └── repositories/    # Реализации репозиториев
├── presentation/        # Слой представления
│   ├── features/        # Фичи по модулям
│   │   ├── auth/cubit/
│   │   ├── registration/cubit/
│   │   └── profile/cubit/
│   ├── screens/         # UI экраны
│   ├── widgets/         # Переиспользуемые виджеты
│   └── router/          # AutoRoute навигация
├── core/                # Общие утилиты
│   ├── constants/       # Константы приложения
│   ├── theme/           # Design tokens (spacing, colors, text)
│   ├── validators/      # Валидаторы
│   ├── errors/          # Типизированные ошибки
│   └── l10n/            # Централизованные строки
└── di/                  # Dependency Injection (Injectable)
```

### Use Cases (Domain Layer)

Каждый use case инкапсулирует одну бизнес-операцию:

- `RestoreSessionUseCase` — восстановление сессии при запуске
- `AuthorizeUserUseCase` — авторизация пользователя
- `LoginWithCredentialsUseCase` — вход по email и коду
- `LogoutUserUseCase` — выход из системы
- `SaveProfilePhotoUseCase` — сохранение фото профиля
- `VerifyRegistrationCodeUseCase` — проверка кода регистрации
- `GeneratePairCodeUseCase` — генерация кода пары

### State Management

**Feature-based Cubits:**
- `AuthCubit` — глобальное состояние авторизации (Loading/Unauthorized/Authorized)
- `RegistrationCubit` — процесс регистрации с валидацией и loading/error
- `ProfileCubit` — управление профилем (Initial/Loaded/Loading/Error)

---

## 📱 Экраны

### Неавторизованные
1. **WelcomeScreen** — стартовый экран с адаптивным layout
2. **LoginScreen** — авторизация с mock-проверкой email и кода
3. **RegistrationScreen** — многошаговая регистрация с валидацией

### Авторизованные (защищены AuthGuard + PopScope)
4. **AddPhotoScreen** — добавление фото с обработкой ошибок
5. **AuthorizedHomeScreen** — главный экран с кодом пары

---

## 🎯 Production-Grade детали

### 1. Обработка ошибок

**Типизированные Failures:**
- `StorageFailure` — ошибки SharedPreferences
- `ImagePickerFailure` / `ImageCropperFailure` — ошибки работы с фото
- `ValidationFailure` — ошибки валидации
- `CancelledFailure` — отмена операции пользователем
- `DataCorruptedFailure` — поврежденные данные
- `PermissionDeniedFailure` — нет прав доступа

**Централизованная обработка:**
```dart
try {
  await operation();
} catch (e) {
  final failure = ErrorHandler.handleException(e);
  ErrorSnackbar.showFailure(context, failure: failure);
}
```

### 2. Fallback поведение

- ❌ Пользователь отменил выбор фото → показываем InfoSnackbar
- ❌ Данные в SharedPreferences повреждены → очищаем и возвращаем null
- ❌ Ошибка сохранения → показываем ошибку с кнопкой "Повторить"
- ❌ Ошибка image_picker → показываем понятное сообщение

### 3. Design Tokens

**AppSpacing** — система отступов:
```dart
AppSpacing.verticalMd      // SizedBox(height: 16)
AppSpacing.paddingLg        // EdgeInsets.all(24)
AppSpacing.radiusMd         // BorderRadius.circular(12)
```

**8px grid system:** xs(4), sm(8), md(16), lg(24), xl(32), xxl(48), xxxl(64)

**Статус:** Применен на всех ключевых экранах (Welcome, Login, Registration, AddPhoto, AuthorizedHome).

### 4. Централизованные строки

**AppStrings** — централизация текста:
- Все строки определены в AppStrings
- Готово к локализации (методы с параметрами)
- Группировка по экранам

**Статус:** Применен на всех ключевых экранах (Welcome, Login, Registration, AddPhoto, AuthorizedHome).

### 5. Адаптивность

**ResponsiveContext extension:**
```dart
context.isMobile / isTablet / isDesktop
context.responsive<T>(mobile: ..., tablet: ..., desktop: ...)
```

**Breakpoints:** 600px (mobile), 900px (tablet), 1200px (desktop)

**Статус:** ResponsiveWrapper применен на всех экранах. Инфраструктура готова для дальнейшей адаптации под планшеты и десктоп.

### 6. Профессиональные Snackbars

- `ErrorSnackbar` — красный, с иконкой ошибки, опциональная кнопка "Повторить"
- `SuccessSnackbar` — зеленый, с иконкой галочки
- `InfoSnackbar` — синий, с иконкой информации

### 7. Unit-тестирование

**Покрытие тестами (22 теста):**
- ✅ Use Cases: `RestoreSessionUseCase`, `LoginWithCredentialsUseCase`
- ✅ Cubits: `AuthCubit`, `RegistrationCubit`, `ProfileCubit`
- ✅ Используются `mocktail` для моков и `bloc_test` для тестирования состояний

**Примеры тестов:**
```dart
blocTest<AuthCubit, AuthState>(
  'bootstrap должен emit Unauthorized если нет сохраненного пользователя',
  build: () => AuthCubit(...),
  expect: () => [Unauthorized()],
);
```

**Запуск:**
```bash
flutter test
```

---

## 🤔 Инженерные решения и Trade-offs

### Почему Cubit, а не полноценный BLoC?

**Выбор:** Cubit (упрощенная версия BLoC)

**Причины:**
- ✅ Меньше boilerplate кода (нет отдельных событий)
- ✅ Проще для понимания и поддержки
- ✅ Достаточно для MVP без сложной бизнес-логики
- ✅ Легко мигрировать на полный BLoC при необходимости

**Trade-off:** Теряем явное разделение событий и состояний, но для данного проекта это оправдано.

### Почему AutoRoute?

**Выбор:** AutoRoute с аннотациями

**Причины:**
- ✅ Типобезопасная навигация (compile-time проверки)
- ✅ Декларативный подход (роуты как конфигурация)
- ✅ Автогенерация кода (меньше ошибок)
- ✅ Guards для защиты экранов на уровне роутера
- ✅ Интеграция с BLoC для реактивной навигации

**Trade-off:** Зависимость от code generation, но это стандарт в Flutter ecosystem.

**Реализация Guard:** AuthGuard получает AuthCubit через конструктор (инъекция в AppRouter) и проверяет его состояние напрямую, без BuildContext. Это обеспечивает защиту от прямой навигации, deep links и ручных push в стек, избегая race conditions с SharedPreferences.

### Почему SharedPreferences?

**Выбор:** SharedPreferences для локального хранения

**Причины:**
- ✅ Простота для MVP
- ✅ Нативная поддержка платформ
- ✅ Достаточно для небольших данных
- ✅ Синхронное чтение (быстрый старт приложения)

**Trade-off:** Не подходит для больших объемов данных. Для production:
- Миграция на Hive/Isar для структурированных данных
- Secure Storage для чувствительных данных
- SQLite для сложных запросов

### Почему Injectable?

**Выбор:** Injectable + GetIt

**Причины:**
- ✅ Автогенерация DI кода
- ✅ Типобезопасность
- ✅ Удобные аннотации (@injectable, @lazySingleton)
- ✅ Модульность (легко добавлять зависимости)

**Trade-off:** Зависимость от code generation, но это упрощает поддержку.

### Что сознательно не делалось

**Из-за рамок тестового задания:**

1. **Тесты** — реализованы базовые unit-тесты:
   - ✅ Use cases (RestoreSession, LoginWithCredentials)
   - ✅ Cubits (AuthCubit, RegistrationCubit, ProfileCubit)
   - ✅ Используются mocktail + bloc_test
   - ❌ Widget тесты и integration тесты не реализованы

2. **Реальный backend** — только mock-логика:
   - Логин проверяет email и код из сохраненного пользователя (mock)
   - Регистрационный код проверяется только на формат (6 символов, валидные chars)
   - Нет реальной отправки email
   - Генерация кода случайная

3. **Продвинутая локализация** — базовая подготовка:
   - Строки централизованы в AppStrings
   - Готовы методы с параметрами
   - Легко мигрировать на flutter_localizations

4. **Сложная валидация** — базовые проверки:
   - Email через regex
   - Возраст через DateTime
   - Код через формат (6 символов)

5. **Аналитика и мониторинг** — не добавлены:
   - Firebase Analytics
   - Crashlytics
   - Performance monitoring

6. **CI/CD** — не настроен:
   - GitHub Actions
   - Автоматические тесты
   - Deploy pipeline

---

## 🎨 Дизайн

[Figma макеты](https://www.figma.com/design/EkCRfdeUInsmqBRYL36kT5/APP--%D0%A1%D0%B5%D0%BC%D1%8C%D1%8F?node-id=1-1925&t=HedTE3rS08hZ4lL7-0)

---

## ✅ Реализовано

### Архитектура
- [x] Clean Architecture с полным domain слоем
- [x] Разделение на entities/usecases/repositories
- [x] Feature-based структура Cubits
- [x] Отделение моделей хранения от доменных

### DI и Навигация
- [x] Injectable с автогенерацией
- [x] AutoRoute с Guards (проверка через AuthCubit)
- [x] Типобезопасная навигация
- [x] Защита от прямой навигации и deep links

### Production-Grade (инфраструктура)
- [x] Обработка ошибок (SharedPreferences, image_picker, image_cropper)
- [x] Fallback для отмены операций и поврежденных данных
- [x] Централизованные строки (AppStrings применен на всех ключевых экранах)
- [x] Design tokens (AppSpacing применен на всех ключевых экранах)
- [x] Адаптивность (ResponsiveWrapper применен на всех экранах)
- [x] Профессиональные snackbars с retry
- [x] Unit-тесты для use cases и cubits (22 теста)

### UI/UX
- [x] Переиспользуемые компоненты
- [x] Кастомная тема (Material 3)
- [x] Валидаторы для форм
- [x] Loading состояния
- [x] Диалог разлогина при попытке вернуться назад

---

## 📝 Примечания

- Все данные хранятся локально в `SharedPreferences`
- Нет реального backend, только mock-логика с задержками
- Код пары генерируется случайно при регистрации
- Фото сохраняется локально после кропа
- Приложение работает полностью offline
- Архитектура готова к добавлению backend (достаточно реализовать IAuthRepository)

---

## 🎯 Для ревьюеров

### Что оценить

1. **Архитектура:**
   - Чистота слоев (domain/data/presentation)
   - Правильное использование Clean Architecture
   - Разделение ответственности
   - 7 use cases, отделение entities от models

2. **State Management:**
   - Корректное использование Cubit
   - Обработка loading/error состояний
   - Реактивность UI
   - BlocConsumer для глобальной навигации

3. **Code Quality:**
   - Читаемость и поддерживаемость
   - Обработка edge cases
   - Типобезопасность
   - Unit-тесты (22 теста с mocktail + bloc_test)

4. **Production Readiness:**
   - Обработка ошибок с типизированными Failures
   - Fallback поведение для всех async операций
   - AppStrings и AppSpacing применены на ключевых экранах
   - ResponsiveWrapper для адаптивности

5. **Инженерное мышление:**
   - Обоснование выбора технологий
   - Понимание trade-offs
   - Документирование решений
   - AuthGuard без BuildContext (инъекция через конструктор)

---

## 📞 Структура проекта

```
tapir_test/
├── lib/
│   └── src/
│       ├── domain/           # Бизнес-логика (entities, usecases, interfaces)
│       ├── data/             # Реализация хранения (models, repositories)
│       ├── presentation/     # UI (features, screens, widgets, router)
│       ├── core/             # Утилиты (theme, validators, errors, l10n)
│       └── di/               # Dependency Injection (Injectable)
├── test/                     # Unit-тесты (22 теста)
│   ├── domain/usecases/      # Тесты use cases
│   └── presentation/features/ # Тесты cubits
└── README.md                 # Этот файл
```
