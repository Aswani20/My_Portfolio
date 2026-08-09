import 'package:flutter/material.dart';
import 'package:portfolio_app/utils/core/app_strings.dart';

class AppColorsScheme extends ThemeExtension<AppColorsScheme> {
  final Color background;
  final Color surface;
  final Color primary;
  final Color accent;
  final Color textPrimary;
  final Color textSecondary;
  final Color border;

  const AppColorsScheme({
    required this.background,
    required this.surface,
    required this.primary,
    required this.accent,
    required this.textPrimary,
    required this.textSecondary,
    required this.border,
  });

  @override
  AppColorsScheme copyWith({
    Color? background,
    Color? surface,
    Color? primary,
    Color? accent,
    Color? textPrimary,
    Color? textSecondary,
    Color? border,
  }) {
    return AppColorsScheme(
      background: background ?? this.background,
      surface: surface ?? this.surface,
      primary: primary ?? this.primary,
      accent: accent ?? this.accent,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      border: border ?? this.border,
    );
  }

  @override
  AppColorsScheme lerp(ThemeExtension<AppColorsScheme>? other, double t) {
    if (other is! AppColorsScheme) return this;
    return AppColorsScheme(
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      primary: Color.lerp(primary, other.primary, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      border: Color.lerp(border, other.border, t)!,
    );
  }
}

const AppColorsScheme lightColors = AppColorsScheme(
  background: Color(0xFFFFFFFF),
  surface: Color(0xFFF7F7F9),
  primary: Color(0xFF1A1A2E),
  accent: Color(0xFF4361EE),
  textPrimary: Color(0xFF1A1A2E),
  textSecondary: Color(0xFF6B7280),
  border: Color(0xFFE5E7EB),
);

const AppColorsScheme darkColors = AppColorsScheme(
  background: Color(0xFF0F0F1A),
  surface: Color(0xFF1B1B2E),
  primary: Color(0xFFF5F5F7),
  accent: Color(0xFF6C8CFF),
  textPrimary: Color(0xFFF5F5F7),
  textSecondary: Color(0xFFA0A0B4),
  border: Color(0xFF2E2E42),
);

extension AppColorsX on BuildContext {
  AppColorsScheme get colors => Theme.of(this).extension<AppColorsScheme>()!;
}

class AppTextStyles {
  static const TextStyle h1 = TextStyle(fontSize: 56, fontWeight: FontWeight.w700, height: 1.1);
  static const TextStyle h2 = TextStyle(fontSize: 36, fontWeight: FontWeight.w700, height: 1.2);
  static const TextStyle h3 = TextStyle(fontSize: 24, fontWeight: FontWeight.w600);
  static const TextStyle body = TextStyle(fontSize: 16, fontWeight: FontWeight.w400, height: 1.6);
  static const TextStyle bodyLarge = TextStyle(fontSize: 20, fontWeight: FontWeight.w400, height: 1.5);
  static const TextStyle button = TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white);
  static const TextStyle navLink = TextStyle(fontSize: 15, fontWeight: FontWeight.w500);
}

class AppBreakpoints {
  static const double mobile = 600;
  static const double tablet = 1024;

  static bool isMobile(double width) => width < mobile;
  static bool isTablet(double width) => width >= mobile && width < tablet;
  static bool isDesktop(double width) => width >= tablet;
}

class AppSpacing {
  static const double sectionVerticalPadding = 100;
  static const double sectionVerticalPaddingMobile = 60;
  static const double sectionVerticalPaddingCompact = 56;
  static const double sectionVerticalPaddingCompactMobile = 40;
  static const double maxContentWidth = 1200;
  static const double horizontalPaddingDesktop = 64;
  static const double horizontalPaddingMobile = 20;
  static const double navBarHeight = 72;
}

ThemeData _buildTheme(Brightness brightness, AppColorsScheme colors) {
  final base = ThemeData(brightness: brightness);
  return ThemeData(
    useMaterial3: true,
    brightness: brightness,
    scaffoldBackgroundColor: colors.background,
    fontFamily: AppStrings.fontFamily,
    colorScheme: ColorScheme.fromSeed(
      seedColor: colors.accent,
      brightness: brightness,
      background: colors.background,
    ),
    textTheme: base.textTheme.apply(
      bodyColor: colors.textPrimary,
      displayColor: colors.textPrimary,
    ),
    extensions: [colors],
  );
}

ThemeData buildLightTheme() => _buildTheme(Brightness.light, lightColors);

ThemeData buildDarkTheme() => _buildTheme(Brightness.dark, darkColors);
