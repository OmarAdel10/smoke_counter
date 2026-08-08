import 'package:flutter_test/flutter_test.dart';
import 'package:smoke_counter/core/sync/widget_sync_service.dart';

void main() {
  group('reconcileWidgetState', () {
    const today = '2026-08-08';

    test('returns no-op when app and widget counts match', () {
      final result = reconcileWidgetState(
        appCount: 5,
        appTodayKey: today,
        widgetCount: 5,
        widgetDateKey: today,
      );

      expect(result.action, WidgetSyncAction.none);
      expect(result.diff, 0);
      expect(result.targetCount, 5);
    });

    test('adopts widget diff when widget is ahead', () {
      final result = reconcileWidgetState(
        appCount: 3,
        appTodayKey: today,
        widgetCount: 7,
        widgetDateKey: today,
      );

      expect(result.action, WidgetSyncAction.adoptWidgetDiff);
      expect(result.diff, 4);
      expect(result.targetCount, 7);
    });

    test('pushes app count when app is ahead', () {
      final result = reconcileWidgetState(
        appCount: 9,
        appTodayKey: today,
        widgetCount: 2,
        widgetDateKey: today,
      );

      expect(result.action, WidgetSyncAction.pushAppCount);
      expect(result.diff, 0);
      expect(result.targetCount, 9);
    });

    test('pushes app count when widget date is stale', () {
      final result = reconcileWidgetState(
        appCount: 2,
        appTodayKey: today,
        widgetCount: 15,
        widgetDateKey: '2026-08-07',
      );

      expect(result.action, WidgetSyncAction.pushAppCount);
      expect(result.targetCount, 2);
    });

    test('pushes app count when widget state is missing', () {
      final result = reconcileWidgetState(appCount: 1, appTodayKey: today);

      expect(result.action, WidgetSyncAction.pushAppCount);
      expect(result.targetCount, 1);
    });
  });
}
