import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

import 'package:smoke_counter/data/cubits/settings_cubit.dart';
import 'package:smoke_counter/features/onboarding/onboarding_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('OnboardingView widget tests', () {
    Widget buildTestWidget({required SettingsCubit settingsCubit}) {
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
      final runId = DateTime.now().millisecondsSinceEpoch;
      final storage = await HydratedStorage.build(
        storageDirectory: HydratedStorageDirectory('/tmp/onboarding_test_$runId'),
      );
      HydratedBloc.storage = storage;
      final settingsCubit = SettingsCubit();

      await tester.pumpWidget(buildTestWidget(settingsCubit: settingsCubit));
      expect(find.text('Welcome to Smoke Counter'), findsOneWidget);

      settingsCubit.close();
    });

    testWidgets('displays pack price question', (WidgetTester tester) async {
      final runId = DateTime.now().millisecondsSinceEpoch;
      final storage = await HydratedStorage.build(
        storageDirectory: HydratedStorageDirectory('/tmp/onboarding_test_$runId'),
      );
      HydratedBloc.storage = storage;
      final settingsCubit = SettingsCubit();

      await tester.pumpWidget(buildTestWidget(settingsCubit: settingsCubit));
      expect(find.text('How much does a pack of cigarettes cost?'), findsOneWidget);

      settingsCubit.close();
    });

    testWidgets('displays price input field', (WidgetTester tester) async {
      final runId = DateTime.now().millisecondsSinceEpoch;
      final storage = await HydratedStorage.build(
        storageDirectory: HydratedStorageDirectory('/tmp/onboarding_test_$runId'),
      );
      HydratedBloc.storage = storage;
      final settingsCubit = SettingsCubit();

      await tester.pumpWidget(buildTestWidget(settingsCubit: settingsCubit));
      expect(find.byType(TextFormField), findsOneWidget);
      expect(find.text('Pack Price'), findsOneWidget);
      expect(find.text('EGP '), findsOneWidget);

      settingsCubit.close();
    });

    testWidgets('displays continue button', (WidgetTester tester) async {
      final runId = DateTime.now().millisecondsSinceEpoch;
      final storage = await HydratedStorage.build(
        storageDirectory: HydratedStorageDirectory('/tmp/onboarding_test_$runId'),
      );
      HydratedBloc.storage = storage;
      final settingsCubit = SettingsCubit();

      await tester.pumpWidget(buildTestWidget(settingsCubit: settingsCubit));
      expect(find.text('Continue'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);

      settingsCubit.close();
    });

    testWidgets('displays fire icon', (WidgetTester tester) async {
      final runId = DateTime.now().millisecondsSinceEpoch;
      final storage = await HydratedStorage.build(
        storageDirectory: HydratedStorageDirectory('/tmp/onboarding_test_$runId'),
      );
      HydratedBloc.storage = storage;
      final settingsCubit = SettingsCubit();

      await tester.pumpWidget(buildTestWidget(settingsCubit: settingsCubit));
      expect(find.byIcon(Icons.local_fire_department_rounded), findsOneWidget);

      settingsCubit.close();
    });
  });
}