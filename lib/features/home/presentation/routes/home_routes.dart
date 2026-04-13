import 'package:go_router/go_router.dart';

import '../screens/home_dashboard_screen.dart';

class HomeRoutes {
  static const String dashboardPath = '/home-dashboard';
  static const String dashboardName = 'home-dashboard';

  static final GoRoute dashboardRoute = GoRoute(
    path: dashboardPath,
    name: dashboardName,
    builder: (context, state) => const HomeDashboardScreen(),
  );
}
