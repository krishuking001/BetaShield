import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/design/theme.dart';
import '../core/l10n/l10n.dart';
import '../core/services/analytics_service.dart';
import '../core/services/notification_service.dart';
import '../core/services/push_handler.dart';
import '../core/storage/app_prefs.dart';
import '../core/utils/dialer.dart';
import '../data/remote_backend.dart';
import '../features/guardian/application/guardian_controllers.dart';
import '../features/guardian/presentation/guardian_screens.dart'
    show launchedFromAlertProvider;
import '../features/risk/application/risk_session.dart';
import 'providers.dart';
import 'router.dart';

class BetaShieldApp extends ConsumerWidget {
  const BetaShieldApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(appModeProvider);
    final guardianLocale = ref.watch(guardianLocaleProvider);
    final protectedLocale = ref.watch(protectedLocaleProvider);
    final parentL10n = ref.watch(parentL10nProvider);
    final router = ref.watch(routerProvider);

    // Protected phones show a primary language (English by default, picked
    // in the "..." menu) with English underneath in the UI itself unless
    // that would repeat the same text twice; guardians choose their own
    // single language, English by default.
    final locale = mode == AppMode.guardian ? guardianLocale : protectedLocale;

    return _AppRuntime(
      child: ParentL10nScope(
        value: parentL10n,
        child: MaterialApp.router(
          title: 'Beta Shield',
          debugShowCheckedModeBanner: false,
          theme: buildTheme(),
          locale: locale,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          routerConfig: router,
          builder: (context, child) => MediaQuery.withClampedTextScaling(
            // Respect the user's font size, but keep layouts from breaking.
            minScaleFactor: 1.0,
            maxScaleFactor: 1.6,
            child: child ?? const SizedBox.shrink(),
          ),
        ),
      ),
    );
  }
}

/// Wires the things that live for the whole app: native route requests,
/// notification taps, FCM, connectivity-driven uploads, and screen changes
/// that follow a call ending.
class _AppRuntime extends ConsumerStatefulWidget {
  const _AppRuntime({required this.child});

  final Widget child;

  @override
  ConsumerState<_AppRuntime> createState() => _AppRuntimeState();
}

class _AppRuntimeState extends ConsumerState<_AppRuntime> {
  final _subs = <StreamSubscription<dynamic>>[];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _init());
  }

  @override
  void dispose() {
    for (final s in _subs) {
      s.cancel();
    }
    super.dispose();
  }

  Future<void> _init() async {
    final router = ref.read(routerProvider);
    final native = ref.read(nativeBridgeProvider);
    final notifications = ref.read(notificationServiceProvider);

    // Routes requested by native (full-screen intent for an intervention).
    _subs.add(native.routeRequests.listen((r) => router.go(r)));
    final launchRoute = await native.takeLaunchRoute();
    if (launchRoute != null) router.go(launchRoute);

    await notifications.init(onTap: _onNotificationTap);
    final launchTap = await notifications.launchTap();
    if (launchTap != null &&
        launchTap.route == null &&
        launchTap.eventId != null) {
      ref.read(launchedFromAlertProvider.notifier).state = true;
      router.go('/guardian/alert/${launchTap.eventId}');
    }

    if (ref.read(firebaseReadyProvider)) _wireFcm();
  }

  void _wireFcm() {
    final handler = PushHandler(
      notifications: ref.read(notificationServiceProvider),
      speech: ref.read(speechProvider),
      prefs: ref.read(appPrefsProvider),
    );
    _subs.add(
      FirebaseMessaging.onMessage.listen((m) async {
        await handler.handle(m.data);
        if (ref.read(appModeProvider) == AppMode.guardian) {
          ref.read(dashboardProvider.notifier).refresh(silent: true);
        }
        final type = m.data['type'];
        if (type == 'risk_alert') {
          await ref
              .read(analyticsProvider)
              .log(AnalyticsEvents.riskAlertReceived);
        }
      }),
    );
    _subs.add(
      FirebaseMessaging.instance.onTokenRefresh.listen((t) async {
        final backend = ref.read(backendProvider);
        if (backend is! RemoteBackend) return;
        try {
          await backend.updateFcmToken(t);
        } catch (_) {}
      }),
    );
    FirebaseMessaging.instance.requestPermission();
  }

  Future<void> _onNotificationTap(NotificationTap tap) async {
    final router = ref.read(routerProvider);
    if (tap.actionId == NotificationService.actionCall) {
      final phone = tap.phone;
      if (phone != null && phone.isNotEmpty) {
        await ref.read(dialerProvider)(phone);
      }
      return;
    }
    ref.read(launchedFromAlertProvider.notifier).state = true;
    if (tap.route != null) {
      router.go(tap.route!);
    } else if (tap.eventId != null && tap.eventId!.isNotEmpty) {
      router.go('/guardian/event/${tap.eventId}');
    }
  }

  @override
  Widget build(BuildContext context) {
    // When a call ends, follow it: to "money safe" after an intervention, or
    // back home if only a warning was showing.
    final protected = ref.watch(appModeProvider) == AppMode.protected;
    if (protected) {
      ref.listen<RiskSessionState>(riskSessionProvider, _followCall);
    }
    return widget.child;
  }

  void _followCall(RiskSessionState? prev, RiskSessionState next) {
    {
      if (prev?.call != null && next.call == null) {
        final router = ref.read(routerProvider);
        final path = router.routeInformationProvider.value.uri.path;
        if (next.resolved != null) {
          router.go('/protected/resolved');
        } else if (path == '/protected/live-call' ||
            path == '/protected/intervention') {
          router.go('/protected/home');
        }
      }
    }
  }
}
