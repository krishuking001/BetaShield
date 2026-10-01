import 'dart:async';

import '../../../core/error/app_exception.dart';
import '../../../core/logging/safe_log.dart';
import '../../../core/storage/local_db.dart';
import '../../../core/storage/outbox.dart';
import '../../family/domain/family_models.dart';
import '../domain/risk_models.dart';

/// Records every risk event locally (always) and uploads the structured copy
/// when the phone is paired. Offline-first: uploads wait in the outbox and are
/// retried on connectivity, on app start, and by the WorkManager job.
class EventSyncService {
  EventSyncService({
    required this.db,
    required this.outbox,
    required this.uplink,
    required this.isLinked,
    this.onChanged,
  });

  final LocalDb db;
  final Outbox outbox;
  final EventUplinkRepository uplink;
  final bool Function() isLinked;
  final void Function()? onChanged;

  var _flushing = false;

  Future<void> record(RiskEvent e) async {
    await db.putEvent(e);
    onChanged?.call();
    if (!isLinked()) return;
    await outbox.enqueue(e);
    unawaited(flush());
  }

  /// Uploads queued events oldest-first. Returns how many were delivered.
  Future<int> flush() async {
    if (_flushing || !isLinked()) return 0;
    _flushing = true;
    try {
      return await drainOutbox(outbox, uplink);
    } finally {
      _flushing = false;
    }
  }
}

/// Uploads everything waiting in [outbox]. Shared by the app and the
/// WorkManager job (which has no Riverpod container).
Future<int> drainOutbox(Outbox outbox, EventUplinkRepository uplink) async {
  var sent = 0;
  for (final entry in await outbox.pending()) {
    try {
      await uplink.submitEvent(entry.event);
      await outbox.dequeue(entry);
      sent++;
    } on AppException catch (e) {
      if (e.isRetryable ||
          e.kind == FailureKind.notPaired ||
          e.kind == FailureKind.unauthorized) {
        break;
      }
      // A request the server will never accept must not block the queue.
      SafeLog.d('sync', 'dropping unsendable event (${e.kind.name})');
      await outbox.dequeue(entry);
    }
  }
  return sent;
}
