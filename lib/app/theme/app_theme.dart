import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_palette.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData get lightTheme => _buildTheme(Brightness.light);

  static ThemeData get darkTheme => _buildTheme(Brightness.dark);

  static ThemeData _buildTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final scheme = ColorScheme(
      brightness: brightness,
      primary: AppPalette.brand,
      onPrimary: Colors.white,
      primaryContainer: isDark
          ? const Color(0xFF134A47)
          : const Color(0xFFD6F1ED),
      onPrimaryContainer: isDark
          ? AppPalette.darkText
          : AppPalette.lightText,
      secondary: AppPalette.accent,
      onSecondary: const Color(0xFF2A1C12),
      secondaryContainer: isDark
          ? const Color(0xFF4D3321)
          : const Color(0xFFFCE7D2),
      onSecondaryContainer: isDark
          ? AppPalette.darkText
          : AppPalette.lightText,
      tertiary: const Color(0xFF6A8DFF),
      onTertiary: Colors.white,
      tertiaryContainer: isDark
          ? const Color(0xFF213774)
          : const Color(0xFFE0E7FF),
      onTertiaryContainer: isDark
          ? AppPalette.darkText
          : AppPalette.lightText,
      error: AppPalette.danger,
      onError: Colors.white,
      errorContainer: isDark
          ? const Color(0xFF4D2424)
          : const Color(0xFFF8DADA),
      onErrorContainer: isDark
          ? AppPalette.darkText
          : AppPalette.lightText,
      surface: isDark ? AppPalette.darkSurface : AppPalette.lightSurface,
      onSurface: isDark ? AppPalette.darkText : AppPalette.lightText,
      surfaceContainerHighest:
          isDark ? AppPalette.darkSurfaceMuted : AppPalette.lightSurfaceMuted,
      onSurfaceVariant:
          isDark ? AppPalette.darkTextMuted : AppPalette.lightTextMuted,
      outline: isDark ? const Color(0xFF29403F) : const Color(0xFFD7E1DD),
      outlineVariant:
          isDark ? const Color(0xFF1C3231) : const Color(0xFFE5ECE9),
      shadow: Colors.black,
      scrim: Colors.black,
      inverseSurface: isDark ? AppPalette.lightSurface : AppPalette.darkSurface,
      onInverseSurface: isDark ? AppPalette.lightText : AppPalette.darkText,
      inversePrimary: AppPalette.brandBright,
      surfaceTint: AppPalette.brand,
    );

    final textTheme = GoogleFonts.manropeTextTheme(
      ThemeData(brightness: brightness).textTheme,
    ).copyWith(
      headlineMedium: GoogleFonts.manrope(
        fontSize: 30,
        fontWeight: FontWeight.w800,
        letterSpacing: -1.2,
      ),
      headlineSmall: GoogleFonts.manrope(
        fontSize: 24,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.8,
      ),
      titleLarge: GoogleFonts.manrope(
        fontSize: 20,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.4,
      ),
      titleMedium: GoogleFonts.manrope(
        fontSize: 16,
        fontWeight: FontWeight.w700,
      ),
      bodyLarge: GoogleFonts.manrope(
        fontSize: 15,
        height: 1.35,
        fontWeight: FontWeight.w600,
      ),
      bodyMedium: GoogleFonts.manrope(
        fontSize: 14,
        height: 1.45,
        fontWeight: FontWeight.w500,
      ),
      labelLarge: GoogleFonts.manrope(
        fontSize: 14,
        fontWeight: FontWeight.w700,
      ),
      labelMedium: GoogleFonts.manrope(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.2,
      ),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor:
          isDark ? AppPalette.darkBackground : AppPalette.lightBackground,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: false,
        backgroundColor: Colors.transparent,
        foregroundColor: scheme.onSurface,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          color: scheme.onSurface,
        ),
      ),
      cardTheme: CardThemeData(
        color: scheme.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
          side: BorderSide(
            color: scheme.outlineVariant.withValues(alpha: 0.9),
          ),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: 76,
        elevation: 0,
        backgroundColor: scheme.surface.withValues(alpha: isDark ? 0.92 : 0.98),
        indicatorColor: scheme.primary.withValues(alpha: 0.14),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return textTheme.labelMedium?.copyWith(
            color: selected ? scheme.primary : scheme.onSurfaceVariant,
          );
        }),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surface,
        labelStyle: textTheme.bodyMedium?.copyWith(
          color: scheme.onSurfaceVariant,
        ),
        hintStyle: textTheme.bodyMedium?.copyWith(
          color: scheme.onSurfaceVariant.withValues(alpha: 0.78),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 18,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),
          borderSide: BorderSide(color: scheme.outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),
          borderSide: BorderSide(color: scheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),
          borderSide: BorderSide(color: scheme.primary, width: 1.4),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(56),
          elevation: 4,
          shadowColor: scheme.shadow.withValues(alpha: isDark ? 0.32 : 0.18),
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          textStyle: textTheme.labelLarge,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(54),
          elevation: 1.5,
          backgroundColor: scheme.surface,
          shadowColor: scheme.shadow.withValues(alpha: isDark ? 0.22 : 0.12),
          side: BorderSide(color: scheme.outlineVariant),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          textStyle: textTheme.labelLarge,
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: scheme.inverseSurface,
        contentTextStyle: textTheme.bodyMedium?.copyWith(
          color: scheme.onInverseSurface,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
      ),
      chipTheme: ChipThemeData(
        selectedColor: scheme.primary.withValues(alpha: 0.16),
        backgroundColor: scheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(color: scheme.outlineVariant),
        ),
        side: BorderSide(color: scheme.outlineVariant),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        labelStyle: textTheme.labelMedium?.copyWith(
          color: scheme.onSurface,
        ),
      ),
      dividerTheme: DividerThemeData(
        color: scheme.outlineVariant,
        space: 1,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
        elevation: 8,
        focusElevation: 10,
        hoverElevation: 10,
        highlightElevation: 12,
        splashColor: scheme.onPrimary.withValues(alpha: 0.12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        iconColor: scheme.onSurfaceVariant,
        titleTextStyle: textTheme.bodyLarge,
        subtitleTextStyle: textTheme.bodyMedium?.copyWith(
          color: scheme.onSurfaceVariant,
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: scheme.surface,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
      ),
    );
  }
}
