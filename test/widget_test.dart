import 'package:flutter_test/flutter_test.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

import 'package:smoke_counter/main.dart';

void main() {
  testWidgets('App loads with placeholder', (WidgetTester tester) async {
    final runId = DateTime.now().millisecondsSinceEpoch;
    HydratedBloc.storage = await HydratedStorage.build(
      storageDirectory: HydratedStorageDirectory('/tmp/widget_test_$runId'),
    );
    await tester.pumpWidget(const SmokeCounterApp());

    expect(find.text('Smoke Counter'), findsOneWidget);
    expect(find.text('Project Setup Complete - Ready for Features'), findsOneWidget);
  });
}