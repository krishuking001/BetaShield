import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:workmanager/workmanager.dart';

import '../../data/remote_backend.dart';
import '../../features/risk/application/event_sync.dart';
import '../config/app_config.dart';
import '../logging/safe_log.dart';
import '../network/dio_factory.dart';
import '../storage/app_prefs.dart';
import '../storage/outbox.dart';
import '../storage/secure_store.dart';

const _outboxTask = 'beta_shield.flush_outbox';

/// Entry point for WorkManager (runs in its own isolate, possibly with the
/// app closed). It only drains the risk-event outbox: no UI, no message text.
@pragma('vm:entry-point')
void backgroundCallbackDispatcher() {
  Workmanager().executeTask((task, _) async {
    try {
      WidgetsFlutterBinding.ensureInitialized();
      if (AppConfig.useDemoBackend) return true;
      final prefs = await AppPrefs.open();
      if (prefs.mode != AppMode.protected || prefs.familyLink == null) {
        return true;
      }
      final store = FlutterSecureStore();
      final backend = RemoteBackend(
        dio: buildDio(store: store, pinnedRoots: await loadPinnedRoots()),
        store: store,
        role: AppMode.protected,
        fcmToken: () async => null,
      );
      await drainOutbox(Outbox(prefs), backend);
      return true;
    } catch (e) {
      SafeLog.e('workmanager', e);
      return false; // WorkManager retries with back-off
    }
  });
}

abstract final class BackgroundTasks {
  /// Every 15 minutes (the Android minimum), only with a network connection.
  static Future<void> schedule() async {
    if (!Platform.isAndroid) return;
    try {
      await Workmanager().initialize(backgroundCallbackDispatcher);
      await Workmanager().registerPeriodicTask(
        'beta_shield_outbox',
        _outboxTask,
        frequency: const Duration(minutes: 15),
        constraints: Constraints(networkType: NetworkType.connected),
        existingWorkPolicy: ExistingPeriodicWorkPolicy.keep,
      );
    } catch (e) {
      SafeLog.e('workmanager', e);
    }
  }
}
