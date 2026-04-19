import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/auth/presentation/auth_provider.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../features/hosteller/presentation/screens/hosteller_list_screen.dart';
import '../../features/hosteller/presentation/screens/add_hosteller_screen.dart';
import '../../features/hosteller/presentation/screens/hosteller_details_screen.dart';
import '../../features/payments/presentation/screens/payment_entry_screen.dart';
import '../../features/payments/presentation/screens/pending_dues_screen.dart';
import '../../features/notifications/presentation/screens/notifications_screen.dart';
import '../../features/hosteller/domain/hosteller_model.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: '/login',
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/',
        redirect: (context, state) => '/dashboard',
      ),
      GoRoute(
        path: '/dashboard',
        builder: (context, state) => const DashboardScreen(),
        routes: [
          GoRoute(
            path: 'notifications',
            builder: (context, state) => const NotificationsScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/hostellers',
        builder: (context, state) {
          final selectForPayment = state.uri.queryParameters['selectForPayment'] == 'true';
          return HostellerListScreen(selectForPayment: selectForPayment);
        },
        routes: [
          GoRoute(
            path: 'add',
            builder: (context, state) => const AddHostellerScreen(),
          ),
          GoRoute(
            path: 'details',
            builder: (context, state) {
              final hosteller = state.extra as Hosteller;
              return HostellerDetailsScreen(hosteller: hosteller);
            },
          ),
        ],
      ),
      GoRoute(
        path: '/payments',
        builder: (context, state) => const PendingDuesScreen(),
        routes: [
          GoRoute(
            path: 'entry',
            builder: (context, state) {
              final hosteller = state.extra as Hosteller;
              return PaymentEntryScreen(hosteller: hosteller);
            },
          ),
        ],
      ),
    ],
    redirect: (context, state) {
      final isLoggedIn = authState.isAuthenticated;
      final isLoggingIn = state.matchedLocation == '/login';

      if (!isLoggedIn && !isLoggingIn) return '/login';
      if (isLoggedIn && isLoggingIn) return '/dashboard';

      return null;
    },
  );
});
