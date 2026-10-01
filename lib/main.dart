import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';
import 'app/providers.dart';
import 'core/network/dio_factory.dart';
import 'core/services/background_tasks.dart';
import 'core/services/firebase_bootstrap.dart';
import 'core/storage/app_prefs.dart';
import 'core/storage/local_db.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final firebaseReady = await FirebaseBootstrap.init();
  FirebaseBootstrap.wireCrashReporting();
  if (firebaseReady) {
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  }

  final prefs = await AppPrefs.open();
  final db = await HiveLocalDb.open();
  await db.pruneOlderThan(const Duration(days: 30), DateTime.now());
  final pinnedRoots = await loadPinnedRoots();

  // Uploads queued while offline are retried in the background.
  if (prefs.mode == AppMode.protected) await BackgroundTasks.schedule();

  runApp(
    ProviderScope(
      overrides: [
        appPrefsProvider.overrideWithValue(prefs),
        localDbProvider.overrideWithValue(db),
        pinnedRootsProvider.overrideWithValue(pinnedRoots),
        firebaseReadyProvider.overrideWithValue(firebaseReady),
      ],
      child: const BetaShieldApp(),
    ),
  );
}
