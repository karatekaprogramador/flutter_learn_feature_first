import 'package:go_router/go_router.dart';

import 'package:flutter_learn_feature_first/features/auth/auth.dart';
import 'package:flutter_learn_feature_first/features/home/home.dart';
import 'package:flutter_learn_feature_first/features/onboarding/onboarding.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: OnboardingRoutes.path,
    routes: [
      OnboardingRoutes.route,
      AuthRoutes.loginRoute,
      HomeRoutes.dashboardRoute,
    ],
  );
}
