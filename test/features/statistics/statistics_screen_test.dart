import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:intl/intl.dart';

import 'package:smoke_counter/data/cubits/logs_cubit.dart';
import 'package:smoke_counter/data/cubits/settings_cubit.dart';
import 'package:smoke_counter/features/statistics/statistics_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('StatisticsView widget tests', () {
    Widget buildTestWidget({
      required LogsCubit logsCubit,
      required SettingsCubit settingsCubit,
    }) {
      return MaterialApp(
        home: MediaQuery(
          data: const MediaQueryData(size: Size(400, 800)),
          child: Scaffold(
            body: MultiBlocProvider(
              providers: [
                BlocProvider.value(value: logsCubit),
                BlocProvider.value(value: settingsCubit),
              ],
              child: const StatisticsView(),
            ),
          ),
        ),
      );
    }

    testWidgets('displays statistics title', (WidgetTester tester) async {
      final runId = DateTime.now().millisecondsSinceEpoch;
      final storage = await HydratedStorage.build(
        storageDirectory: HydratedStorageDirectory('/tmp/statistics_test_${runId}_1'),
      );
      HydratedBloc.storage = storage;
      final logsCubit = LogsCubit();
      final settingsCubit = SettingsCubit();

      await tester.pumpWidget(buildTestWidget(logsCubit: logsCubit, settingsCubit: settingsCubit));
      expect(find.text('Statistics'), findsOneWidget);

      logsCubit.close();
      settingsCubit.close();
    });

    testWidgets('displays empty state when no logs', (WidgetTester tester) async {
      final runId = DateTime.now().millisecondsSinceEpoch;
      final storage = await HydratedStorage.build(
        storageDirectory: HydratedStorageDirectory('/tmp/statistics_test_${runId}_2'),
      );
      HydratedBloc.storage = storage;
      final logsCubit = LogsCubit();
      final settingsCubit = SettingsCubit();

      await tester.pumpWidget(buildTestWidget(logsCubit: logsCubit, settingsCubit: settingsCubit));
      expect(find.text('No data yet'), findsOneWidget);
      expect(find.text('Log your first cigarette to see statistics'), findsOneWidget);
      expect(find.byIcon(Icons.analytics_outlined), findsOneWidget);

      logsCubit.close();
      settingsCubit.close();
    });

    testWidgets('displays settings icon in app bar', (WidgetTester tester) async {
      final runId = DateTime.now().millisecondsSinceEpoch;
      final storage = await HydratedStorage.build(
        storageDirectory: HydratedStorageDirectory('/tmp/statistics_test_${runId}_3'),
      );
      HydratedBloc.storage = storage;
      final logsCubit = LogsCubit();
      final settingsCubit = SettingsCubit();

      await tester.pumpWidget(buildTestWidget(logsCubit: logsCubit, settingsCubit: settingsCubit));
      expect(find.byIcon(Icons.settings_rounded), findsOneWidget);

      logsCubit.close();
      settingsCubit.close();
    });

    testWidgets('displays summary cards when logs exist', (WidgetTester tester) async {
      final runId = DateTime.now().millisecondsSinceEpoch;
      final storage = await HydratedStorage.build(
        storageDirectory: HydratedStorageDirectory('/tmp/statistics_test_${runId}_4'),
      );
      HydratedBloc.storage = storage;
      final logsCubit = LogsCubit();
      final settingsCubit = SettingsCubit();

      final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
      logsCubit.emit({today: 5, '2024-01-01': 3});
      settingsCubit.setPackPrice(10.0);

      await tester.pumpWidget(buildTestWidget(logsCubit: logsCubit, settingsCubit: settingsCubit));

      expect(find.text('Cig/day'), findsOneWidget);
      expect(find.text('Cig/month'), findsOneWidget);
      expect(find.text('Spent until now'), findsOneWidget);

      logsCubit.close();
      settingsCubit.close();
    });

    testWidgets('displays day list when logs exist', (WidgetTester tester) async {
      final runId = DateTime.now().millisecondsSinceEpoch;
      final storage = await HydratedStorage.build(
        storageDirectory: HydratedStorageDirectory('/tmp/statistics_test_${runId}_5'),
      );
      HydratedBloc.storage = storage;
      final logsCubit = LogsCubit();
      final settingsCubit = SettingsCubit();

      final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
      logsCubit.emit({today: 5, '2024-01-01': 3});

      await tester.pumpWidget(buildTestWidget(logsCubit: logsCubit, settingsCubit: settingsCubit));

      expect(find.text('5'), findsWidgets);
      expect(find.text('3'), findsWidgets);

      logsCubit.close();
      settingsCubit.close();
    });
  });
}