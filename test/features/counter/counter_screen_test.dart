import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:intl/intl.dart';

import 'package:smoke_counter/data/cubits/logs_cubit.dart';
import 'package:smoke_counter/data/cubits/settings_cubit.dart';
import 'package:smoke_counter/features/counter/counter_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('CounterView widget tests', () {
    late LogsCubit logsCubit;
    late SettingsCubit settingsCubit;

    setUp(() async {
      final runId = DateTime.now().millisecondsSinceEpoch;
      HydratedBloc.storage = await HydratedStorage.build(
        storageDirectory: HydratedStorageDirectory('/tmp/counter_view_test_$runId'),
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
        home: Scaffold(
          body: MultiBlocProvider(
            providers: [
              BlocProvider.value(value: logsCubit),
              BlocProvider.value(value: settingsCubit),
            ],
            child: const CounterView(),
          ),
        ),
      );
    }

    testWidgets('displays today\'s date', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget());
      final today = DateFormat('EEEE, MMM d').format(DateTime.now());
      expect(find.text(today), findsOneWidget);
    });

    testWidgets('displays zero count initially', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget());
      expect(find.text('0'), findsOneWidget);
      expect(find.text('Cigarettes Today'), findsOneWidget);
    });

    testWidgets('displays spend when settings initialized', (WidgetTester tester) async {
      settingsCubit.setPackPrice(10.0);
      await tester.pumpWidget(buildTestWidget());
      expect(find.text('Spent today: EGP 0.00'), findsOneWidget);
    });

    testWidgets('displays log cigarette button', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget());
      expect(find.byIcon(Icons.add_rounded), findsOneWidget);
      expect(find.text('Log Cigarette'), findsOneWidget);
    });

    testWidgets('displays undo button (disabled at zero)', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget());
      final undoButton = find.byIcon(Icons.remove_rounded);
      expect(tester.widget<TextButton>(undoButton).onPressed, isNull);
    });

    testWidgets('spend displays correctly with settings', (WidgetTester tester) async {
      settingsCubit.setPackPrice(10.0);
      await tester.pumpWidget(buildTestWidget());
      expect(find.text('Spent today: EGP 0.00'), findsOneWidget);
    });

    testWidgets('settings icon in app bar', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget());
      expect(find.byIcon(Icons.settings_rounded), findsOneWidget);
    });
  });
}