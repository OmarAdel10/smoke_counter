import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

import 'package:smoke_counter/data/cubits/settings_cubit.dart';
import 'package:smoke_counter/features/settings/settings_screen.dart';

import '../../helpers/in_memory_storage.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    HydratedBloc.storage = InMemoryStorage();
  });

  group('SettingsView widget tests', () {
    Widget buildTestWidget({required SettingsCubit settingsCubit}) {
      return MaterialApp(
        home: Scaffold(
          body: BlocProvider.value(
            value: settingsCubit,
            child: const SettingsView(),
          ),
        ),
      );
    }

    testWidgets('displays settings title', (WidgetTester tester) async {
      final settingsCubit = SettingsCubit();

      await tester.pumpWidget(buildTestWidget(settingsCubit: settingsCubit));
      expect(find.text('Settings'), findsOneWidget);

      settingsCubit.close();
    });

    testWidgets('displays pack price section header', (
      WidgetTester tester,
    ) async {
      final settingsCubit = SettingsCubit();

      await tester.pumpWidget(buildTestWidget(settingsCubit: settingsCubit));
      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is Text &&
              widget.data == 'Pack Price' &&
              widget.style?.fontWeight == FontWeight.w600,
        ),
        findsOneWidget,
      );
      expect(
        find.text(
          'Cost of one pack of cigarettes. Used to calculate daily and total spending.',
        ),
        findsOneWidget,
      );

      settingsCubit.close();
    });

    testWidgets('displays pack price input field', (WidgetTester tester) async {
      final settingsCubit = SettingsCubit();

      await tester.pumpWidget(buildTestWidget(settingsCubit: settingsCubit));
      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is TextField &&
              widget.decoration?.labelText == 'Pack Price',
        ),
        findsOneWidget,
      );
      expect(find.text('EGP '), findsWidgets);

      settingsCubit.close();
    });

    testWidgets('displays cigarettes per pack section header', (
      WidgetTester tester,
    ) async {
      final settingsCubit = SettingsCubit();

      await tester.pumpWidget(buildTestWidget(settingsCubit: settingsCubit));
      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is Text &&
              widget.data == 'Cigarettes Per Pack' &&
              widget.style?.fontWeight == FontWeight.w600,
        ),
        findsOneWidget,
      );
      expect(
        find.text('Number of cigarettes in a pack. Default is 20.'),
        findsOneWidget,
      );

      settingsCubit.close();
    });

    testWidgets('displays cigarettes per pack input field', (
      WidgetTester tester,
    ) async {
      final settingsCubit = SettingsCubit();

      await tester.pumpWidget(buildTestWidget(settingsCubit: settingsCubit));
      final textFields = find.byType(TextField);
      expect(textFields, findsWidgets);

      settingsCubit.close();
    });

    testWidgets('displays cost per cigarette when initialized', (
      WidgetTester tester,
    ) async {
      final settingsCubit = SettingsCubit();
      settingsCubit.setPackPrice(10.0);

      await tester.pumpWidget(buildTestWidget(settingsCubit: settingsCubit));
      expect(find.text('Current Cost Per Cigarette'), findsOneWidget);
      expect(find.text('EGP 0.5000'), findsOneWidget);
      expect(
        find.text('Based on pack price and cigarettes per pack'),
        findsOneWidget,
      );

      settingsCubit.close();
    });

    testWidgets('does not display cost per cigarette when not initialized', (
      WidgetTester tester,
    ) async {
      final settingsCubit = SettingsCubit();

      await tester.pumpWidget(buildTestWidget(settingsCubit: settingsCubit));
      expect(find.text('Current Cost Per Cigarette'), findsNothing);

      settingsCubit.close();
    });
  });
}
