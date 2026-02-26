/// Route path constants for GoRouter.
class AppRoutes {
  AppRoutes._();

  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String roleSelection = '/role-selection';

  // Auth
  static const String login = '/auth/login';
  static const String signUp = '/auth/signup';

  // Role-based home screens
  static const String brandHome = '/brand/home';
  static const String factoryHome = '/factory/home';
  static const String adminDashboard = '/admin/dashboard';
}
