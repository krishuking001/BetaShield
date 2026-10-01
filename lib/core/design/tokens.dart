import 'package:flutter/material.dart';

/// Colours sampled from the Beta Shield design PDF.
/// Warm paper, one navy accent; red/amber are reserved for danger and pause.
abstract final class BsColors {
  static const page = Color(0xFFF1ECE3);
  static const paper = Color(0xFFF5F2EC);
  static const card = Color(0xFFFFFFFF);
  static const hairline = Color(0xFFE6E1D6);

  static const ink = Color(0xFF181712);
  static const inkSoft = Color(0xFF5F5B52);
  static const inkFaint = Color(0xFF77736A);

  static const navy = Color(0xFF1A3A6A);
  static const navyTint = Color(0xFFE7EBF1);
  static const navySoft = Color(0xFFF3F7FB);
  static const navyLift = Color(0xFF425C84);

  static const red = Color(0xFFB33A2A);
  static const redPress = Color(0xFFB64434);
  static const amber = Color(0xFFDFA03C);
  static const warn = Color(0xFFB8631B);
  static const warnSoft = Color(0xFFFAF5EC);
  static const warnLine = Color(0xFFEBD9B8);

  // Dark surfaces (live call, guardian timeline).
  static const night = Color(0xFF13120F);
  static const nightRaised = Color(0xFF22211E);
  static const nightAmberBox = Color(0xFF272013);

  // Calm interruption (tone i).
  static const calm = Color(0xFF2A2013);
  static const calmRaised = Color(0xFF342A1D);
  static const calmChip = Color(0xFF463318);

  static const lockScreen = Color(0xFF100F14);
}

abstract final class BsFonts {
  static const sans = 'Poppins';
  static const devanagari = 'NotoSansDevanagari';
  static const serif = 'InstrumentSerif';
  static const mono = 'IBMPlexMono';
  static const fallback = [devanagari];
}

abstract final class BsRadius {
  static const card = 20.0;
  static const button = 16.0;
  static const chip = 999.0;
}
