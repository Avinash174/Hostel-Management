import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hostel_managemet/features/auth/presentation/auth_provider.dart';
import 'package:hostel_managemet/features/auth/presentation/screens/splash_screen.dart';
import 'package:hostel_managemet/features/auth/presentation/screens/onboarding_screen.dart';
import 'package:hostel_managemet/features/auth/presentation/screens/hostel_selection_screen.dart';
import 'package:hostel_managemet/features/auth/presentation/screens/welcome_screen.dart';
import 'package:hostel_managemet/features/auth/presentation/screens/login_screen.dart';
import 'package:hostel_managemet/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:hostel_managemet/features/dashboard/presentation/screens/resident_home_screen.dart';
import 'package:hostel_managemet/features/hosteller/presentation/screens/hostel_details_screen.dart';
import 'package:hostel_managemet/features/hosteller/presentation/screens/hosteller_list_screen.dart';
import 'package:hostel_managemet/features/hosteller/presentation/screens/add_hosteller_screen.dart';
import 'package:hostel_managemet/features/hosteller/presentation/screens/hosteller_details_screen.dart' as admin;
import 'package:hostel_managemet/features/payments/presentation/screens/payment_entry_screen.dart';
import 'package:hostel_managemet/features/payments/presentation/screens/pending_dues_screen.dart';
import 'package:hostel_managemet/features/notifications/presentation/screens/notifications_screen.dart';
import 'package:hostel_managemet/features/hosteller/domain/hosteller_model.dart';
import 'package:hostel_managemet/features/complaints/presentation/screens/complaint_list_screen.dart';
import 'package:hostel_managemet/features/complaints/presentation/screens/post_complaint_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/hostels',
        builder: (context, state) => const HostelSelectionScreen(),
      ),
      GoRoute(
        path: '/hostel-details',
        builder: (context, state) => const HostelDetailsScreen(),
      ),
      GoRoute(
        path: '/welcome',
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/resident-home',
        builder: (context, state) => const ResidentHomeScreen(),
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
              return admin.HostellerDetailsScreen(hosteller: hosteller);
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
      GoRoute(
        path: '/complaints',
        builder: (context, state) => const ComplaintListScreen(),
        routes: [
          GoRoute(
            path: 'post',
            builder: (context, state) => const PostComplaintScreen(),
          ),
        ],
      ),
    ],
    redirect: (context, state) {
      final isLoggedIn = authState.isAuthenticated;
      final location = state.matchedLocation;
      
      final authFlowRoutes = ['/', '/onboarding', '/hostels', '/hostel-details', '/welcome', '/login', '/resident-home'];
      final isAuthFlow = authFlowRoutes.contains(location);

      if (isLoggedIn && location == '/login') {
        return '/dashboard';
      }

      if (!isLoggedIn && !isAuthFlow) {
        return '/onboarding';
      }

      return null;
    },
  );
});
