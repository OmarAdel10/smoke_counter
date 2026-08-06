import 'package:flutter_test/flutter_test.dart';

import 'package:smoke_counter/data/models/app_settings.dart';
import 'package:smoke_counter/data/models/daily_log.dart';

void main() {
  group('DailyLog model', () {
    test('creates with required fields', () {
      const log = DailyLog(dateKey: '2024-01-15', count: 5);
      expect(log.dateKey, '2024-01-15');
      expect(log.count, 5);
    });

    test('copyWith preserves unchanged fields', () {
      const original = DailyLog(dateKey: '2024-01-15', count: 5);
      
      // Copy with new dateKey only
      final copiedDate = original.copyWith(dateKey: '2024-01-16');
      expect(copiedDate.dateKey, '2024-01-16');
      expect(copiedDate.count, 5);
      
      // Copy with new count only
      final copiedCount = original.copyWith(count: 10);
      expect(copiedCount.dateKey, '2024-01-15');
      expect(copiedCount.count, 10);
      
      // Copy with both
      final copiedBoth = original.copyWith(dateKey: '2024-01-16', count: 10);
      expect(copiedBoth.dateKey, '2024-01-16');
      expect(copiedBoth.count, 10);
      
      // Copy with no changes
      final copiedNone = original.copyWith();
      expect(copiedNone.dateKey, '2024-01-15');
      expect(copiedNone.count, 5);
    });

    test('equatable equality works', () {
      const log1 = DailyLog(dateKey: '2024-01-15', count: 5);
      const log2 = DailyLog(dateKey: '2024-01-15', count: 5);
      const log3 = DailyLog(dateKey: '2024-01-16', count: 5);
      const log4 = DailyLog(dateKey: '2024-01-15', count: 10);
      
      expect(log1 == log2, isTrue);
      expect(log1 == log3, isFalse);
      expect(log1 == log4, isFalse);
      expect(log1.props, [log1.dateKey, log1.count]);
    });
  });

  group('AppSettings model', () {
    test('creates with defaults', () {
      const settings = AppSettings();
      expect(settings.packPrice, isNull);
      expect(settings.cigarettesPerPack, 20);
      expect(settings.isInitialized, isFalse);
      expect(settings.costPerCigarette, 0);
    });

    test('creates with custom values', () {
      const settings = AppSettings(packPrice: 15.0, cigarettesPerPack: 25);
      expect(settings.packPrice, 15.0);
      expect(settings.cigarettesPerPack, 25);
      expect(settings.isInitialized, isTrue);
      expect(settings.costPerCigarette, 0.6);
    });

    test('copyWith preserves unchanged fields', () {
      const original = AppSettings(packPrice: 15.0, cigarettesPerPack: 25);
      
      // Copy with new packPrice only
      final copiedPrice = original.copyWith(packPrice: 20.0);
      expect(copiedPrice.packPrice, 20.0);
      expect(copiedPrice.cigarettesPerPack, 25);
      
      // Copy with new cigarettesPerPack only
      final copiedCount = original.copyWith(cigarettesPerPack: 30);
      expect(copiedCount.packPrice, 15.0);
      expect(copiedCount.cigarettesPerPack, 30);
      
      // Copy with both
      final copiedBoth = original.copyWith(packPrice: 20.0, cigarettesPerPack: 30);
      expect(copiedBoth.packPrice, 20.0);
      expect(copiedBoth.cigarettesPerPack, 30);
      
      // Copy with no changes
      final copiedNone = original.copyWith();
      expect(copiedNone.packPrice, 15.0);
      expect(copiedNone.cigarettesPerPack, 25);
      
      // Copy with clearPackPrice to set to null
      final copiedNull = original.copyWith(clearPackPrice: true);
      expect(copiedNull.packPrice, isNull);
      expect(copiedNull.isInitialized, isFalse);
    });

    test('costPerCigarette calculates correctly', () {
      expect(const AppSettings(packPrice: 20.0, cigarettesPerPack: 20).costPerCigarette, 1.0);
      expect(const AppSettings(packPrice: 10.0, cigarettesPerPack: 20).costPerCigarette, 0.5);
      expect(const AppSettings(packPrice: 10.0, cigarettesPerPack: 25).costPerCigarette, 0.4);
      expect(const AppSettings(packPrice: 15.50, cigarettesPerPack: 20).costPerCigarette, 0.775);
    });

    test('costPerCigarette returns 0 when packPrice null or zero', () {
      expect(const AppSettings().costPerCigarette, 0);
      expect(const AppSettings(packPrice: 0).costPerCigarette, 0);
      expect(const AppSettings(packPrice: -5).costPerCigarette, 0);
    });

    test('isInitialized returns true only when packPrice > 0', () {
      expect(const AppSettings().isInitialized, isFalse);
      expect(const AppSettings(packPrice: 0).isInitialized, isFalse);
      expect(const AppSettings(packPrice: -1).isInitialized, isFalse);
      expect(const AppSettings(packPrice: 0.01).isInitialized, isTrue);
      expect(const AppSettings(packPrice: 10.0).isInitialized, isTrue);
    });

    test('equatable equality works', () {
      const s1 = AppSettings(packPrice: 15.0, cigarettesPerPack: 25);
      const s2 = AppSettings(packPrice: 15.0, cigarettesPerPack: 25);
      const s3 = AppSettings(packPrice: 20.0, cigarettesPerPack: 25);
      const s4 = AppSettings(packPrice: 15.0, cigarettesPerPack: 30);
      
      expect(s1 == s2, isTrue);
      expect(s1 == s3, isFalse);
      expect(s1 == s4, isFalse);
      expect(s1.props, [s1.packPrice, s1.cigarettesPerPack]);
    });
  });
}