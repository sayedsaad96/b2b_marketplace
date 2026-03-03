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
  static const String factorySearch = '/brand/factory-search';
  static const String factoryProfile = '/brand/factory-profile';
  static const String rfqForm = '/brand/rfq-form';
  static const String myRfqs = '/brand/my-rfqs';
  static const String factoryHome = '/factory/home';
  static const String factoryDashboard = '/factory/dashboard';
  static const String adminDashboard = '/admin/dashboard';
  static const String myProfile = '/factory/my-profile';
  static const String rfqInbox = '/factory/inbox';
  static const String activeOrders = '/factory/orders';
  static const String submitQuote = '/factory/rfq-quote';
  static const String chat = '/chat';
}
