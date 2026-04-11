import 'package:go_router/go_router.dart';

import '../screens/onboarding_screen.dart';

class OnboardingRoutes {
  static const String path = '/';
  static const String name = 'onboarding';

  static final GoRoute route = GoRoute(
    path: path,
    name: name,
    builder: (context, state) => const OnboardingScreen(),
  );
}
