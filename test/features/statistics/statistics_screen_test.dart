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
    late LogsCubit logsCubit;
    late SettingsCubit settingsCubit;

    setUp(() async {
      final runId = DateTime.now().millisecondsSinceEpoch;
      HydratedBloc.storage = await HydratedStorage.build(
        storageDirectory: HydratedStorageDirectory('/tmp/statistics_test_$runId'),
      );
      logsCubit = LogsCubit();
      settingsCubit = SettingsCubit();
    });

    tearDown(() {
      logsCubit.close();
      settingsCubit.close();
    });

    Widget buildTestWidget() {
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
      await tester.pumpWidget(buildTestWidget());
      expect(find.text('Statistics'), findsOneWidget);
    });

    testWidgets('displays empty state when no logs', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget());
      expect(find.text('No data yet'), findsOneWidget);
      expect(find.text('Log your first cigarette to see statistics'), findsOneWidget);
      expect(find.byIcon(Icons.analytics_outlined), findsOneWidget);
    });

    testWidgets('displays settings icon in app bar', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget());
      expect(find.byIcon(Icons.settings_rounded), findsOneWidget);
    });

    testWidgets('displays summary cards when logs exist', (WidgetTester tester) async {
      final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
      logsCubit.emit({today: 5, '2024-01-01': 3});
      settingsCubit.setPackPrice(10.0);
      
      await tester.pumpWidget(buildTestWidget());
      
      expect(find.text('Cig/day'), findsOneWidget);
      expect(find.text('Cig/month'), findsOneWidget);
      expect(find.text('Spent until now'), findsOneWidget);
    });

    testWidgets('displays day list when logs exist', (WidgetTester tester) async {
      final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
      logsCubit.emit({today: 5, '2024-01-01': 3});
      
      await tester.pumpWidget(buildTestWidget());
      
      expect(find.text('5'), findsWidgets);
      expect(find.text('3'), findsWidgets);
    });
  });
}