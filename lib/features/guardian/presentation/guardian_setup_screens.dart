import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../app/providers.dart';
import '../../../core/design/theme.dart';
import '../../../core/design/tokens.dart';
import '../../../core/design/widgets/bs_widgets.dart';
import '../../../core/l10n/l10n.dart';
import '../../../core/utils/responsive.dart';
import '../../ads/application/ad_service.dart';
import '../../ads/domain/ad_policy.dart';
import '../../pairing/domain/pairing_models.dart';
import '../application/guardian_controllers.dart';
import 'guardian_screens.dart' show errorText;

// =============================================================================================
// Guardian profile — the words and face a parent sees on intervention screens
// =============================================================================================

class GuardianSetupScreen extends ConsumerStatefulWidget {
  const GuardianSetupScreen({super.key, this.editing = false});

  final bool editing;

  @override
  ConsumerState<GuardianSetupScreen> createState() => _SetupState();
}

class _SetupState extends ConsumerState<GuardianSetupScreen> {
  final _form = GlobalKey<FormState>();
  late final _name = TextEditingController(
    text: ref.read(guardianProfileProvider)?.name,
  );
  late final _nameHi = TextEditingController(
    text: ref.read(guardianProfileProvider)?.nameHi,
  );
  late final _phone = TextEditingController(
    text: ref.read(guardianProfileProvider)?.phone,
  );
  late final _message = TextEditingController(
    text: ref.read(guardianProfileProvider)?.personalMessage,
  );
  String? _photo;

  @override
  void initState() {
    super.initState();
    _photo = ref.read(guardianProfileProvider)?.photoBase64;
  }

  @override
  void dispose() {
    _name.dispose();
    _nameHi.dispose();
    _phone.dispose();
    _message.dispose();
    super.dispose();
  }

  /// Small square JPEG so it fits in the pairing payload (≤ ~60 KB).
  Future<void> _pickPhoto() async {
    final file = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 256,
      maxHeight: 256,
      imageQuality: 70,
    );
    if (file == null) return;
    var bytes = await file.readAsBytes();
    if (bytes.length > 55000) {
      final again = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: 160,
        maxHeight: 160,
        imageQuality: 55,
      );
      if (again == null) return;
      bytes = await again.readAsBytes();
    }
    if (bytes.length > 58000) return;
    if (mounted) setState(() => _photo = base64Encode(bytes));
  }

  Future<void> _save() async {
    if (!(_form.currentState?.validate() ?? false)) return;
    await ref
        .read(guardianProfileProvider.notifier)
        .set(
          GuardianProfile(
            name: _name.text.trim(),
            nameHi: _nameHi.text.trim(),
            phone: _phone.text.trim(),
            photoBase64: _photo,
            personalMessage: _message.text.trim().isEmpty
                ? null
                : _message.text.trim(),
          ),
        );
    if (!mounted) return;
    if (widget.editing) {
      context.pop();
    } else {
      context.go('/guardian/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final photoBytes = _photo == null ? null : base64Decode(_photo!);
    return BsPage(
      fill: false,
      child: Form(
        key: _form,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (widget.editing)
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  tooltip: l.gBack,
                  onPressed: () => context.pop(),
                  icon: const Icon(Icons.arrow_back_rounded),
                ),
              ),
            const SizedBox(height: 8),
            Semantics(
              header: true,
              child: Text(
                l.gSetupTitle,
                style: BsText.serif(context.fluid(38)),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l.gSetupSub,
              style: BsText.sans(14.5, color: BsColors.inkSoft, height: 1.5),
            ),
            const SizedBox(height: 22),
            Center(
              child: Semantics(
                button: true,
                label: l.gPhoto,
                child: GestureDetector(
                  onTap: _pickPhoto,
                  child: Stack(
                    children: [
                      BsAvatar(
                        name: _name.text.isEmpty ? '+' : _name.text,
                        size: 96,
                        photo: photoBytes,
                        square: true,
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                            color: BsColors.navy,
                            shape: BoxShape.circle,
                            border: Border.all(color: BsColors.paper, width: 2),
                          ),
                          child: const Icon(
                            Icons.camera_alt_outlined,
                            color: Colors.white,
                            size: 17,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 22),
            _Field(
              controller: _name,
              label: l.gName,
              action: TextInputAction.next,
              capitalization: TextCapitalization.words,
              validator: (v) =>
                  (v ?? '').trim().isEmpty ? l.gNameRequired : null,
              onChanged: (_) => setState(() {}),
            ),
            _Field(
              controller: _nameHi,
              label: l.gNameHi,
              action: TextInputAction.next,
            ),
            _Field(
              controller: _phone,
              label: l.gPhone,
              keyboard: TextInputType.phone,
              action: TextInputAction.next,
              formatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9+ ]')),
              ],
              validator: (v) =>
                  RegExp(r'^\+?[0-9 ]{6,16}$').hasMatch((v ?? '').trim())
                  ? null
                  : l.gPhoneInvalid,
            ),
            _Field(
              controller: _message,
              label: l.gMessage,
              hint: l.gMessageHint,
              maxLength: 140,
              maxLines: 3,
              keyboard: TextInputType.multiline,
            ),
            const SizedBox(height: 10),
            BsButton(
              label: widget.editing ? l.gSave : l.gContinue,
              onPressed: _save,
            ),
          ],
        ),
      ),
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({
    required this.controller,
    required this.label,
    this.hint,
    this.validator,
    this.keyboard,
    this.action,
    this.capitalization = TextCapitalization.none,
    this.formatters,
    this.maxLength,
    this.maxLines = 1,
    this.onChanged,
  });

  final TextEditingController controller;
  final String label;
  final String? hint;
  final String? Function(String?)? validator;
  final TextInputType? keyboard;
  final TextInputAction? action;
  final TextCapitalization capitalization;
  final List<TextInputFormatter>? formatters;
  final int? maxLength;
  final int maxLines;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 14),
    child: TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboard,
      textInputAction: action,
      textCapitalization: capitalization,
      inputFormatters: formatters,
      maxLength: maxLength,
      maxLines: maxLines,
      onChanged: onChanged,
      style: BsText.sans(15.5),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        floatingLabelStyle: BsText.sans(13, color: BsColors.navy),
      ),
    ),
  );
}

// =============================================================================================
// Pair with a parent's phone: scan or type
// =============================================================================================

class GuardianPairScreen extends ConsumerStatefulWidget {
  const GuardianPairScreen({super.key, this.initialCode});

  final String? initialCode;

  @override
  ConsumerState<GuardianPairScreen> createState() => _PairState();
}

class _PairState extends ConsumerState<GuardianPairScreen> {
  late final _code = TextEditingController(text: widget.initialCode);
  late var _scan = widget.initialCode == null;
  String? _error;
  var _handled = false;

  @override
  void dispose() {
    _code.dispose();
    super.dispose();
  }

  void _next(String raw) {
    final normalized = PairingCode.normalize(raw);
    if (normalized == null) {
      setState(() => _error = context.l10n.gErrInvalidCode);
      return;
    }
    context.push('/guardian/pair/confirm?code=$normalized');
  }

  void _onDetect(BarcodeCapture cap) {
    if (_handled) return;
    for (final b in cap.barcodes) {
      final raw = b.rawValue;
      if (raw == null) continue;
      final uri = Uri.tryParse(raw);
      final code = uri?.queryParameters['code'] ?? raw;
      if (PairingCode.normalize(code) != null) {
        _handled = true;
        HapticFeedback.lightImpact();
        _next(code);
        Future.delayed(const Duration(seconds: 2), () => _handled = false);
        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return BsPage(
      fill: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              tooltip: l.gBack,
              onPressed: () => context.pop(),
              icon: const Icon(Icons.arrow_back_rounded),
            ),
          ),
          Semantics(
            header: true,
            child: Text(
              l.gPairTitle,
              style: BsText.sans(context.fluid(26), w: FontWeight.w700),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l.gPairSub,
            style: BsText.sans(14.5, color: BsColors.inkSoft, height: 1.5),
          ),
          const SizedBox(height: 18),
          SegmentedButton<bool>(
            segments: [
              ButtonSegment(
                value: true,
                label: Text(l.gScanTab),
                icon: const Icon(Icons.qr_code_scanner_rounded),
              ),
              ButtonSegment(
                value: false,
                label: Text(l.gTypeTab),
                icon: const Icon(Icons.keyboard_alt_outlined),
              ),
            ],
            selected: {_scan},
            onSelectionChanged: (s) => setState(() {
              _scan = s.first;
              _error = null;
            }),
          ),
          const SizedBox(height: 18),
          if (_scan)
            AspectRatio(
              aspectRatio: 1,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(BsRadius.card),
                child: MobileScanner(
                  onDetect: _onDetect,
                  errorBuilder: (context, error) => Container(
                    color: BsColors.nightRaised,
                    padding: const EdgeInsets.all(24),
                    alignment: Alignment.center,
                    child: Text(
                      l.gCameraDenied,
                      textAlign: TextAlign.center,
                      style: BsText.sans(14, color: Colors.white),
                    ),
                  ),
                ),
              ),
            )
          else ...[
            TextField(
              controller: _code,
              textCapitalization: TextCapitalization.characters,
              autocorrect: false,
              enableSuggestions: false,
              style: BsText.mono(22, color: BsColors.ink),
              textAlign: TextAlign.center,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9\- ]')),
                LengthLimitingTextInputFormatter(9),
              ],
              decoration: InputDecoration(
                hintText: l.gCodeHint,
                errorText: _error,
              ),
              onSubmitted: _next,
              onChanged: (_) => setState(() => _error = null),
            ),
            const SizedBox(height: 14),
            BsButton(label: l.gNext, onPressed: () => _next(_code.text)),
          ],
        ],
      ),
    );
  }
}

// =============================================================================================
// Confirm who it is, connect, celebrate (and one interstitial at this natural pause)
// =============================================================================================

class GuardianConfirmScreen extends ConsumerStatefulWidget {
  const GuardianConfirmScreen({super.key, required this.code});

  final String code;

  @override
  ConsumerState<GuardianConfirmScreen> createState() => _ConfirmState();
}

class _ConfirmState extends ConsumerState<GuardianConfirmScreen> {
  var _relation = Relation.mom;
  final _label = TextEditingController();
  final _phone = TextEditingController();
  String? _connectedLabel;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(claimControllerProvider.notifier).reset());
  }

  @override
  void dispose() {
    _label.dispose();
    _phone.dispose();
    super.dispose();
  }

  String _labelFor(AppLocalizations l) => switch (_relation) {
    Relation.mom => l.relMom,
    Relation.dad => l.relDad,
    Relation.other => _label.text.trim(),
  };

  Future<void> _connect() async {
    final l = context.l10n;
    final label = _labelFor(l);
    if (label.isEmpty) return;
    final ok = await ref
        .read(claimControllerProvider.notifier)
        .claim(
          code: widget.code,
          parentLabel: label,
          relation: _relation,
          parentPhone: _phone.text,
        );
    if (!ok || !mounted) return;
    setState(() => _connectedLabel = label);
    // Natural pause: pairing succeeded. Frequency-capped and consent-gated.
    await ref
        .read(adServiceProvider)
        .showInterstitial(AdPlacement.interstitialPairing);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final claim = ref.watch(claimControllerProvider);

    if (_connectedLabel != null) {
      return BsPage(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Spacer(),
            const Center(child: CheckCircle(size: 84)),
            const SizedBox(height: 22),
            Semantics(
              liveRegion: true,
              child: Text(
                l.gConnected(_connectedLabel!),
                textAlign: TextAlign.center,
                style: BsText.serif(context.fluid(36)),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l.gConnectedSub,
              textAlign: TextAlign.center,
              style: BsText.sans(14.5, color: BsColors.inkSoft, height: 1.5),
            ),
            const Spacer(),
            BsButton(
              label: l.gDone,
              onPressed: () => context.go('/guardian/home'),
            ),
          ],
        ),
      );
    }

    return BsPage(
      fill: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              tooltip: l.gBack,
              onPressed: () => context.pop(),
              icon: const Icon(Icons.arrow_back_rounded),
            ),
          ),
          Semantics(
            header: true,
            child: Text(
              l.gConfirmTitle,
              style: BsText.sans(context.fluid(26), w: FontWeight.w700),
            ),
          ),
          const SizedBox(height: 6),
          Text(widget.code, style: BsText.mono(15, color: BsColors.inkSoft)),
          const SizedBox(height: 18),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final (r, text) in [
                (Relation.mom, l.relMom),
                (Relation.dad, l.relDad),
                (Relation.other, l.relOther),
              ])
                ChoiceChip(
                  label: Text(
                    text,
                    style: BsText.sans(
                      15,
                      color: _relation == r ? Colors.white : BsColors.ink,
                    ),
                  ),
                  selected: _relation == r,
                  selectedColor: BsColors.navy,
                  showCheckmark: false,
                  onSelected: (_) => setState(() => _relation = r),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                ),
            ],
          ),
          if (_relation == Relation.other) ...[
            const SizedBox(height: 14),
            TextField(
              controller: _label,
              maxLength: 24,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(labelText: l.gLabelHint),
            ),
          ],
          const SizedBox(height: 14),
          TextField(
            controller: _phone,
            keyboardType: TextInputType.phone,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9+ ]')),
            ],
            decoration: InputDecoration(labelText: l.gParentPhone),
          ),
          if (claim.error != null) ...[
            const SizedBox(height: 14),
            Semantics(
              liveRegion: true,
              child: Text(
                errorText(l, claim.error!),
                style: BsText.sans(14, color: BsColors.red),
              ),
            ),
          ],
          const SizedBox(height: 20),
          BsButton(
            label: l.gConnect,
            loading: claim.busy,
            onPressed: _labelFor(l).isEmpty ? null : _connect,
          ),
        ],
      ),
    );
  }
}
