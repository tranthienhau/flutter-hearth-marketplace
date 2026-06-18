import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Hearth design tokens - warm, human, earthy direction.
/// Pulled from the Hearth iOS design (Bricolage Grotesque + Hanken Grotesk).
class HC {
  // Core
  static const ink = Color(0xFF2B2520); // warm near-black text
  static const inkSoft = Color(0xFF5C5347);
  static const muted = Color(0xFF8C8276); // secondary text
  static const mutedLight = Color(0xFFA39A8C);
  static const hairline = Color(0xFFEBE1D3);

  // Surfaces
  static const bg = Color(0xFFFAF6EF); // app background (cream)
  static const card = Color(0xFFFFFFFF);
  static const surfaceWarm = Color(0xFFF0E7DA);
  static const surfaceSand = Color(0xFFF4E3D8);

  // Brand accents
  static const terracotta = Color(0xFFBE5B3A); // primary action
  static const terracottaDeep = Color(0xFFB5603E);
  static const sage = Color(0xFF5B7560); // trust / verified
  static const forest = Color(0xFF3F5946);
  static const gold = Color(0xFFD99A3C); // rating star / featured
  static const peach = Color(0xFFE9B187);

  static const sageTint = Color(0xFFE3EBE2);
  static const goldTint = Color(0xFFFBEFE2);
}

class HearthTheme {
  static ThemeData build() {
    final base = ThemeData.light(useMaterial3: true);
    final textTheme = GoogleFonts.hankenGroteskTextTheme(base.textTheme).apply(
      bodyColor: HC.ink,
      displayColor: HC.ink,
    );

    return base.copyWith(
      scaffoldBackgroundColor: HC.bg,
      colorScheme: base.colorScheme.copyWith(
        primary: HC.terracotta,
        secondary: HC.sage,
        surface: HC.card,
        onPrimary: Colors.white,
        onSurface: HC.ink,
      ),
      textTheme: textTheme,
      appBarTheme: const AppBarTheme(
        backgroundColor: HC.bg,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        foregroundColor: HC.ink,
      ),
      dividerColor: HC.hairline,
      splashColor: HC.terracotta.withValues(alpha: 0.06),
      highlightColor: HC.terracotta.withValues(alpha: 0.04),
    );
  }

  /// Bricolage Grotesque display headings.
  static TextStyle display(double size, {FontWeight w = FontWeight.w600, Color? color}) =>
      GoogleFonts.bricolageGrotesque(
        fontSize: size,
        fontWeight: w,
        height: 1.05,
        letterSpacing: -0.4,
        color: color ?? HC.ink,
      );

  static TextStyle body(double size, {FontWeight w = FontWeight.w400, Color? color, double h = 1.35}) =>
      GoogleFonts.hankenGrotesk(
        fontSize: size,
        fontWeight: w,
        height: h,
        color: color ?? HC.ink,
      );
}
