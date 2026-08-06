import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

import 'package:smoke_counter/data/cubits/settings_cubit.dart';
import 'package:smoke_counter/features/settings/settings_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SettingsView widget tests', () {
    late SettingsCubit settingsCubit;

    setUp(() async {
      final runId = DateTime.now().millisecondsSinceEpoch;
      HydratedBloc.storage = await HydratedStorage.build(
        storageDirectory: HydratedStorageDirectory('/tmp/settings_test_$runId'),
      );
      settingsCubit = SettingsCubit();
    });

    tearDown(() {
      settingsCubit.close();
    });

    Widget buildTestWidget() {
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
      await tester.pumpWidget(buildTestWidget());
      expect(find.text('Settings'), findsOneWidget);
    });

    testWidgets('displays pack price section header', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget());
      // Find the headlineSmall text which is the section header
      expect(find.byWidgetPredicate((widget) => 
        widget is Text && 
        widget.data == 'Pack Price' && 
        widget.style?.fontWeight == FontWeight.w600), findsOneWidget);
      expect(find.text('Cost of one pack of cigarettes. Used to calculate daily and total spending.'), findsOneWidget);
    });

    testWidgets('displays pack price input field', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget());
      // Find TextField with labelText "Pack Price"
      expect(find.byWidgetPredicate((widget) => 
        widget is TextField && 
        widget.decoration?.labelText == 'Pack Price'), findsOneWidget);
      expect(find.text('EGP '), findsWidgets);
    });

    testWidgets('displays cigarettes per pack section header', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget());
      // Find the titleMedium text which is the section header
      expect(find.byWidgetPredicate((widget) => 
        widget is Text && 
        widget.data == 'Cigarettes Per Pack' && 
        widget.style?.fontWeight == FontWeight.w600), findsOneWidget);
      expect(find.text('Number of cigarettes in a pack. Default is 20.'), findsOneWidget);
    });

    testWidgets('displays cigarettes per pack input field', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget());
      final textFields = find.byType(TextField);
      expect(textFields, findsWidgets);
    });

    testWidgets('displays cost per cigarette when initialized', (WidgetTester tester) async {
      settingsCubit.setPackPrice(10.0);
      await tester.pumpWidget(buildTestWidget());
      expect(find.text('Current Cost Per Cigarette'), findsOneWidget);
      expect(find.text('EGP 0.5000'), findsOneWidget);
      expect(find.text('Based on pack price and cigarettes per pack'), findsOneWidget);
    });

    testWidgets('does not display cost per cigarette when not initialized', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget());
      expect(find.text('Current Cost Per Cigarette'), findsNothing);
    });
  });
}