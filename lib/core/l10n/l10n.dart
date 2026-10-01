import 'package:flutter/widgets.dart';

import '../../l10n/gen/app_localizations.dart';

export '../../l10n/gen/app_localizations.dart';

extension L10nContext on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);

  /// Parent-facing copy: primary language first (English by default, chosen
  /// in the Protected home menu), English underneath.
  ParentL10n get parent => ParentL10nScope.of(this);
}

/// Joins primary-language text with the English line for the many spots
/// that compose a bilingual string by hand (semantics labels, hints,
/// captions) rather than through [BiText]. Skips the English half when the
/// primary language already IS English, so the two don't show up twice.
String biJoin(String hi, String en, [String sep = ' · ']) =>
    hi == en ? hi : '$hi$sep$en';

/// Parent-mode strings are always shown bilingually: a primary language
/// (`hi` — the field name is historical, it now follows whatever language the
/// parent picked) plus a fixed English line underneath.
class ParentL10n {
  const ParentL10n({required this.hi, required this.en});

  final AppLocalizations hi;
  final AppLocalizations en;
}

/// Makes [ParentL10n] available to `context.parent` and rebuilds every
/// consumer when the primary language changes, without threading a
/// WidgetRef through every screen that reads it.
class ParentL10nScope extends InheritedWidget {
  const ParentL10nScope({super.key, required this.value, required super.child});

  final ParentL10n value;

  static ParentL10n of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<ParentL10nScope>();
    assert(scope != null, 'No ParentL10nScope found in context');
    return scope!.value;
  }

  @override
  bool updateShouldNotify(ParentL10nScope oldWidget) =>
      value.hi.localeName != oldWidget.value.hi.localeName;
}
