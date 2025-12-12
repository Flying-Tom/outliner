import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:outliner/utils/font_manager.dart';

void main() {
  group('FontManager Tests', () {
    test('getPlatformFont returns appropriate font for current platform', () {
      final font = FontManager.getPlatformFont();
      expect(font, isNotEmpty);

      if (Platform.isMacOS) {
        expect(font, equals('SF Pro Display'));
      } else if (Platform.isWindows) {
        expect(font, equals('Segoe UI'));
      } else if (Platform.isLinux) {
        expect(font, equals('Ubuntu'));
      }
    });

    test('getCJKFont returns appropriate CJK font for current platform', () {
      final font = FontManager.getCJKFont();
      expect(font, isNotEmpty);

      if (Platform.isMacOS) {
        expect(font, equals('PingFang SC'));
      } else if (Platform.isWindows) {
        expect(font, equals('Microsoft YaHei'));
      } else if (Platform.isLinux) {
        expect(font, equals('Noto Sans CJK SC'));
      }
    });

    test('getFontFallback returns non-empty list', () {
      final fallback = FontManager.getFontFallback();
      expect(fallback, isNotEmpty);
      expect(fallback.length, greaterThanOrEqualTo(3));
    });

    test('getCJKFontFallback returns non-empty list', () {
      final fallback = FontManager.getCJKFontFallback();
      expect(fallback, isNotEmpty);
      expect(fallback.length, greaterThanOrEqualTo(3));
    });

    test('getPlatformInfo returns valid info string', () {
      final info = FontManager.getPlatformInfo();
      expect(info, isNotEmpty);
      expect(info, contains('Platform:'));
      expect(info, contains('Font:'));
    });

    test('createTextTheme returns valid TextTheme with fonts', () {
      final baseTheme = ThemeData.light().textTheme;
      final customTheme = FontManager.createTextTheme(baseTheme, useCJK: false);

      expect(customTheme.bodyLarge, isNotNull);
      expect(customTheme.bodyLarge?.fontFamily, isNotEmpty);
      expect(customTheme.bodyLarge?.fontFamilyFallback, isNotEmpty);
    });

    test('createTextTheme CJK variant returns valid TextTheme with CJK fonts',
        () {
      final baseTheme = ThemeData.light().textTheme;
      final customTheme = FontManager.createTextTheme(baseTheme, useCJK: true);

      expect(customTheme.bodyLarge, isNotNull);
      expect(customTheme.bodyLarge?.fontFamily, isNotEmpty);
      expect(customTheme.bodyLarge?.fontFamilyFallback, isNotEmpty);
    });

    test('createAppBarTheme returns valid AppBarTheme', () {
      final baseTheme = ThemeData.light().textTheme;
      final textTheme = FontManager.createTextTheme(baseTheme, useCJK: true);
      final appBarTheme = FontManager.createAppBarTheme(textTheme);

      expect(appBarTheme, isNotNull);
      expect(appBarTheme.titleTextStyle, isNotNull);
    });

    test('All TextTheme styles have fonts configured', () {
      final baseTheme = ThemeData.light().textTheme;
      final customTheme = FontManager.createTextTheme(baseTheme, useCJK: true);

      final styles = [
        customTheme.displayLarge,
        customTheme.displayMedium,
        customTheme.displaySmall,
        customTheme.headlineLarge,
        customTheme.headlineMedium,
        customTheme.headlineSmall,
        customTheme.titleLarge,
        customTheme.titleMedium,
        customTheme.titleSmall,
        customTheme.bodyLarge,
        customTheme.bodyMedium,
        customTheme.bodySmall,
        customTheme.labelLarge,
        customTheme.labelMedium,
        customTheme.labelSmall,
      ];

      for (final style in styles) {
        expect(style?.fontFamily, isNotEmpty,
            reason: 'Style should have fontFamily set');
        expect(style?.fontFamilyFallback, isNotEmpty,
            reason: 'Style should have fontFamilyFallback set');
      }
    });
  });
}
