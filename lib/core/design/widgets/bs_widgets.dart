import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';

import '../../utils/responsive.dart';
import '../theme.dart';
import '../tokens.dart';

/// Page shell used by every screen: safe area, centred max-width column,
/// responsive gutters, and scroll that still lets a `Spacer` push actions to
/// the bottom on tall screens.
class BsPage extends StatelessWidget {
  const BsPage({
    super.key,
    required this.child,
    this.background = BsColors.paper,
    this.padding,
    this.bottomBar,
    this.statusBarLight = false,
    this.fill = true,
  });

  final Widget child;
  final Color background;
  final EdgeInsetsGeometry? padding;
  final Widget? bottomBar;

  /// True on dark backgrounds so system icons stay visible.
  final bool statusBarLight;

  /// When true, the content is at least as tall as the viewport.
  final bool fill;

  @override
  Widget build(BuildContext context) {
    final gutter = context.gutter;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: statusBarLight
          ? SystemUiOverlayStyle.light
          : SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: background,
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, box) {
              Widget content = Padding(
                padding: padding ?? EdgeInsets.fromLTRB(gutter, 12, gutter, 20),
                child: child,
              );
              content = fill
                  ? ConstrainedBox(
                      constraints: BoxConstraints(minHeight: box.maxHeight),
                      child: IntrinsicHeight(child: content),
                    )
                  : content;
              return Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: context.maxContentWidth,
                  ),
                  child: SingleChildScrollView(child: content),
                ),
              );
            },
          ),
        ),
        bottomNavigationBar: bottomBar == null
            ? null
            : ColoredBox(
                color: background,
                child: SafeArea(
                  child: Center(
                    heightFactor: 1,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: context.maxContentWidth,
                      ),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(gutter, 8, gutter, 14),
                        child: bottomBar,
                      ),
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}

/// Small navy shield mark used as the app logo.
class LogoMark extends StatelessWidget {
  const LogoMark({super.key, this.size = 20, this.color = BsColors.navy});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) => ExcludeSemantics(
    child: CustomPaint(size: Size(size, size), painter: _ShieldPainter(color)),
  );
}

class _ShieldPainter extends CustomPainter {
  _ShieldPainter(this.color);
  final Color color;

  @override
  void paint(Canvas canvas, Size s) {
    final w = s.width, h = s.height;
    final p = Path()
      ..moveTo(w * .18, h * .05)
      ..lineTo(w * .82, h * .05)
      ..quadraticBezierTo(w * .96, h * .05, w * .96, h * .2)
      ..lineTo(w * .96, h * .52)
      ..quadraticBezierTo(w * .96, h * .82, w * .5, h * .97)
      ..quadraticBezierTo(w * .04, h * .82, w * .04, h * .52)
      ..lineTo(w * .04, h * .2)
      ..quadraticBezierTo(w * .04, h * .05, w * .18, h * .05)
      ..close();
    canvas.drawPath(p, Paint()..color = color);
  }

  @override
  bool shouldRepaint(_ShieldPainter old) => old.color != color;
}

/// White soft card.
class BsCard extends StatelessWidget {
  const BsCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.color = BsColors.card,
    this.border,
    this.radius = BsRadius.card,
    this.onTap,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color color;
  final BoxBorder? border;
  final double radius;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final deco = BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(radius),
      border:
          border ?? Border.all(color: BsColors.hairline.withValues(alpha: .6)),
      boxShadow: const [
        BoxShadow(
          color: Color(0x0F181712),
          blurRadius: 12,
          offset: Offset(0, 2),
        ),
      ],
    );
    final inner = Padding(padding: padding, child: child);
    if (onTap == null) return DecoratedBox(decoration: deco, child: inner);
    return Material(
      color: Colors.transparent,
      child: Ink(
        decoration: deco,
        child: InkWell(
          borderRadius: BorderRadius.circular(radius),
          onTap: onTap,
          child: inner,
        ),
      ),
    );
  }
}

/// Spaced mono label ("THIS WEEK").
class MonoLabel extends StatelessWidget {
  const MonoLabel(this.text, {super.key, this.color, this.size = 11});

  final String text;
  final Color? color;
  final double size;

  @override
  Widget build(BuildContext context) => Text(
    text.toUpperCase(),
    style: BsText.mono(size, color: color),
    maxLines: 2,
  );
}

/// Hindi primary line with English underneath (parent-facing copy).
class BiText extends StatelessWidget {
  const BiText({
    super.key,
    required this.hi,
    required this.en,
    this.hiStyle,
    this.enStyle,
    this.align = TextAlign.start,
    this.gap = 6,
  });

  final String hi;
  final String en;
  final TextStyle? hiStyle;
  final TextStyle? enStyle;
  final TextAlign align;
  final double gap;

  @override
  Widget build(BuildContext context) {
    final cross = switch (align) {
      TextAlign.center => CrossAxisAlignment.center,
      TextAlign.end || TextAlign.right => CrossAxisAlignment.end,
      _ => CrossAxisAlignment.start,
    };
    // When the primary language is English, `en` duplicates `hi` verbatim —
    // drop the second line rather than showing the same text twice.
    final showEn = en.isNotEmpty && en != hi;
    return Semantics(
      label: showEn ? '$hi. $en' : hi,
      excludeSemantics: true,
      child: Column(
        crossAxisAlignment: cross,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            hi,
            textAlign: align,
            style: hiStyle ?? BsText.sans(24, w: FontWeight.w600),
          ),
          if (showEn) ...[
            SizedBox(height: gap),
            Text(
              en,
              textAlign: align,
              style: enStyle ?? BsText.sans(14, color: BsColors.inkSoft),
            ),
          ],
        ],
      ),
    );
  }
}

enum BsButtonKind {
  navy,
  ink,
  white,
  outline,
  amber,
  red,
  onRed,
  ghostDark,
  ghostOnRed,
  ghostOnNavy,
  tintOnNavy,
}

/// Large, thumb-friendly button. Labels are already localised strings; use
/// [semanticLabel] to add the English reading for Hindi-only buttons.
class BsButton extends StatelessWidget {
  const BsButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.kind = BsButtonKind.navy,
    this.leading,
    this.semanticLabel,
    this.loading = false,
    this.dense = false,
    this.fontSize,
  });

  final String label;
  final VoidCallback? onPressed;
  final BsButtonKind kind;
  final Widget? leading;
  final String? semanticLabel;
  final bool loading;
  final bool dense;
  final double? fontSize;

  ({Color bg, Color fg, Color? line}) get _style => switch (kind) {
    BsButtonKind.navy => (bg: BsColors.navy, fg: Colors.white, line: null),
    BsButtonKind.ink => (bg: BsColors.ink, fg: Colors.white, line: null),
    BsButtonKind.white => (
      bg: Colors.white,
      fg: BsColors.ink,
      line: BsColors.hairline,
    ),
    BsButtonKind.outline => (
      bg: Colors.transparent,
      fg: BsColors.ink,
      line: BsColors.hairline,
    ),
    BsButtonKind.amber => (bg: BsColors.amber, fg: BsColors.ink, line: null),
    BsButtonKind.red => (bg: BsColors.red, fg: Colors.white, line: null),
    BsButtonKind.onRed => (bg: Colors.white, fg: BsColors.red, line: null),
    BsButtonKind.ghostDark => (
      bg: Colors.transparent,
      fg: const Color(0xFFB8B2A6),
      line: const Color(0xFF4A4438),
    ),
    BsButtonKind.ghostOnRed => (
      bg: Colors.transparent,
      fg: const Color(0xFFF3D3CE),
      line: const Color(0x66FFFFFF),
    ),
    BsButtonKind.ghostOnNavy => (
      bg: Colors.transparent,
      fg: Colors.white,
      line: const Color(0x66FFFFFF),
    ),
    BsButtonKind.tintOnNavy => (
      bg: const Color(0xFFF1F4F9),
      fg: BsColors.navy,
      line: null,
    ),
  };

  @override
  Widget build(BuildContext context) {
    final s = _style;
    final enabled = onPressed != null && !loading;
    final size = fontSize ?? (dense ? 15.0 : 17.0);
    return Semantics(
      button: true,
      enabled: enabled,
      label: semanticLabel ?? label,
      excludeSemantics: true,
      onTap: enabled ? onPressed : null,
      child: Opacity(
        opacity: onPressed == null ? .45 : 1,
        child: Material(
          color: s.bg,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(BsRadius.button),
            side: s.line == null ? BorderSide.none : BorderSide(color: s.line!),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(BsRadius.button),
            onTap: enabled ? onPressed : null,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: dense ? 48 : 56,
                minWidth: double.infinity,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 12,
                ),
                child: Center(
                  child: loading
                      ? SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.4,
                            color: s.fg,
                          ),
                        )
                      : Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (leading != null) ...[
                              leading!,
                              const SizedBox(width: 10),
                            ],
                            Flexible(
                              child: Text(
                                label,
                                textAlign: TextAlign.center,
                                style: BsText.sans(
                                  size,
                                  w: FontWeight.w600,
                                  color: s.fg,
                                ),
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// "Press and hold" confirm — the quiet way to proceed during an intervention.
/// Holding fills the border; releasing early cancels. TalkBack users trigger it
/// with the accessibility long-press action, so nobody needs a precise gesture.
class HoldButton extends StatefulWidget {
  const HoldButton({
    super.key,
    required this.label,
    required this.onConfirmed,
    this.hint,
    this.duration = const Duration(milliseconds: 1500),
    this.fg = const Color(0xFFB8B2A6),
    this.line = const Color(0xFF4A4438),
    this.fill = const Color(0x33DFA03C),
    this.semanticLabel,
  });

  final String label;
  final String? semanticLabel;
  final String? hint;
  final VoidCallback onConfirmed;
  final Duration duration;
  final Color fg;
  final Color line;
  final Color fill;

  @override
  State<HoldButton> createState() => _HoldButtonState();
}

class _HoldButtonState extends State<HoldButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c =
      AnimationController(vsync: this, duration: widget.duration)
        ..addStatusListener((s) {
          if (s == AnimationStatus.completed) {
            HapticFeedback.mediumImpact();
            widget.onConfirmed();
            _c.value = 0;
          }
        });

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: widget.semanticLabel ?? widget.label,
      hint: widget.hint,
      excludeSemantics: true,
      onLongPress: widget.onConfirmed,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) => _c.forward(),
        onTapUp: (_) => _c.reverse(),
        onTapCancel: () => _c.reverse(),
        child: AnimatedBuilder(
          animation: _c,
          builder: (context, _) => Container(
            constraints: const BoxConstraints(
              minHeight: 52,
              minWidth: double.infinity,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(BsRadius.button),
              border: Border.all(color: widget.line),
              gradient: LinearGradient(
                stops: [_c.value, _c.value],
                colors: [widget.fill, Colors.transparent],
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              widget.label,
              textAlign: TextAlign.center,
              style: BsText.sans(15, color: widget.fg),
            ),
          ),
        ),
      ),
    );
  }
}

/// Round avatar: photo when we have one, otherwise initials on a soft tint.
class BsAvatar extends StatelessWidget {
  const BsAvatar({
    super.key,
    required this.name,
    this.size = 44,
    this.photo,
    this.square = false,
  });

  final String name;
  final double size;
  final Uint8List? photo;
  final bool square;

  @override
  Widget build(BuildContext context) {
    final initials = name.trim().isEmpty
        ? '·'
        : String.fromCharCode(name.trim().runes.first).toUpperCase();
    final shape = square ? BoxShape.rectangle : BoxShape.circle;
    return ExcludeSemantics(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: shape,
          borderRadius: square ? BorderRadius.circular(size * .3) : null,
          color: BsColors.navyTint,
          image: photo == null
              ? null
              : DecorationImage(image: MemoryImage(photo!), fit: BoxFit.cover),
        ),
        alignment: Alignment.center,
        child: photo == null
            ? Text(
                initials,
                style: BsText.sans(
                  size * .42,
                  w: FontWeight.w600,
                  color: BsColors.navy,
                ),
              )
            : null,
      ),
    );
  }
}

class StatusDot extends StatelessWidget {
  const StatusDot(this.color, {super.key, this.size = 8});
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) => ExcludeSemantics(
    child: Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    ),
  );
}

class CheckCircle extends StatelessWidget {
  const CheckCircle({
    super.key,
    this.size = 24,
    this.bg = BsColors.navy,
    this.fg = Colors.white,
  });
  final double size;
  final Color bg;
  final Color fg;

  @override
  Widget build(BuildContext context) => ExcludeSemantics(
    child: Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
      child: Icon(Icons.check_rounded, size: size * .66, color: fg),
    ),
  );
}

/// Formats a duration as m:ss (counts up on intervention screens).
String formatClock(Duration d) {
  final m = d.inMinutes;
  final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
  return '$m:$s';
}

/// Rebuilds every second with the time elapsed since [start].
class ElapsedBuilder extends StatefulWidget {
  const ElapsedBuilder({
    super.key,
    required this.start,
    required this.builder,
    this.now,
  });

  final DateTime start;
  final Widget Function(BuildContext, Duration) builder;

  /// Test seam.
  final DateTime Function()? now;

  @override
  State<ElapsedBuilder> createState() => _ElapsedBuilderState();
}

class _ElapsedBuilderState extends State<ElapsedBuilder> {
  Timer? _t;
  late Duration _elapsed = _calc();

  Duration _calc() {
    final d = (widget.now ?? DateTime.now)().difference(widget.start);
    return d.isNegative ? Duration.zero : d;
  }

  @override
  void initState() {
    super.initState();
    _t = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() => _elapsed = _calc());
    });
  }

  @override
  void dispose() {
    _t?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.builder(context, _elapsed);
}

/// Circular timer ring (fills clockwise over [total]).
class TimerRing extends StatelessWidget {
  const TimerRing({
    super.key,
    required this.progress,
    required this.child,
    this.size = 128,
    this.color = BsColors.amber,
    this.track = const Color(0x22FFFFFF),
  });

  final double progress;
  final Widget child;
  final double size;
  final Color color;
  final Color track;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: size,
    height: size,
    child: CustomPaint(
      painter: _RingPainter(progress.clamp(0, 1), color, track),
      child: Center(child: child),
    ),
  );
}

class _RingPainter extends CustomPainter {
  _RingPainter(this.progress, this.color, this.track);
  final double progress;
  final Color color;
  final Color track;

  @override
  void paint(Canvas canvas, Size size) {
    const stroke = 6.0;
    final rect = Offset.zero & size;
    final r = rect.deflate(stroke / 2);
    canvas.drawArc(
      r,
      0,
      math.pi * 2,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = track,
    );
    canvas.drawArc(
      r,
      -math.pi / 2,
      math.pi * 2 * progress,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.butt
        ..strokeWidth = stroke
        ..color = color,
    );
  }

  @override
  bool shouldRepaint(_RingPainter old) =>
      old.progress != progress || old.color != color;
}

/// Announces a message to TalkBack (used when a warning appears).
void announce(BuildContext context, String message) {
  SemanticsService.sendAnnouncement(
    View.of(context),
    message,
    Directionality.of(context),
  );
}
