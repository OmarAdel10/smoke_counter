import 'dart:async';

import 'package:flutter/material.dart';
import 'package:smoke_counter/core/sync/widget_sync_service.dart';
import 'package:smoke_counter/data/cubits/logs_cubit.dart';

class WidgetSyncBridge extends StatefulWidget {
  const WidgetSyncBridge({super.key, required this.cubit});

  final LogsCubit cubit;

  @override
  State<WidgetSyncBridge> createState() => _WidgetSyncBridgeState();
}

class _WidgetSyncBridgeState extends State<WidgetSyncBridge>
    with WidgetsBindingObserver {
  static const WidgetSyncService _service = WidgetSyncService();
  StreamSubscription<Map<String, int>>? _pushSubscription;
  bool _syncing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _pushSubscription = widget.cubit.stream.listen((_) => _pushCount());
    WidgetsBinding.instance.addPostFrameCallback((_) => _sync());
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _sync();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _pushSubscription?.cancel();
    super.dispose();
  }

  Future<void> _sync() async {
    if (_syncing) return;
    _syncing = true;
    try {
      final widgetState = await _service.getWidgetState();
      if (!mounted) return;
      final result = reconcileWidgetState(
        appCount: widget.cubit.todayCount,
        appTodayKey: widget.cubit.todayKey,
        widgetCount: widgetState?.count,
        widgetDateKey: widgetState?.dateKey,
      );
      switch (result.action) {
        case WidgetSyncAction.adoptWidgetDiff:
          for (var i = 0; i < result.diff; i++) {
            widget.cubit.logCigarette();
          }
        case WidgetSyncAction.pushAppCount:
          await _service.pushCount(
            widget.cubit.todayCount,
            widget.cubit.todayKey,
          );
        case WidgetSyncAction.none:
          break;
      }
    } finally {
      _syncing = false;
    }
  }

  Future<void> _pushCount() async {
    if (_syncing) return;
    if (!mounted) return;
    await _service.pushCount(widget.cubit.todayCount, widget.cubit.todayKey);
  }

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
