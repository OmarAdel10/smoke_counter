import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:intl/intl.dart';

import 'package:smoke_counter/data/cubits/logs_cubit.dart';
import 'package:smoke_counter/data/cubits/settings_cubit.dart';
import 'package:smoke_counter/features/counter/counter_screen.dart';

import '../../helpers/in_memory_storage.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    HydratedBloc.storage = InMemoryStorage();
  });

  group('CounterView widget tests', () {
    Widget buildTestWidget({
      required LogsCubit logsCubit,
      required SettingsCubit settingsCubit,
    }) {
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
      final logsCubit = LogsCubit();
      final settingsCubit = SettingsCubit();

      await tester.pumpWidget(
        buildTestWidget(logsCubit: logsCubit, settingsCubit: settingsCubit),
      );
      final today = DateFormat('EEEE, MMM d').format(DateTime.now());
      expect(find.text(today), findsOneWidget);

      logsCubit.close();
      settingsCubit.close();
    });

    testWidgets('displays zero count initially', (WidgetTester tester) async {
      final logsCubit = LogsCubit();
      final settingsCubit = SettingsCubit();

      await tester.pumpWidget(
        buildTestWidget(logsCubit: logsCubit, settingsCubit: settingsCubit),
      );
      expect(find.text('0'), findsOneWidget);
      expect(find.text('Cigarettes Today'), findsOneWidget);

      logsCubit.close();
      settingsCubit.close();
    });

    testWidgets('displays spend when settings initialized', (
      WidgetTester tester,
    ) async {
      final logsCubit = LogsCubit();
      final settingsCubit = SettingsCubit();
      settingsCubit.setPackPrice(10.0);

      await tester.pumpWidget(
        buildTestWidget(logsCubit: logsCubit, settingsCubit: settingsCubit),
      );
      expect(find.text('Spent today: EGP 0.00'), findsOneWidget);

      logsCubit.close();
      settingsCubit.close();
    });

    testWidgets('displays log cigarette button', (WidgetTester tester) async {
      final logsCubit = LogsCubit();
      final settingsCubit = SettingsCubit();

      await tester.pumpWidget(
        buildTestWidget(logsCubit: logsCubit, settingsCubit: settingsCubit),
      );
      expect(find.byIcon(Icons.add_rounded), findsOneWidget);
      expect(find.text('Log Cigarette'), findsOneWidget);

      logsCubit.close();
      settingsCubit.close();
    });

    testWidgets('displays undo button (disabled at zero)', (
      WidgetTester tester,
    ) async {
      final logsCubit = LogsCubit();
      final settingsCubit = SettingsCubit();

      await tester.pumpWidget(
        buildTestWidget(logsCubit: logsCubit, settingsCubit: settingsCubit),
      );

      final undoButton = find.ancestor(
        of: find.byIcon(Icons.remove_rounded),
        matching: find.byType(TextButton),
      );
      final button = tester.widget(undoButton) as TextButton;
      expect(button.onPressed, isNull);

      logsCubit.close();
      settingsCubit.close();
    });

    testWidgets('spend displays correctly with settings', (
      WidgetTester tester,
    ) async {
      final logsCubit = LogsCubit();
      final settingsCubit = SettingsCubit();
      settingsCubit.setPackPrice(10.0);

      await tester.pumpWidget(
        buildTestWidget(logsCubit: logsCubit, settingsCubit: settingsCubit),
      );
      expect(find.text('Spent today: EGP 0.00'), findsOneWidget);

      logsCubit.close();
      settingsCubit.close();
    });

    testWidgets('settings icon in app bar', (WidgetTester tester) async {
      final logsCubit = LogsCubit();
      final settingsCubit = SettingsCubit();

      await tester.pumpWidget(
        buildTestWidget(logsCubit: logsCubit, settingsCubit: settingsCubit),
      );
      expect(find.byIcon(Icons.settings_rounded), findsOneWidget);

      logsCubit.close();
      settingsCubit.close();
    });
  });
}
