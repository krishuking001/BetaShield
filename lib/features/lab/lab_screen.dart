import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../core/design/theme.dart';
import '../../core/design/tokens.dart';
import '../../core/design/widgets/bs_widgets.dart';
import '../../core/services/native_bridge.dart';
import '../../core/services/push_handler.dart';
import '../../core/storage/app_prefs.dart';
import '../../data/demo_backend.dart';
import '../risk/application/risk_session.dart';

/// Demo-only "Simulation lab" (available when no API_BASE_URL is configured).
/// It drives the *real* code paths — native signals into the risk controller,
/// and a data-only push into the push handler — so every screen and every
/// intervention tone can be seen on one phone without a scam call.
class LabScreen extends ConsumerWidget {
  const LabScreen({super.key});

  static const _scamNumber = '+923144471234';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(appModeProvider);
    final session = ref.read(riskSessionProvider.notifier);

    Future<void> ring() => session.ingest(
      const NativeSignal(NativeSignalType.callRinging, number: _scamNumber),
    );
    Future<void> pay() => session.ingest(
      const NativeSignal(
        NativeSignalType.foregroundApp,
        pkg: 'com.phonepe.app',
      ),
    );
    Future<void> remote() => session.ingest(
      const NativeSignal(
        NativeSignalType.packageAdded,
        pkg: 'com.anydesk.anydeskandroid',
      ),
    );
    Future<void> end() => session.ingest(
      const NativeSignal(NativeSignalType.callState, state: 'idle'),
    );

    Widget tile(String title, String sub, VoidCallback onTap) => Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: BsCard(
        onTap: onTap,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: BsText.sans(15.5, w: FontWeight.w600)),
            Text(sub, style: BsText.sans(12.5, color: BsColors.inkFaint)),
          ],
        ),
      ),
    );

    return Scaffold(
      backgroundColor: BsColors.paper,
      appBar: AppBar(
        title: Text(
          'Simulation lab',
          style: BsText.sans(18, w: FontWeight.w600),
        ),
        leading: BackButton(onPressed: () => context.pop()),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Demo backend only. Uses the real risk engine, screens and push handler.',
            style: BsText.sans(13, color: BsColors.inkSoft),
          ),
          const SizedBox(height: 14),
          if (mode == AppMode.protected) ...[
            const MonoLabel('Protected phone'),
            const SizedBox(height: 10),
            tile(
              '1 · Scam call rings',
              'Unknown +92 number on the community list → live call warning',
              () async {
                await ring();
                if (context.mounted) context.go('/protected/live-call');
              },
            ),
            tile(
              '2 · Child\'s voice (tone iii)',
              'Call + scam list + screen-sharing app → score 68',
              () async {
                await ring();
                await remote();
              },
            ),
            tile(
              '3 · Calm interruption (tone i)',
              'Call + payment app opens → combo risk → score 86',
              () async {
                await ring();
                await remote();
                await pay();
              },
            ),
            tile(
              '4 · Emergency stop (tone ii)',
              'Same, and the call runs past 2 minutes → score 92',
              () async {
                await ring();
                await remote();
                await pay();
                await session.simulateLongCall();
              },
            ),
            tile(
              '5 · End the call',
              'Shows the "money safe" screen after an intervention',
              end,
            ),
            tile(
              '6 · Check a scam message',
              'Opens the message checker',
              () => context.push('/protected/check-message'),
            ),
          ] else ...[
            const MonoLabel('Guardian phone'),
            const SizedBox(height: 10),
            tile('1 · Live scam-call alert', 'Injects a live event, raises the red notification, opens the lock-screen view', () async {
              final demo = ref.read(demoBackendProvider);
              final e = demo.injectLiveEvent();
              await PushHandler(
                notifications: ref.read(notificationServiceProvider),
                speech: ref.read(speechProvider),
                prefs: ref.read(appPrefsProvider),
              ).handle({
                'type': 'risk_alert',
                'eventId': e.id,
                'parentLabel': 'Mom',
                'relation': 'mom',
                'parentPhone': '+91 98111 22334',
                'signals': e.signals
                    .map(
                      (s) => s.code.name.replaceAllMapped(
                        RegExp('[A-Z]'),
                        (m) => '_${m[0]!.toLowerCase()}',
                      ),
                    )
                    .join(','),
                'startedAt': e.startedAt.toIso8601String(),
              });
              if (context.mounted) context.go('/guardian/alert/${e.id}');
            }),
            tile(
              '2 · Open the live timeline',
              'Jumps straight to the risk timeline',
              () {
                ref.read(demoBackendProvider).injectLiveEvent();
                context.go('/guardian/event/${DemoBackend.liveEventId}');
              },
            ),
          ],
        ],
      ),
    );
  }
}
