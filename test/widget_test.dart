import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

import 'package:smoke_counter/data/cubits/logs_cubit.dart';
import 'package:smoke_counter/data/cubits/settings_cubit.dart';
import 'package:smoke_counter/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('App Navigation & Routing', () {
    Widget buildTestWidget({
      required LogsCubit logsCubit,
      required SettingsCubit settingsCubit,
      Map<String, Widget Function(BuildContext)>? routes,
    }) {
      return MaterialApp(
        home: MultiBlocProvider(
          providers: [
            BlocProvider.value(value: logsCubit),
            BlocProvider.value(value: settingsCubit),
          ],
          child: const AppEntryPoint(),
        ),
        routes: routes ?? {
          '/settings': (_) => const Scaffold(body: Text('Settings')),
        },
      );
    }

    testWidgets('AppEntryPoint shows Onboarding when packPrice not set', (WidgetTester tester) async {
      final runId = DateTime.now().millisecondsSinceEpoch;
      final storage = await HydratedStorage.build(
        storageDirectory: HydratedStorageDirectory('/tmp/nav_test_${runId}_1'),
      );
      HydratedBloc.storage = storage;
      final logsCubit = LogsCubit();
      final settingsCubit = SettingsCubit();

      await tester.pumpWidget(buildTestWidget(logsCubit: logsCubit, settingsCubit: settingsCubit));
      expect(find.text('Welcome to Smoke Counter'), findsOneWidget);
      expect(find.text('How much does a pack of cigarettes cost?'), findsOneWidget);

      logsCubit.close();
      settingsCubit.close();
    });

    testWidgets('AppEntryPoint shows MainNavigation when packPrice is set', (WidgetTester tester) async {
      final runId = DateTime.now().millisecondsSinceEpoch;
      final storage = await HydratedStorage.build(
        storageDirectory: HydratedStorageDirectory('/tmp/nav_test_${runId}_2'),
      );
      HydratedBloc.storage = storage;
      final logsCubit = LogsCubit();
      final settingsCubit = SettingsCubit();
      settingsCubit.setPackPrice(10.0);

      await tester.pumpWidget(buildTestWidget(logsCubit: logsCubit, settingsCubit: settingsCubit));
      expect(find.text('Counter'), findsOneWidget);
      expect(find.text('Statistics'), findsOneWidget);

      logsCubit.close();
      settingsCubit.close();
    });

    testWidgets('Onboarding submits pack price and navigates to main', (WidgetTester tester) async {
      final runId = DateTime.now().millisecondsSinceEpoch;
      final storage = await HydratedStorage.build(
        storageDirectory: HydratedStorageDirectory('/tmp/nav_test_${runId}_3'),
      );
      HydratedBloc.storage = storage;
      final logsCubit = LogsCubit();
      final settingsCubit = SettingsCubit();

      await tester.pumpWidget(buildTestWidget(logsCubit: logsCubit, settingsCubit: settingsCubit));

      expect(find.text('Welcome to Smoke Counter'), findsOneWidget);

      await tester.enterText(find.byType(TextFormField), '12.50');
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();

      expect(find.text('Counter'), findsOneWidget);
      expect(find.text('Statistics'), findsOneWidget);
      expect(settingsCubit.state.packPrice, 12.50);

      logsCubit.close();
      settingsCubit.close();
    });

    testWidgets('Bottom navigation switches between Counter and Statistics', (WidgetTester tester) async {
      final runId = DateTime.now().millisecondsSinceEpoch;
      final storage = await HydratedStorage.build(
        storageDirectory: HydratedStorageDirectory('/tmp/nav_test_${runId}_4'),
      );
      HydratedBloc.storage = storage;
      final logsCubit = LogsCubit();
      final settingsCubit = SettingsCubit();
      settingsCubit.setPackPrice(10.0);

      await tester.pumpWidget(buildTestWidget(logsCubit: logsCubit, settingsCubit: settingsCubit));

      expect(find.byIcon(Icons.local_fire_department_rounded), findsOneWidget);
      expect(find.byIcon(Icons.analytics_rounded), findsOneWidget);

      await tester.tap(find.text('Statistics').first);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.byWidgetPredicate((w) => w is AppBar && w.title is Text && (w.title as Text).data == 'Statistics'), findsOneWidget);
      expect(find.text('No data yet'), findsOneWidget);

      await tester.tap(find.text('Counter').first);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.byIcon(Icons.local_fire_department_rounded), findsOneWidget);
      expect(find.text('Cigarettes Today'), findsOneWidget);

      logsCubit.close();
      settingsCubit.close();
    });

    testWidgets('Settings accessible from Counter screen via app bar', (WidgetTester tester) async {
      final runId = DateTime.now().millisecondsSinceEpoch;
      final storage = await HydratedStorage.build(
        storageDirectory: HydratedStorageDirectory('/tmp/nav_test_${runId}_5'),
      );
      HydratedBloc.storage = storage;
      final logsCubit = LogsCubit();
      final settingsCubit = SettingsCubit();
      settingsCubit.setPackPrice(10.0);

      await tester.pumpWidget(buildTestWidget(logsCubit: logsCubit, settingsCubit: settingsCubit));

      await tester.tap(find.byIcon(Icons.settings_rounded));
      await tester.pumpAndSettle();

      expect(find.text('Settings Screen'), findsOneWidget);

      logsCubit.close();
      settingsCubit.close();
    });

    testWidgets('Settings accessible from Statistics screen via app bar', (WidgetTester tester) async {
      final runId = DateTime.now().millisecondsSinceEpoch;
      final storage = await HydratedStorage.build(
        storageDirectory: HydratedStorageDirectory('/tmp/nav_test_${runId}_6'),
      );
      HydratedBloc.storage = storage;
      final logsCubit = LogsCubit();
      final settingsCubit = SettingsCubit();
      settingsCubit.setPackPrice(10.0);

      await tester.pumpWidget(buildTestWidget(logsCubit: logsCubit, settingsCubit: settingsCubit));

      await tester.tap(find.text('Statistics'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      await tester.tap(find.byIcon(Icons.settings_rounded));
      await tester.pumpAndSettle();

      expect(find.text('Settings Screen'), findsOneWidget);

      logsCubit.close();
      settingsCubit.close();
    });

    testWidgets('Counter log button increments and updates spend', (WidgetTester tester) async {
      final runId = DateTime.now().millisecondsSinceEpoch;
      final storage = await HydratedStorage.build(
        storageDirectory: HydratedStorageDirectory('/tmp/nav_test_${runId}_7'),
      );
      HydratedBloc.storage = storage;
      final logsCubit = LogsCubit();
      final settingsCubit = SettingsCubit();
      settingsCubit.setPackPrice(20.0);

      await tester.pumpWidget(buildTestWidget(logsCubit: logsCubit, settingsCubit: settingsCubit));

      expect(find.text('Spent today: EGP 0.00'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.add_rounded));
      await tester.pump();
      await tester.tap(find.byIcon(Icons.add_rounded));
      await tester.pump();
      await tester.tap(find.byIcon(Icons.add_rounded));
      await tester.pump();

      expect(find.text('3'), findsOneWidget);
      expect(find.text('Spent today: EGP 3.00'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.remove_rounded));
      await tester.pump();

      expect(find.text('2'), findsOneWidget);
      expect(find.text('Spent today: EGP 2.00'), findsOneWidget);

      logsCubit.close();
      settingsCubit.close();
    });

    testWidgets('Onboarding validation shows error for empty input', (WidgetTester tester) async {
      final runId = DateTime.now().millisecondsSinceEpoch;
      final storage = await HydratedStorage.build(
        storageDirectory: HydratedStorageDirectory('/tmp/nav_test_${runId}_8'),
      );
      HydratedBloc.storage = storage;
      final logsCubit = LogsCubit();
      final settingsCubit = SettingsCubit();

      await tester.pumpWidget(buildTestWidget(logsCubit: logsCubit, settingsCubit: settingsCubit));

      await tester.tap(find.text('Continue'));
      await tester.pump();

      expect(find.text('Please enter a price'), findsOneWidget);

      logsCubit.close();
      settingsCubit.close();
    });

    testWidgets('Onboarding validation shows error for invalid number', (WidgetTester tester) async {
      final runId = DateTime.now().millisecondsSinceEpoch;
      final storage = await HydratedStorage.build(
        storageDirectory: HydratedStorageDirectory('/tmp/nav_test_${runId}_9'),
      );
      HydratedBloc.storage = storage;
      final logsCubit = LogsCubit();
      final settingsCubit = SettingsCubit();

      await tester.pumpWidget(buildTestWidget(logsCubit: logsCubit, settingsCubit: settingsCubit));

      await tester.enterText(find.byType(TextFormField), 'abc');
      await tester.tap(find.text('Continue'));
      await tester.pump();

      expect(find.text('Enter a valid price'), findsOneWidget);

      logsCubit.close();
      settingsCubit.close();
    });

    testWidgets('Onboarding accepts decimal comma', (WidgetTester tester) async {
      final runId = DateTime.now().millisecondsSinceEpoch;
      final storage = await HydratedStorage.build(
        storageDirectory: HydratedStorageDirectory('/tmp/nav_test_${runId}_10'),
      );
      HydratedBloc.storage = storage;
      final logsCubit = LogsCubit();
      final settingsCubit = SettingsCubit();

      await tester.pumpWidget(buildTestWidget(logsCubit: logsCubit, settingsCubit: settingsCubit));

      await tester.enterText(find.byType(TextFormField), '10,50');
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();

      expect(settingsCubit.state.packPrice, 10.50);
      expect(find.text('Counter'), findsOneWidget);

      logsCubit.close();
      settingsCubit.close();
    });
  });
}