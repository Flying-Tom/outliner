import 'dart:io';
import 'package:flutter/material.dart';

/// Cross-platform font manager that automatically selects the best fonts
/// for the current operating system.
class FontManager {
  /// Returns the platform-specific font for the current OS.
  static String getPlatformFont() {
    if (Platform.isMacOS) {
      return 'SF Pro Display';
    } else if (Platform.isWindows) {
      return 'Segoe UI';
    } else if (Platform.isLinux) {
      return 'Ubuntu';
    }
    return 'Roboto';
  }

  /// Returns the CJK (Chinese, Japanese, Korean) font for the current OS.
  static String getCJKFont() {
    if (Platform.isMacOS) {
      return 'PingFang SC';
    } else if (Platform.isWindows) {
      return 'Microsoft YaHei';
    } else if (Platform.isLinux) {
      return 'Noto Sans CJK SC';
    }
    return 'Noto Sans CJK SC';
  }

  /// Returns a list of fallback fonts to use when the primary font is unavailable.
  static List<String> getFontFallback() {
    return const [
      'Noto Sans',
      'DejaVu Sans',
      'Ubuntu',
      'Arial',
      'sans-serif',
    ];
  }

  /// Returns a list of fallback CJK fonts.
  static List<String> getCJKFontFallback() {
    return const [
      'Noto Sans CJK SC',
      'Noto Sans CJK TC',
      'Noto Sans CJK JP',
      'Noto Sans CJK KR',
      'sans-serif',
    ];
  }

  /// Creates a unified [TextTheme] with cross-platform font configuration.
  static TextTheme createTextTheme(TextTheme baseTheme, {bool useCJK = true}) {
    final fontFamily = useCJK ? getCJKFont() : getPlatformFont();
    final fontFallback = useCJK ? getCJKFontFallback() : getFontFallback();

    return baseTheme.copyWith(
      displayLarge: (baseTheme.displayLarge ?? const TextStyle()).copyWith(
        fontFamily: fontFamily,
        fontFamilyFallback: fontFallback,
      ),
      displayMedium: (baseTheme.displayMedium ?? const TextStyle()).copyWith(
        fontFamily: fontFamily,
        fontFamilyFallback: fontFallback,
      ),
      displaySmall: (baseTheme.displaySmall ?? const TextStyle()).copyWith(
        fontFamily: fontFamily,
        fontFamilyFallback: fontFallback,
      ),
      headlineLarge: (baseTheme.headlineLarge ?? const TextStyle()).copyWith(
        fontFamily: fontFamily,
        fontFamilyFallback: fontFallback,
      ),
      headlineMedium: (baseTheme.headlineMedium ?? const TextStyle()).copyWith(
        fontFamily: fontFamily,
        fontFamilyFallback: fontFallback,
      ),
      headlineSmall: (baseTheme.headlineSmall ?? const TextStyle()).copyWith(
        fontFamily: fontFamily,
        fontFamilyFallback: fontFallback,
      ),
      titleLarge: (baseTheme.titleLarge ?? const TextStyle()).copyWith(
        fontFamily: fontFamily,
        fontFamilyFallback: fontFallback,
      ),
      titleMedium: (baseTheme.titleMedium ?? const TextStyle()).copyWith(
        fontFamily: fontFamily,
        fontFamilyFallback: fontFallback,
      ),
      titleSmall: (baseTheme.titleSmall ?? const TextStyle()).copyWith(
        fontFamily: fontFamily,
        fontFamilyFallback: fontFallback,
      ),
      bodyLarge: (baseTheme.bodyLarge ?? const TextStyle()).copyWith(
        fontFamily: fontFamily,
        fontFamilyFallback: fontFallback,
      ),
      bodyMedium: (baseTheme.bodyMedium ?? const TextStyle()).copyWith(
        fontFamily: fontFamily,
        fontFamilyFallback: fontFallback,
      ),
      bodySmall: (baseTheme.bodySmall ?? const TextStyle()).copyWith(
        fontFamily: fontFamily,
        fontFamilyFallback: fontFallback,
      ),
      labelLarge: (baseTheme.labelLarge ?? const TextStyle()).copyWith(
        fontFamily: fontFamily,
        fontFamilyFallback: fontFallback,
      ),
      labelMedium: (baseTheme.labelMedium ?? const TextStyle()).copyWith(
        fontFamily: fontFamily,
        fontFamilyFallback: fontFallback,
      ),
      labelSmall: (baseTheme.labelSmall ?? const TextStyle()).copyWith(
        fontFamily: fontFamily,
        fontFamilyFallback: fontFallback,
      ),
    );
  }

  /// Creates an [AppBarTheme] with the provided [TextTheme].
  static AppBarTheme createAppBarTheme(TextTheme textTheme) {
    return AppBarTheme(
      titleTextStyle: textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.w600,
      ),
    );
  }

  /// Returns platform information as a string for debugging purposes.
  static String getPlatformInfo() {
    String osName = '';
    if (Platform.isMacOS) osName = 'macOS';
    if (Platform.isWindows) osName = 'Windows';
    if (Platform.isLinux) osName = 'Linux';

    return '''
Platform: $osName
Primary Font: ${getPlatformFont()}
CJK Font: ${getCJKFont()}
    ''';
  }
}
