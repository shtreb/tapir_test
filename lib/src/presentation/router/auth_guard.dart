import 'package:auto_route/auto_route.dart';
import 'package:tapir_test/src/presentation/features/auth/cubit/auth_cubit.dart';
import 'package:tapir_test/src/presentation/router/app_router.dart';

/// Guard для защиты авторизованных экранов
/// Использует состояние AuthCubit вместо прямой проверки SharedPreferences
/// для избежания race conditions
class AuthGuard extends AutoRouteGuard {
  AuthGuard(this._authCubit);

  final AuthCubit _authCubit;

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    // Проверяем состояние AuthCubit напрямую, без BuildContext
    final authState = _authCubit.state;
    
    if (authState is Authorized) {
      // Пользователь авторизован - разрешаем навигацию
      resolver.next();
    } else {
      // Пользователь не авторизован - блокируем и редиректим
      resolver.next(false);
      router.replaceAll(<PageRouteInfo>[const WelcomeRoute()]);
    }
  }
}
