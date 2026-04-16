import 'package:go_router/go_router.dart';

import 'package:flutter_learn_feature_first/features/auth/auth.dart';
import 'package:flutter_learn_feature_first/features/home/home.dart';
import 'package:flutter_learn_feature_first/features/onboarding/onboarding.dart';
import 'package:flutter_learn_feature_first/features/todos/todos.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: OnboardingRoutes.path,
    redirect: (context, state) {
      final location = state.uri.toString();
      // Si recibimos el enlace profundo crudo con el scheme, lo podamos a una ruta relativa de GoRouter
      if (location.startsWith('karateka.todo://auth/callback')) {
        final query = state.uri.hasQuery ? '?${state.uri.query}' : '';
        final fragment = state.uri.hasFragment ? '#${state.uri.fragment}' : '';
        return '${AuthRoutes.callbackPath}$query$fragment';
      }
      return null;
    },
    routes: [
      OnboardingRoutes.route,
      AuthRoutes.loginRoute,
      AuthRoutes.callbackRoute,
      HomeRoutes.dashboardRoute,
      TodosRoutes.addTodoRoute,
    ],
  );
}
