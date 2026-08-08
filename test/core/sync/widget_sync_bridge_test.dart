import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:smoke_counter/core/sync/widget_sync_bridge.dart';
import 'package:smoke_counter/data/cubits/logs_cubit.dart';

import '../../helpers/in_memory_storage.dart';

const _channel = MethodChannel('smoke_counter/widget');

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    HydratedBloc.storage = InMemoryStorage();
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(_channel, null);
  });

  void mockGetState({int count = 0, String dateKey = '2026-08-08'}) {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(_channel, (call) async {
          if (call.method == 'getState') {
            return <String, dynamic>{'count': count, 'dateKey': dateKey};
          }
          return null;
        });
  }

  testWidgets('adopts widget diff into cubit on start', (tester) async {
    mockGetState(count: 6);
    final cubit = LogsCubit();

    await tester.pumpWidget(MaterialApp(home: WidgetSyncBridge(cubit: cubit)));
    await tester.pumpAndSettle();

    expect(cubit.todayCount, 6);
    cubit.close();
  });

  testWidgets('pushes app count when widget behind', (tester) async {
    final pushed = <Map<String, dynamic>>[];
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(_channel, (call) async {
          if (call.method == 'getState') {
            return <String, dynamic>{'count': 2, 'dateKey': '2026-08-08'};
          }
          if (call.method == 'setState') {
            final args = call.arguments as Map<Object?, Object?>;
            pushed.add(<String, dynamic>{
              'count': args['count'],
              'dateKey': args['dateKey'],
            });
          }
          return null;
        });
    final cubit = LogsCubit();
    cubit.logCigarette();
    cubit.logCigarette();
    cubit.logCigarette();
    cubit.logCigarette();
    cubit.logCigarette();
    cubit.logCigarette();

    await tester.pumpWidget(MaterialApp(home: WidgetSyncBridge(cubit: cubit)));
    await tester.pumpAndSettle();

    expect(pushed, isNotEmpty);
    expect(pushed.last['count'], 6);
    cubit.close();
  });

  testWidgets('does not touch cubit when counts match', (tester) async {
    mockGetState(count: 3);
    final cubit = LogsCubit();
    cubit.logCigarette();
    cubit.logCigarette();
    cubit.logCigarette();

    await tester.pumpWidget(MaterialApp(home: WidgetSyncBridge(cubit: cubit)));
    await tester.pumpAndSettle();

    expect(cubit.todayCount, 3);
    cubit.close();
  });
}
