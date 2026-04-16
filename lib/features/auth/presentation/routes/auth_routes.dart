import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../cubit/auth_cubit.dart';
import '../../../../core/di/injector.dart';

import '../screens/auth_callback_screen.dart';
import '../screens/login_screen.dart';

class AuthRoutes {
  static const String loginPath = '/login';
  static const String loginName = 'login';
  
  static const String callbackPath = '/auth/callback';
  static const String callbackName = 'authCallback';

  static final GoRoute loginRoute = GoRoute(
    path: loginPath,
    name: loginName,
    builder: (context, state) => const LoginScreen(),
  );

  static final GoRoute callbackRoute = GoRoute(
    path: callbackPath,
    name: callbackName,
    builder: (context, state) {
      final queryParams = state.uri.queryParameters;
      final error = queryParams['error'];
      final errorDescription = queryParams['error_description'];

      String? token = queryParams['access_token'];
      if (token == null && state.uri.hasFragment) {
        final fragmentArgs = Uri.splitQueryString(state.uri.fragment);
        token = fragmentArgs['access_token'];
      }

      // InsForge usa 'insforge_code' como parámetro del código OAuth
      String? code = queryParams['insforge_code'] ?? queryParams['code'];
      if (code == null && state.uri.hasFragment) {
        final fragmentArgs = Uri.splitQueryString(state.uri.fragment);
        code = fragmentArgs['insforge_code'] ?? fragmentArgs['code'];
      }

      if (token != null && error == null) {
        Future.microtask(
            () => injector<AuthCubit>().setAccessToken(token!));
      } else if (code != null && error == null) {
        Future.microtask(
            () => injector<AuthCubit>().exchangeOAuthCode(code!));
      }

      return BlocProvider.value(
        value: injector<AuthCubit>(),
        child: AuthCallbackScreen(
          error: error,
          errorDescription: errorDescription,
          rawUri: state.uri.toString(),
        ),
      );
    },
  );
}
