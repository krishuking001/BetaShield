import 'dart:typed_data';
import 'dart:ui';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/config/app_config.dart';
import '../core/l10n/l10n.dart';
import '../core/network/dio_factory.dart';
import '../core/services/analytics_service.dart';
import '../core/services/native_bridge.dart';
import '../core/services/notification_service.dart';
import '../core/services/speech_service.dart';
import '../core/storage/app_prefs.dart';
import '../core/storage/local_db.dart';
import '../core/storage/outbox.dart';
import '../core/storage/secure_store.dart';
import '../data/backend_gateway.dart';
import '../data/demo_backend.dart';
import '../data/remote_backend.dart';
import '../features/pairing/domain/pairing_models.dart';

// --- infrastructure (overridden in main / tests) ------------------------------------------

final appPrefsProvider = Provider<AppPrefs>(
  (_) => throw UnimplementedError('appPrefsProvider must be overridden'),
);
final localDbProvider = Provider<LocalDb>(
  (_) => throw UnimplementedError('localDbProvider must be overridden'),
);
final secureStoreProvider = Provider<SecureStore>((_) => FlutterSecureStore());
final pinnedRootsProvider = Provider<List<Uint8List>>((_) => const []);
final firebaseReadyProvider = Provider<bool>((_) => false);
final clockProvider = Provider<DateTime Function()>((_) => DateTime.now);

final outboxProvider = Provider<Outbox>(
  (ref) => Outbox(ref.watch(appPrefsProvider)),
);
final nativeBridgeProvider = Provider<NativeBridge>(
  (_) => MethodChannelNativeBridge(),
);
final notificationServiceProvider = Provider<NotificationService>(
  (_) => NotificationService(),
);
final speechProvider = Provider<SpeechService>((_) => FlutterTtsSpeech());

final analyticsProvider = Provider<Analytics>((ref) {
  if (!ref.watch(firebaseReadyProvider)) return NoopAnalytics();
  return FirebaseAnalyticsService(FirebaseAnalytics.instance);
});

/// One in-memory demo backend per process so its data survives screen changes.
final demoBackendProvider = Provider<DemoBackend>((_) => DemoBackend());

final backendProvider = Provider<BackendGateway>((ref) {
  if (AppConfig.useDemoBackend) return ref.watch(demoBackendProvider);
  final role = ref.watch(appModeProvider) ?? AppMode.protected;
  final store = ref.watch(secureStoreProvider);
  final ready = ref.watch(firebaseReadyProvider);
  return RemoteBackend(
    dio: buildDio(store: store, pinnedRoots: ref.watch(pinnedRootsProvider)),
    store: store,
    role: role,
    fcmToken: () async => ready ? FirebaseMessaging.instance.getToken() : null,
  );
});

// --- persisted app state ----------------------------------------------------------------------

class AppModeNotifier extends Notifier<AppMode?> {
  @override
  AppMode? build() => ref.watch(appPrefsProvider).mode;

  Future<void> select(AppMode mode) async {
    await ref.read(appPrefsProvider).setMode(mode);
    state = mode;
  }

  /// Back to the mode picker. Pairing data is cleared: a phone is either
  /// protected or a guardian, never both at once.
  Future<void> reset() async {
    final prefs = ref.read(appPrefsProvider);
    await prefs.setMode(null);
    await prefs.clearPairing();
    await prefs.setPermissionsIntroDone(false);
    await prefs.setGuardianProfile(null);
    await ref.read(secureStoreProvider).clear();
    await ref.read(localDbProvider).wipe();
    await ref.read(nativeBridgeProvider).stopMonitor();
    ref.invalidate(familyLinkProvider);
    ref.invalidate(guardianProfileProvider);
    ref.invalidate(guardianFamilyIdProvider);
    ref.invalidate(permissionsIntroDoneProvider);
    state = null;
  }
}

final appModeProvider = NotifierProvider<AppModeNotifier, AppMode?>(
  AppModeNotifier.new,
);

class GuardianLocaleNotifier extends Notifier<Locale> {
  @override
  Locale build() => Locale(ref.watch(appPrefsProvider).localeCode);

  Future<void> set(String code) async {
    await ref.read(appPrefsProvider).setLocaleCode(code);
    state = Locale(code);
  }
}

final guardianLocaleProvider = NotifierProvider<GuardianLocaleNotifier, Locale>(
  GuardianLocaleNotifier.new,
);

class ProtectedLocaleNotifier extends Notifier<Locale> {
  @override
  Locale build() => Locale(ref.watch(appPrefsProvider).protectedLocaleCode);

  Future<void> set(String code) async {
    await ref.read(appPrefsProvider).setProtectedLocaleCode(code);
    state = Locale(code);
  }
}

final protectedLocaleProvider =
    NotifierProvider<ProtectedLocaleNotifier, Locale>(
      ProtectedLocaleNotifier.new,
    );

/// [ParentL10n] for non-widget code (Notifiers, background providers) that
/// has no BuildContext to read [ParentL10nScope] from. Widgets should prefer
/// `context.parent`, which rebuilds automatically on language change.
final parentL10nProvider = Provider<ParentL10n>(
  (ref) => ParentL10n(
    hi: lookupAppLocalizations(ref.watch(protectedLocaleProvider)),
    en: lookupAppLocalizations(const Locale('en')),
  ),
);

class FamilyLinkNotifier extends Notifier<FamilyLink?> {
  @override
  FamilyLink? build() => ref.watch(appPrefsProvider).familyLink;

  Future<void> set(FamilyLink? link) async {
    await ref.read(appPrefsProvider).setFamilyLink(link);
    state = link;
  }
}

/// Protected phone: who is watching over this phone.
final familyLinkProvider = NotifierProvider<FamilyLinkNotifier, FamilyLink?>(
  FamilyLinkNotifier.new,
);

class GuardianProfileNotifier extends Notifier<GuardianProfile?> {
  @override
  GuardianProfile? build() => ref.watch(appPrefsProvider).guardianProfile;

  Future<void> set(GuardianProfile p) async {
    await ref.read(appPrefsProvider).setGuardianProfile(p);
    state = p;
  }
}

/// Guardian phone: the guardian's own profile.
final guardianProfileProvider =
    NotifierProvider<GuardianProfileNotifier, GuardianProfile?>(
      GuardianProfileNotifier.new,
    );

class GuardianFamilyIdNotifier extends Notifier<String?> {
  @override
  String? build() => ref.watch(appPrefsProvider).familyId;

  Future<void> set(String? id) async {
    await ref.read(appPrefsProvider).setFamilyId(id);
    state = id;
  }
}

final guardianFamilyIdProvider =
    NotifierProvider<GuardianFamilyIdNotifier, String?>(
      GuardianFamilyIdNotifier.new,
    );

class PermissionsIntroNotifier extends Notifier<bool> {
  @override
  bool build() => ref.watch(appPrefsProvider).permissionsIntroDone;

  Future<void> complete() async {
    await ref.read(appPrefsProvider).setPermissionsIntroDone(true);
    state = true;
  }
}

final permissionsIntroDoneProvider =
    NotifierProvider<PermissionsIntroNotifier, bool>(
      PermissionsIntroNotifier.new,
    );
