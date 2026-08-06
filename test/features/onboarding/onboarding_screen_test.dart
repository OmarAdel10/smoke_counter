import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

import 'package:smoke_counter/data/cubits/settings_cubit.dart';
import 'package:smoke_counter/features/onboarding/onboarding_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('OnboardingView widget tests', () {
    late SettingsCubit settingsCubit;

    setUp(() async {
      final runId = DateTime.now().millisecondsSinceEpoch;
      HydratedBloc.storage = await HydratedStorage.build(
        storageDirectory: HydratedStorageDirectory('/tmp/onboarding_test_$runId'),
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
            child: const OnboardingView(),
          ),
        ),
      );
    }

    testWidgets('displays welcome title', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget());
      expect(find.text('Welcome to Smoke Counter'), findsOneWidget);
    });

    testWidgets('displays pack price question', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget());
      expect(find.text('How much does a pack of cigarettes cost?'), findsOneWidget);
    });

    testWidgets('displays price input field', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget());
      expect(find.byType(TextFormField), findsOneWidget);
      expect(find.text('Pack Price'), findsOneWidget);
      expect(find.text('EGP '), findsOneWidget);
    });

    testWidgets('displays continue button', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget());
      expect(find.text('Continue'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('displays fire icon', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget());
      expect(find.byIcon(Icons.local_fire_department_rounded), findsOneWidget);
    });
  });
}