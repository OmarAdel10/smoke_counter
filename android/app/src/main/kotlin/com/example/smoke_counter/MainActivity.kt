package com.example.smoke_counter

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "smoke_counter/widget",
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "getState" -> result.success(SmokeWidgetProvider.widgetState(this))
                "setState" -> {
                    val count = call.argument<Int>("count") ?: 0
                    val dateKey = call.argument<String>("dateKey").orEmpty()
                    SmokeWidgetProvider.setWidgetState(this, count, dateKey)
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }
    }
}