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
    late LogsCubit logsCubit;
    late SettingsCubit settingsCubit;

    setUp(() async {
      final runId = DateTime.now().millisecondsSinceEpoch;
      HydratedBloc.storage = await HydratedStorage.build(
        storageDirectory: HydratedStorageDirectory('/tmp/nav_test_$runId'),
      );
      logsCubit = LogsCubit();
      settingsCubit = SettingsCubit();
    });

    tearDown(() {
      logsCubit.close();
      settingsCubit.close();
    });

    testWidgets('AppEntryPoint shows Onboarding when packPrice not set', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MultiBlocProvider(
            providers: [
              BlocProvider.value(value: logsCubit),
              BlocProvider.value(value: settingsCubit),
            ],
            child: const AppEntryPoint(),
          ),
        ),
      );
      expect(find.text('Welcome to Smoke Counter'), findsOneWidget);
      expect(find.text('How much does a pack of cigarettes cost?'), findsOneWidget);
    });

    testWidgets('AppEntryPoint shows MainNavigation when packPrice is set', (WidgetTester tester) async {
      settingsCubit.setPackPrice(10.0);
      await tester.pumpWidget(
        MaterialApp(
          home: MultiBlocProvider(
            providers: [
              BlocProvider.value(value: logsCubit),
              BlocProvider.value(value: settingsCubit),
            ],
            child: const AppEntryPoint(),
          ),
          routes: {
            '/settings': (_) => const Scaffold(body: Text('Settings')),
          },
        ),
      );
      expect(find.text('Counter'), findsOneWidget); // Bottom nav label
      expect(find.text('Statistics'), findsOneWidget); // Bottom nav label
    });

    testWidgets('Onboarding submits pack price and navigates to main', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MultiBlocProvider(
            providers: [
              BlocProvider.value(value: logsCubit),
              BlocProvider.value(value: settingsCubit),
            ],
            child: const AppEntryPoint(),
          ),
          routes: {
            '/settings': (_) => const Scaffold(body: Text('Settings')),
          },
        ),
      );

      // Verify we're on onboarding
      expect(find.text('Welcome to Smoke Counter'), findsOneWidget);

      // Enter pack price
      await tester.enterText(find.byType(TextFormField), '12.50');
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();

      // Should navigate to main app (Counter tab)
      expect(find.text('Counter'), findsOneWidget);
      expect(find.text('Statistics'), findsOneWidget);

      // Verify settings saved
      expect(settingsCubit.state.packPrice, 12.50);
    });

    testWidgets('Bottom navigation switches between Counter and Statistics', (WidgetTester tester) async {
      settingsCubit.setPackPrice(10.0);
      await tester.pumpWidget(
        MaterialApp(
          home: MultiBlocProvider(
            providers: [
              BlocProvider.value(value: logsCubit),
              BlocProvider.value(value: settingsCubit),
            ],
            child: const AppEntryPoint(),
          ),
          routes: {
            '/settings': (_) => const Scaffold(body: Text('Settings')),
          },
        ),
      );

      // Start on Counter tab
      expect(find.byIcon(Icons.local_fire_department_rounded), findsOneWidget);
      expect(find.byIcon(Icons.analytics_rounded), findsOneWidget);

      // Tap Statistics tab
      await tester.tap(find.text('Statistics').first);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300)); // Animation

      // Verify Statistics screen shown - AppBar title
      expect(find.byWidgetPredicate((w) => w is AppBar && w.title is Text && (w.title as Text).data == 'Statistics'), findsOneWidget);
      expect(find.text('No data yet'), findsOneWidget); // Empty state

      // Tap Counter tab
      await tester.tap(find.text('Counter').first);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      // Verify Counter screen shown
      expect(find.byIcon(Icons.local_fire_department_rounded), findsOneWidget);
      expect(find.text('Cigarettes Today'), findsOneWidget);
    });

    testWidgets('Settings accessible from Counter screen via app bar', (WidgetTester tester) async {
      settingsCubit.setPackPrice(10.0);
      await tester.pumpWidget(
        MaterialApp(
          home: MultiBlocProvider(
            providers: [
              BlocProvider.value(value: logsCubit),
              BlocProvider.value(value: settingsCubit),
            ],
            child: const AppEntryPoint(),
          ),
          routes: {
            '/settings': (_) => const Scaffold(body: Text('Settings Screen')),
          },
        ),
      );

      // Tap settings icon
      await tester.tap(find.byIcon(Icons.settings_rounded));
      await tester.pumpAndSettle();

      expect(find.text('Settings Screen'), findsOneWidget);
    });

    testWidgets('Settings accessible from Statistics screen via app bar', (WidgetTester tester) async {
      settingsCubit.setPackPrice(10.0);
      await tester.pumpWidget(
        MaterialApp(
          home: MultiBlocProvider(
            providers: [
              BlocProvider.value(value: logsCubit),
              BlocProvider.value(value: settingsCubit),
            ],
            child: const AppEntryPoint(),
          ),
          routes: {
            '/settings': (_) => const Scaffold(body: Text('Settings Screen')),
          },
        ),
      );

      // Switch to Statistics tab
      await tester.tap(find.text('Statistics'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      // Tap settings icon
      await tester.tap(find.byIcon(Icons.settings_rounded));
      await tester.pumpAndSettle();

      expect(find.text('Settings Screen'), findsOneWidget);
    });

    testWidgets('Counter log button increments and updates spend', (WidgetTester tester) async {
      settingsCubit.setPackPrice(20.0); // 20/20 = 1.0 per cigarette
      await tester.pumpWidget(
        MaterialApp(
          home: MultiBlocProvider(
            providers: [
              BlocProvider.value(value: logsCubit),
              BlocProvider.value(value: settingsCubit),
            ],
            child: const AppEntryPoint(),
          ),
          routes: {
            '/settings': (_) => const Scaffold(body: Text('Settings')),
          },
        ),
      );

      // Initial spend
      expect(find.text('Spent today: EGP 0.00'), findsOneWidget);

      // Log 3 cigarettes
      await tester.tap(find.byIcon(Icons.add_rounded));
      await tester.pump();
      await tester.tap(find.byIcon(Icons.add_rounded));
      await tester.pump();
      await tester.tap(find.byIcon(Icons.add_rounded));
      await tester.pump();

      expect(find.text('3'), findsOneWidget);
      expect(find.text('Spent today: EGP 3.00'), findsOneWidget);

      // Undo one
      await tester.tap(find.byIcon(Icons.remove_rounded));
      await tester.pump();

      expect(find.text('2'), findsOneWidget);
      expect(find.text('Spent today: EGP 2.00'), findsOneWidget);
    });

    testWidgets('Onboarding validation shows error for empty input', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MultiBlocProvider(
            providers: [
              BlocProvider.value(value: logsCubit),
              BlocProvider.value(value: settingsCubit),
            ],
            child: const AppEntryPoint(),
          ),
        ),
      );

      // Try to continue without entering price
      await tester.tap(find.text('Continue'));
      await tester.pump();

      expect(find.text('Please enter a price'), findsOneWidget);
    });

    testWidgets('Onboarding validation shows error for invalid number', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MultiBlocProvider(
            providers: [
              BlocProvider.value(value: logsCubit),
              BlocProvider.value(value: settingsCubit),
            ],
            child: const AppEntryPoint(),
          ),
        ),
      );

      await tester.enterText(find.byType(TextFormField), 'abc');
      await tester.tap(find.text('Continue'));
      await tester.pump();

      expect(find.text('Enter a valid price'), findsOneWidget);
    });

    testWidgets('Onboarding accepts decimal comma', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MultiBlocProvider(
            providers: [
              BlocProvider.value(value: logsCubit),
              BlocProvider.value(value: settingsCubit),
            ],
            child: const AppEntryPoint(),
          ),
          routes: {
            '/settings': (_) => const Scaffold(body: Text('Settings')),
          },
        ),
      );

      await tester.enterText(find.byType(TextFormField), '10,50');
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();

      expect(settingsCubit.state.packPrice, 10.50);
      expect(find.text('Counter'), findsOneWidget);
    });
  });
}