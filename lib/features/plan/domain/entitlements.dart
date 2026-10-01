import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// The single seam for a future paid Family plan. Every feature gate and every
/// ad decision reads [Entitlements]; nothing else in the app knows what a plan
/// is. Adding billing later means: implement [PurchaseGateway] with Play
/// Billing, and make [entitlementsProvider] return `Entitlements.family` for
/// subscribers. No core logic changes.
enum Plan { free, family }

@immutable
class Entitlements {
  const Entitlements({
    required this.plan,
    required this.maxProtectedPhones,
    required this.adsEnabled,
    required this.weeklyReport,
    required this.comboRisk,
  });

  final Plan plan;
  final int maxProtectedPhones;

  /// Guardian-side ads. Protected mode never shows ads regardless of this flag.
  final bool adsEnabled;
  final bool weeklyReport;
  final bool comboRisk;

  /// Launch version: everything is free and unlimited, supported by
  /// guardian-side ads only.
  static const freeLaunch = Entitlements(
    plan: Plan.free,
    maxProtectedPhones: 4,
    adsEnabled: true,
    weeklyReport: true,
    comboRisk: true,
  );

  /// What a subscriber will get (not reachable in this release).
  static const family = Entitlements(
    plan: Plan.family,
    maxProtectedPhones: 4,
    adsEnabled: false,
    weeklyReport: true,
    comboRisk: true,
  );
}

enum PlanPeriod { year, month }

@immutable
class PlanOffer {
  const PlanOffer({
    required this.id,
    required this.priceInr,
    required this.period,
    this.perMonthInr,
    this.phones,
  });

  final String id;
  final int priceInr;
  final PlanPeriod period;
  final int? perMonthInr;
  final int? phones;

  static const familyYearly = PlanOffer(
    id: 'family_yearly',
    priceInr: 999,
    period: PlanPeriod.year,
    perMonthInr: 83,
    phones: 4,
  );
  static const monthly = PlanOffer(
    id: 'family_monthly',
    priceInr: 129,
    period: PlanPeriod.month,
  );
}

enum PurchaseResult { comingSoon, purchased, cancelled }

abstract interface class PurchaseGateway {
  Future<PurchaseResult> purchase(PlanOffer offer);
}

/// No payment code exists in this release: the CTA reports "coming soon".
class ComingSoonPurchaseGateway implements PurchaseGateway {
  const ComingSoonPurchaseGateway();

  @override
  Future<PurchaseResult> purchase(PlanOffer offer) async =>
      PurchaseResult.comingSoon;
}

final entitlementsProvider = Provider<Entitlements>(
  (_) => Entitlements.freeLaunch,
);
final purchaseGatewayProvider = Provider<PurchaseGateway>(
  (_) => const ComingSoonPurchaseGateway(),
);
