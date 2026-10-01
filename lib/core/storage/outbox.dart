import 'dart:convert';

import '../../features/risk/domain/risk_models.dart';
import 'app_prefs.dart';

class OutboxEntry {
  const OutboxEntry(this.event, this.version);

  final RiskEvent event;

  /// Opaque snapshot of what was queued; used so a newer version enqueued
  /// during an upload is not deleted by the upload's completion.
  final String version;
}

/// Risk events waiting for connectivity. Stored in SharedPreferences (not
/// Hive) so the WorkManager isolate can drain it while the app is closed.
/// Holds only `toApiJson()` fields — the same structured data the server accepts.
class Outbox {
  Outbox(this._prefs);

  final AppPrefs _prefs;

  static const _key = 'outbox_v1';

  Map<String, String> _read() {
    final raw = _prefs.getString(_key);
    if (raw == null) return {};
    try {
      return (jsonDecode(raw) as Map).cast<String, String>();
    } catch (_) {
      return {};
    }
  }

  Future<void> _write(Map<String, String> m) =>
      _prefs.setString(_key, jsonEncode(m));

  /// A newer version of the same event replaces the queued one.
  Future<void> enqueue(RiskEvent e) async {
    await _prefs.reload();
    await _write(_read()..[e.id] = jsonEncode(e.toApiJson()));
  }

  Future<List<OutboxEntry>> pending() async {
    await _prefs.reload();
    final out = <OutboxEntry>[];
    for (final raw in _read().values) {
      try {
        out.add(
          OutboxEntry(
            RiskEvent.fromJson(
              (jsonDecode(raw) as Map).cast<String, dynamic>(),
            ),
            raw,
          ),
        );
      } catch (_) {}
    }
    out.sort((a, b) => a.event.startedAt.compareTo(b.event.startedAt));
    return out;
  }

  Future<void> dequeue(OutboxEntry entry) async {
    await _prefs.reload();
    final m = _read();
    if (m[entry.event.id] != entry.version) return;
    m.remove(entry.event.id);
    await _write(m);
  }
}
