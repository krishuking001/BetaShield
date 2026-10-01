import 'package:flutter/widgets.dart';

/// Breakpoints for phones, large phones and foldables (inner display).
/// Layout code uses these instead of hard-coded pixel sizes.
extension ResponsiveContext on BuildContext {
  double get screenWidth => MediaQuery.sizeOf(this).width;
  double get screenHeight => MediaQuery.sizeOf(this).height;

  bool get isCompact => screenWidth < 360;
  bool get isWide => screenWidth >= 600;
  bool get isShort => screenHeight < 640;

  /// Horizontal page gutter.
  double get gutter => isCompact ? 16 : (isWide ? 32 : 22);

  /// Content never grows wider than this; on foldables it is centred.
  double get maxContentWidth => 560;

  /// Scales a design size gently with the screen (0.9× – 1.15×), so headlines
  /// suit a 320dp phone and a 480dp phablet alike without pixel constants.
  double fluid(double size) {
    final f = (screenWidth / 390).clamp(0.9, 1.15);
    return size * f;
  }
}
