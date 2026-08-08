import 'package:flutter_test/flutter_test.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:intl/intl.dart';

import 'package:smoke_counter/data/cubits/logs_cubit.dart';
import 'package:smoke_counter/data/cubits/settings_cubit.dart';
import 'package:smoke_counter/data/models/app_settings.dart';

void main() {
  final runId = DateTime.now().millisecondsSinceEpoch;

  group('LogsCubit', () {
    test('initial state is empty map', () async {
      HydratedBloc.storage = await HydratedStorage.build(
        storageDirectory: HydratedStorageDirectory('/tmp/logs_test_1_$runId'),
      );
      final cubit = LogsCubit();
      expect(cubit.state, isEmpty);
      cubit.close();
    });

    test('todayCount returns 0 when no logs exist', () async {
      HydratedBloc.storage = await HydratedStorage.build(
        storageDirectory: HydratedStorageDirectory('/tmp/logs_test_2_$runId'),
      );
      final cubit = LogsCubit();
      expect(cubit.todayCount, 0);
      cubit.close();
    });

    test('logCigarette increments today count', () async {
      HydratedBloc.storage = await HydratedStorage.build(
        storageDirectory: HydratedStorageDirectory('/tmp/logs_test_3_$runId'),
      );
      final cubit = LogsCubit();
      cubit.logCigarette();
      expect(cubit.todayCount, 1);
      cubit.close();
    });

    test('logCigarette multiple times increments correctly', () async {
      HydratedBloc.storage = await HydratedStorage.build(
        storageDirectory: HydratedStorageDirectory('/tmp/logs_test_4_$runId'),
      );
      final cubit = LogsCubit();
      cubit.logCigarette();
      cubit.logCigarette();
      cubit.logCigarette();
      expect(cubit.todayCount, 3);
      cubit.close();
    });

    test('undoLog decrements today count', () async {
      HydratedBloc.storage = await HydratedStorage.build(
        storageDirectory: HydratedStorageDirectory('/tmp/logs_test_5_$runId'),
      );
      final cubit = LogsCubit();
      cubit.logCigarette();
      cubit.logCigarette();
      cubit.undoLog();
      expect(cubit.todayCount, 1);
      cubit.close();
    });

    test('undoLog does not go below 0', () async {
      HydratedBloc.storage = await HydratedStorage.build(
        storageDirectory: HydratedStorageDirectory('/tmp/logs_test_6_$runId'),
      );
      final cubit = LogsCubit();
      expect(cubit.todayCount, 0);
      cubit.undoLog();
      expect(cubit.todayCount, 0);
      cubit.close();
    });

    test('totalCigarettes sums all days', () async {
      HydratedBloc.storage = await HydratedStorage.build(
        storageDirectory: HydratedStorageDirectory('/tmp/logs_test_7_$runId'),
      );
      final cubit = LogsCubit();
      final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
      cubit.emit({today: 5, '2024-01-01': 3});
      expect(cubit.totalCigarettes, 8);
      cubit.close();
    });

    test('monthTotal calculates current month', () async {
      HydratedBloc.storage = await HydratedStorage.build(
        storageDirectory: HydratedStorageDirectory('/tmp/logs_test_8_$runId'),
      );
      final cubit = LogsCubit();
      final now = DateTime.now();
      final monthKey = DateFormat('yyyy-MM').format(now);
      cubit.emit({'$monthKey-01': 5, '$monthKey-15': 3, '2024-01-01': 10});
      expect(cubit.monthTotal, 8);
      cubit.close();
    });

    test('averagePerDay calculates correctly', () async {
      HydratedBloc.storage = await HydratedStorage.build(
        storageDirectory: HydratedStorageDirectory('/tmp/logs_test_9_$runId'),
      );
      final cubit = LogsCubit();
      cubit.emit({'2024-01-01': 5, '2024-01-02': 7});
      expect(cubit.averagePerDay, 6.0);
      cubit.close();
    });

    test('sortedLogs returns most recent first', () async {
      HydratedBloc.storage = await HydratedStorage.build(
        storageDirectory: HydratedStorageDirectory('/tmp/logs_test_10_$runId'),
      );
      final cubit = LogsCubit();
      cubit.emit({'2024-01-01': 5, '2024-01-03': 7, '2024-01-02': 3});
      final sorted = cubit.sortedLogs;
      expect(sorted.first.key, '2024-01-03');
      expect(sorted.last.key, '2024-01-01');
      cubit.close();
    });
  });

  group('SettingsCubit', () {
    test('initial state has default values', () async {
      HydratedBloc.storage = await HydratedStorage.build(
        storageDirectory: HydratedStorageDirectory(
          '/tmp/settings_test_1_$runId',
        ),
      );
      final cubit = SettingsCubit();
      expect(cubit.state.packPrice, isNull);
      expect(cubit.state.cigarettesPerPack, 20);
      expect(cubit.state.isInitialized, false);
      expect(cubit.state.costPerCigarette, 0);
      cubit.close();
    });

    test('setPackPrice updates packPrice', () async {
      HydratedBloc.storage = await HydratedStorage.build(
        storageDirectory: HydratedStorageDirectory(
          '/tmp/settings_test_2_$runId',
        ),
      );
      final cubit = SettingsCubit();
      cubit.setPackPrice(10.0);
      expect(cubit.state.packPrice, 10.0);
      cubit.close();
    });

    test('setCigarettesPerPack updates count', () async {
      HydratedBloc.storage = await HydratedStorage.build(
        storageDirectory: HydratedStorageDirectory(
          '/tmp/settings_test_3_$runId',
        ),
      );
      final cubit = SettingsCubit();
      cubit.setCigarettesPerPack(25);
      expect(cubit.state.cigarettesPerPack, 25);
      cubit.close();
    });

    test('costPerCigarette calculates correctly', () async {
      HydratedBloc.storage = await HydratedStorage.build(
        storageDirectory: HydratedStorageDirectory(
          '/tmp/settings_test_4_$runId',
        ),
      );
      final cubit = SettingsCubit();
      cubit.setPackPrice(10.0);
      expect(cubit.state.costPerCigarette, 0.5);
      cubit.close();
    });

    test('isInitialized returns true when packPrice set', () async {
      HydratedBloc.storage = await HydratedStorage.build(
        storageDirectory: HydratedStorageDirectory(
          '/tmp/settings_test_5_$runId',
        ),
      );
      final cubit = SettingsCubit();
      cubit.setPackPrice(10.0);
      expect(cubit.state.isInitialized, true);
      cubit.close();
    });
  });

  group('LogsCubit serialization', () {
    test('fromJson deserializes correctly', () {
      final cubit = LogsCubit();
      final json = {'2024-01-01': 5, '2024-01-02': 3};
      final result = cubit.fromJson(json);
      expect(result['2024-01-01'], 5);
      expect(result['2024-01-02'], 3);
      cubit.close();
    });

    test('toJson serializes correctly', () {
      final cubit = LogsCubit();
      const state = {'2024-01-01': 5, '2024-01-02': 3};
      final result = cubit.toJson(state);
      expect(result['2024-01-01'], 5);
      expect(result['2024-01-02'], 3);
      cubit.close();
    });
  });

  group('SettingsCubit serialization', () {
    test('fromJson deserializes with packPrice', () {
      final cubit = SettingsCubit();
      final json = {'packPrice': 15.0, 'cigarettesPerPack': 25};
      final result = cubit.fromJson(json);
      expect(result.packPrice, 15.0);
      expect(result.cigarettesPerPack, 25);
      cubit.close();
    });

    test('fromJson deserializes without packPrice (defaults)', () {
      final cubit = SettingsCubit();
      final json = <String, dynamic>{};
      final result = cubit.fromJson(json);
      expect(result.packPrice, isNull);
      expect(result.cigarettesPerPack, 20);
      cubit.close();
    });

    test('toJson serializes correctly', () {
      final cubit = SettingsCubit();
      const state = AppSettings(packPrice: 20.0, cigarettesPerPack: 25);
      final result = cubit.toJson(state);
      expect(result['packPrice'], 20.0);
      expect(result['cigarettesPerPack'], 25);
      cubit.close();
    });
  });
}
