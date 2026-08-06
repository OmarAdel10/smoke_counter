import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:smoke_counter/core/theme/app_theme.dart';

void main() {
  group('AppTheme constants', () {
    test('color constants match spec', () {
      expect(AppTheme.ember.toARGB32(), 0xFFE8623D);
      expect(AppTheme.charcoal.toARGB32(), 0xFF33363A);
      expect(AppTheme.warmOffWhite.toARGB32(), 0xFFF7F3EE);
      expect(AppTheme.smokeGrey.toARGB32(), 0xFF9B9D9F);
      expect(AppTheme.sage.toARGB32(), 0xFF6B9080);
      expect(AppTheme.alertRed.toARGB32(), 0xFFC1483B);
    });

    test('dark mode constants match spec', () {
      expect(AppTheme.darkBackground.toARGB32(), 0xFF1C1E20);
      expect(AppTheme.darkSurface.toARGB32(), 0xFF26292C);
      expect(AppTheme.darkPrimaryText.toARGB32(), 0xFFF0EDE8);
    });
  });

  group('lightTheme', () {
    test('uses Material 3', () {
      expect(AppTheme.lightTheme.useMaterial3, isTrue);
    });

    test('brightness is light', () {
      expect(AppTheme.lightTheme.brightness, Brightness.light);
    });

    test('scaffold background is warm off-white', () {
      expect(AppTheme.lightTheme.scaffoldBackgroundColor, AppTheme.warmOffWhite);
    });

    test('primary color is ember', () {
      expect(AppTheme.lightTheme.colorScheme.primary, AppTheme.ember);
    });

    test('secondary color is charcoal', () {
      expect(AppTheme.lightTheme.colorScheme.secondary, AppTheme.charcoal);
    });

    test('surface is warm off-white', () {
      expect(AppTheme.lightTheme.colorScheme.surface, AppTheme.warmOffWhite);
    });

    test('onSurface is charcoal', () {
      expect(AppTheme.lightTheme.colorScheme.onSurface, AppTheme.charcoal);
    });

    test('appBar background is warm off-white', () {
      expect(AppTheme.lightTheme.appBarTheme.backgroundColor, AppTheme.warmOffWhite);
    });

    test('appBar foreground is charcoal', () {
      expect(AppTheme.lightTheme.appBarTheme.foregroundColor, AppTheme.charcoal);
    });

    test('elevatedButton uses ember background', () {
      final style = AppTheme.lightTheme.elevatedButtonTheme.style;
      expect(style?.backgroundColor?.resolve({}), AppTheme.ember);
    });

    test('elevatedButton uses white foreground', () {
      final style = AppTheme.lightTheme.elevatedButtonTheme.style;
      expect(style?.foregroundColor?.resolve({}), Colors.white);
    });

    test('card theme has white background and rounded corners', () {
      final cardTheme = AppTheme.lightTheme.cardTheme;
      expect(cardTheme.color, Colors.white);
      expect(cardTheme.shape, isA<RoundedRectangleBorder>());
      expect((cardTheme.shape as RoundedRectangleBorder).borderRadius, BorderRadius.circular(16));
    });

    test('input decoration has rounded borders', () {
      final inputTheme = AppTheme.lightTheme.inputDecorationTheme;
      expect(inputTheme.border, isA<OutlineInputBorder>());
      expect((inputTheme.border as OutlineInputBorder).borderRadius, BorderRadius.circular(12));
    });

    test('text theme headlineLarge is charcoal w700', () {
      final text = AppTheme.lightTheme.textTheme.headlineLarge;
      expect(text?.color, AppTheme.charcoal);
      expect(text?.fontWeight, FontWeight.w700);
    });
  });

  group('darkTheme', () {
    test('uses Material 3', () {
      expect(AppTheme.darkTheme.useMaterial3, isTrue);
    });

    test('brightness is dark', () {
      expect(AppTheme.darkTheme.brightness, Brightness.dark);
    });

    test('scaffold background is dark background', () {
      expect(AppTheme.darkTheme.scaffoldBackgroundColor, AppTheme.darkBackground);
    });

    test('primary color is ember', () {
      expect(AppTheme.darkTheme.colorScheme.primary, AppTheme.ember);
    });

    test('secondary color is charcoal', () {
      expect(AppTheme.darkTheme.colorScheme.secondary, AppTheme.charcoal);
    });

    test('surface is dark surface', () {
      expect(AppTheme.darkTheme.colorScheme.surface, AppTheme.darkSurface);
    });

    test('onSurface is dark primary text', () {
      expect(AppTheme.darkTheme.colorScheme.onSurface, AppTheme.darkPrimaryText);
    });

    test('appBar background is dark background', () {
      expect(AppTheme.darkTheme.appBarTheme.backgroundColor, AppTheme.darkBackground);
    });

    test('appBar foreground is dark primary text', () {
      expect(AppTheme.darkTheme.appBarTheme.foregroundColor, AppTheme.darkPrimaryText);
    });

    test('elevatedButton uses ember background', () {
      final style = AppTheme.darkTheme.elevatedButtonTheme.style;
      expect(style?.backgroundColor?.resolve({}), AppTheme.ember);
    });

    test('card theme has dark surface and rounded corners', () {
      final cardTheme = AppTheme.darkTheme.cardTheme;
      expect(cardTheme.color, AppTheme.darkSurface);
      expect(cardTheme.shape, isA<RoundedRectangleBorder>());
    });

    test('text theme headlineLarge is dark primary text w700', () {
      final text = AppTheme.darkTheme.textTheme.headlineLarge;
      expect(text?.color, AppTheme.darkPrimaryText);
      expect(text?.fontWeight, FontWeight.w700);
    });
  });

  group('both themes share', () {
    test('elevatedButton has 16px border radius', () {
      final lightStyle = AppTheme.lightTheme.elevatedButtonTheme.style;
      final darkStyle = AppTheme.darkTheme.elevatedButtonTheme.style;
      
      final lightShape = lightStyle?.shape?.resolve({}) as RoundedRectangleBorder?;
      final darkShape = darkStyle?.shape?.resolve({}) as RoundedRectangleBorder?;
      
      expect(lightShape?.borderRadius, BorderRadius.circular(16));
      expect(darkShape?.borderRadius, BorderRadius.circular(16));
    });

    test('input decoration focused border is ember with width 2', () {
      final lightInput = AppTheme.lightTheme.inputDecorationTheme;
      final darkInput = AppTheme.darkTheme.inputDecorationTheme;
      
      expect(lightInput.focusedBorder, isA<OutlineInputBorder>());
      expect((lightInput.focusedBorder as OutlineInputBorder).borderSide.color, AppTheme.ember);
      expect((lightInput.focusedBorder as OutlineInputBorder).borderSide.width, 2);
      
      expect(darkInput.focusedBorder, isA<OutlineInputBorder>());
      expect((darkInput.focusedBorder as OutlineInputBorder).borderSide.color, AppTheme.ember);
      expect((darkInput.focusedBorder as OutlineInputBorder).borderSide.width, 2);
    });
  });
}