import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

const MethodChannel _widgetChannel = MethodChannel('smoke_counter/widget');

enum WidgetSyncAction { none, adoptWidgetDiff, pushAppCount }

class WidgetSyncResult {
  const WidgetSyncResult({
    required this.action,
    required this.diff,
    required this.targetCount,
  });

  final WidgetSyncAction action;

  /// Number of cigarettes to log into the app when adopting the widget.
  final int diff;

  /// The count the app should converge on.
  final int targetCount;
}

WidgetSyncResult reconcileWidgetState({
  required int appCount,
  required String appTodayKey,
  int? widgetCount,
  String? widgetDateKey,
}) {
  if (widgetCount == null || widgetDateKey == null) {
    return WidgetSyncResult(
      action: WidgetSyncAction.pushAppCount,
      diff: 0,
      targetCount: appCount,
    );
  }

  if (widgetDateKey != appTodayKey) {
    return WidgetSyncResult(
      action: WidgetSyncAction.pushAppCount,
      diff: 0,
      targetCount: appCount,
    );
  }

  if (widgetCount > appCount) {
    return WidgetSyncResult(
      action: WidgetSyncAction.adoptWidgetDiff,
      diff: widgetCount - appCount,
      targetCount: widgetCount,
    );
  }

  if (appCount > widgetCount) {
    return WidgetSyncResult(
      action: WidgetSyncAction.pushAppCount,
      diff: 0,
      targetCount: appCount,
    );
  }

  return WidgetSyncResult(
    action: WidgetSyncAction.none,
    diff: 0,
    targetCount: appCount,
  );
}

String todayDateKey() => DateFormat('yyyy-MM-dd').format(DateTime.now());

class WidgetSyncException implements Exception {
  const WidgetSyncException(this.message);

  final String message;

  @override
  String toString() => 'WidgetSyncException: $message';
}

class WidgetSyncService {
  const WidgetSyncService();

  Future<({int count, String dateKey})?> getWidgetState() async {
    try {
      final result = await _widgetChannel.invokeMapMethod<String, dynamic>(
        'getState',
      );
      if (result == null) return null;
      return (
        count: result['count'] as int,
        dateKey: result['dateKey'] as String,
      );
    } on PlatformException catch (e) {
      throw WidgetSyncException(e.message ?? 'getState failed');
    }
  }

  Future<void> pushCount(int count, String dateKey) async {
    try {
      await _widgetChannel.invokeMethod<void>('setState', <String, dynamic>{
        'count': count,
        'dateKey': dateKey,
      });
    } on PlatformException catch (e) {
      throw WidgetSyncException(e.message ?? 'setState failed');
    }
  }
}
