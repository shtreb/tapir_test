import 'package:auto_route/auto_route.dart';
import 'package:tapir_test/src/presentation/features/auth/cubit/auth_cubit.dart';
import 'package:tapir_test/src/presentation/router/auth_guard.dart';
import 'package:tapir_test/src/presentation/screens/auth/login_screen.dart';
import 'package:tapir_test/src/presentation/screens/home/authorized_home_screen.dart';
import 'package:tapir_test/src/presentation/screens/photo/add_photo_screen.dart';
import 'package:tapir_test/src/presentation/screens/registration/registration_screen.dart';
import 'package:tapir_test/src/presentation/screens/welcome/welcome_screen.dart';

part 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  AppRouter({required AuthCubit authCubit}) : _authGuard = AuthGuard(authCubit);

  final AuthGuard _authGuard;

  @override
  List<AutoRoute> get routes => <AutoRoute>[
        AutoRoute(page: WelcomeRoute.page, initial: true),
        AutoRoute(page: LoginRoute.page),
        AutoRoute(page: RegistrationRoute.page),
        AutoRoute(page: AddPhotoRoute.page, guards: <AutoRouteGuard>[_authGuard]),
        AutoRoute(page: AuthorizedHomeRoute.page, guards: <AutoRouteGuard>[_authGuard]),
      ];
}
