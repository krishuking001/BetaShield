import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/config/app_config.dart';
import '../core/storage/app_prefs.dart';
import '../features/guardian/presentation/guardian_extra_screens.dart';
import '../features/guardian/presentation/guardian_screens.dart';
import '../features/guardian/presentation/guardian_setup_screens.dart';
import '../features/intervention/presentation/intervention_screens.dart';
import '../features/lab/lab_screen.dart';
import '../features/protected/presentation/protected_screens.dart';
import 'providers.dart';

/// Central navigation. The single `redirect` keeps each phone inside its own
/// mode: a protected phone can never reach guardian screens (and their ads),
/// and vice-versa. Pairing deep links (`betashield://pair?code=…`) land on the
/// guardian pairing screen.
final routerProvider = Provider<GoRouter>((ref) {
  final refresh = ValueNotifier<int>(0);
  ref.listen(appModeProvider, (_, _) => refresh.value++);
  ref.listen(permissionsIntroDoneProvider, (_, _) => refresh.value++);
  ref.listen(familyLinkProvider, (_, _) => refresh.value++);
  ref.listen(guardianProfileProvider, (_, _) => refresh.value++);
  ref.onDispose(refresh.dispose);

  String? redirect(BuildContext context, GoRouterState state) {
    final uri = state.uri;

    // Pairing deep link: betashield://pair?code=BETA-7Q4K or https://…/pair?code=…
    final isPairLink =
        (uri.scheme == AppConfig.deepLinkScheme && uri.host == 'pair') ||
        uri.path == '/pair';
    if (isPairLink) {
      final code = uri.queryParameters['code'];
      return '/guardian/pair${code == null ? '' : '?code=${Uri.encodeQueryComponent(code)}'}';
    }

    final path = uri.path;
    if (path == '/lab' && (AppConfig.useDemoBackend)) return null;

    final mode = ref.read(appModeProvider);
    if (mode == null) return path == '/mode' ? null : '/mode';

    if (mode == AppMode.guardian) {
      if (!path.startsWith('/guardian')) return '/guardian/home';
      if (ref.read(guardianProfileProvider) == null &&
          path != '/guardian/setup') {
        return '/guardian/setup';
      }
      return null;
    }

    // Protected mode
    if (!path.startsWith('/protected')) {
      if (!ref.read(permissionsIntroDoneProvider)) {
        return '/protected/permissions';
      }
      if (ref.read(familyLinkProvider) == null) return '/protected/pairing';
      return '/protected/home';
    }
    return null;
  }

  return GoRouter(
    initialLocation: '/',
    refreshListenable: refresh,
    redirect: redirect,
    routes: [
      GoRoute(path: '/', builder: (_, _) => const Scaffold()),
      GoRoute(path: '/mode', builder: (_, _) => const ModeScreen()),
      GoRoute(path: '/lab', builder: (_, _) => const LabScreen()),

      // Protected mode
      GoRoute(
        path: '/protected/permissions',
        builder: (_, _) => const PermissionsScreen(),
      ),
      GoRoute(
        path: '/protected/pairing',
        builder: (_, _) => const ParentPairingScreen(),
      ),
      GoRoute(
        path: '/protected/home',
        builder: (_, _) => const ProtectedHomeScreen(),
      ),
      GoRoute(
        path: '/protected/check-message',
        builder: (_, _) => const CheckMessageScreen(),
      ),
      GoRoute(
        path: '/protected/live-call',
        builder: (_, _) => const LiveCallWarningScreen(),
      ),
      GoRoute(
        path: '/protected/intervention',
        builder: (_, _) => const InterventionScreen(),
      ),
      GoRoute(
        path: '/protected/resolved',
        builder: (_, _) => const ResolvedScreen(),
      ),

      // Guardian mode
      GoRoute(
        path: '/guardian/setup',
        builder: (_, _) => const GuardianSetupScreen(),
      ),
      GoRoute(
        path: '/guardian/profile',
        builder: (_, _) => const GuardianSetupScreen(editing: true),
      ),
      GoRoute(
        path: '/guardian/home',
        builder: (_, _) => const GuardianDashboardScreen(),
      ),
      GoRoute(
        path: '/guardian/pair',
        builder: (_, s) =>
            GuardianPairScreen(initialCode: s.uri.queryParameters['code']),
      ),
      GoRoute(
        path: '/guardian/pair/confirm',
        builder: (_, s) =>
            GuardianConfirmScreen(code: s.uri.queryParameters['code'] ?? ''),
      ),
      GoRoute(
        path: '/guardian/event/:id',
        builder: (_, s) => RiskTimelineScreen(eventId: s.pathParameters['id']!),
      ),
      GoRoute(
        path: '/guardian/alert/:id',
        builder: (_, s) => LockAlertScreen(eventId: s.pathParameters['id']!),
      ),
      GoRoute(
        path: '/guardian/report',
        builder: (_, s) =>
            WeeklyReportScreen(parentId: s.uri.queryParameters['parent']),
      ),
      GoRoute(
        path: '/guardian/plan',
        builder: (_, _) => const FamilyPlanScreen(),
      ),
      GoRoute(
        path: '/guardian/learn',
        builder: (_, _) => const ScamGuideScreen(),
      ),
      GoRoute(
        path: '/guardian/settings',
        builder: (_, _) => const GuardianSettingsScreen(),
      ),
    ],
  );
});
