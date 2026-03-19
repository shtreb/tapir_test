import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tapir_test/src/core/theme/app_theme.dart';
import 'package:tapir_test/src/di/injection.dart';
import 'package:tapir_test/src/presentation/features/auth/cubit/auth_cubit.dart';
import 'package:tapir_test/src/presentation/features/profile/cubit/profile_cubit.dart';
import 'package:tapir_test/src/presentation/router/app_router.dart';

class HarmonyApp extends StatefulWidget {
  const HarmonyApp({super.key});

  @override
  State<HarmonyApp> createState() => _HarmonyAppState();
}

class _HarmonyAppState extends State<HarmonyApp> {
  late final AuthCubit _authCubit;
  late final AppRouter _appRouter;

  @override
  void initState() {
    super.initState();
    _authCubit = di<AuthCubit>();
    _appRouter = AppRouter(authCubit: _authCubit);
  }

  @override
  void dispose() {
    _authCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: <BlocProvider<dynamic>>[
        BlocProvider<AuthCubit>.value(value: _authCubit),
        BlocProvider<ProfileCubit>(create: (_) => di<ProfileCubit>()),
      ],
      child: BlocConsumer<AuthCubit, AuthState>(
        listener: (BuildContext context, AuthState state) {
          if (state is Authorized) {
            final user = state.user;
            context.read<ProfileCubit>().setUser(user);

            if ((user.photoPath ?? '').isEmpty) {
              _appRouter.replaceAll(<PageRouteInfo>[const AddPhotoRoute()]);
            } else {
              _appRouter.replaceAll(<PageRouteInfo>[const AuthorizedHomeRoute()]);
            }
          } else if (state is Unauthorized) {
            _appRouter.replaceAll(<PageRouteInfo>[const WelcomeRoute()]);
          }
        },
        builder: (BuildContext context, AuthState state) {
          if (state is AuthLoading) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: AppTheme.light,
              home: const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              ),
            );
          }

          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'МЫ.ГАРМОНИЯ',
            theme: AppTheme.light,
            routerConfig: _appRouter.config(),
          );
        },
      ),
    );
  }
}

