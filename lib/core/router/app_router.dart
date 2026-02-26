import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../features/admin/presentation/pages/admin_dashboard_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/sign_up_page.dart';
import '../../features/brand/presentation/pages/brand_home_page.dart';
import '../../features/factory/presentation/pages/factory_home_page.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../../features/role_selection/presentation/pages/role_selection_page.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
import '../constants/app_routes.dart';

/// Centralized GoRouter configuration.
class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: true,
    redirect: _guardRedirect,
    routes: [
      // ── Public routes ──
      GoRoute(
        path: AppRoutes.splash,
        name: 'splash',
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        name: 'onboarding',
        builder: (context, state) => const OnboardingPage(),
      ),
      GoRoute(
        path: AppRoutes.roleSelection,
        name: 'roleSelection',
        builder: (context, state) => const RoleSelectionPage(),
      ),

      // ── Auth routes ──
      GoRoute(
        path: AppRoutes.login,
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: AppRoutes.signUp,
        name: 'signUp',
        builder: (context, state) {
          final role = state.extra as String? ?? 'brand';
          return SignUpPage(role: role);
        },
      ),

      // ── Role-based home routes ──
      GoRoute(
        path: AppRoutes.brandHome,
        name: 'brandHome',
        builder: (context, state) => const BrandHomePage(),
      ),
      GoRoute(
        path: AppRoutes.factoryHome,
        name: 'factoryHome',
        builder: (context, state) => const FactoryHomePage(),
      ),
      GoRoute(
        path: AppRoutes.adminDashboard,
        name: 'adminDashboard',
        builder: (context, state) => const AdminDashboardPage(),
      ),
    ],
    errorBuilder: (context, state) =>
        Scaffold(body: Center(child: Text('Page not found: ${state.error}'))),
  );

  /// Route guard: redirect unauthenticated users trying
  /// to access protected routes back to login.
  static String? _guardRedirect(BuildContext context, GoRouterState state) {
    final session = Supabase.instance.client.auth.currentSession;
    final isLoggedIn = session != null;

    final isAuthRoute =
        state.matchedLocation == AppRoutes.login ||
        state.matchedLocation == AppRoutes.signUp;
    final isPublicRoute =
        state.matchedLocation == AppRoutes.splash ||
        state.matchedLocation == AppRoutes.onboarding ||
        state.matchedLocation == AppRoutes.roleSelection;

    // Allow public routes always
    if (isPublicRoute) return null;

    // Not logged in and trying to access protected route
    if (!isLoggedIn && !isAuthRoute) {
      return AppRoutes.login;
    }

    return null;
  }
}
