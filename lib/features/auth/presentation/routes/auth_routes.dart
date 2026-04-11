import 'package:go_router/go_router.dart';

import '../screens/login_screen.dart';

class AuthRoutes {
  static const String loginPath = '/login';
  static const String loginName = 'login';

  static final GoRoute loginRoute = GoRoute(
    path: loginPath,
    name: loginName,
    builder: (context, state) => const LoginScreen(),
  );
}
