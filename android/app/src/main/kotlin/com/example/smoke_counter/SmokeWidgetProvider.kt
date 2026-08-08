package com.example.smoke_counter

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.widget.RemoteViews
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale

class SmokeWidgetProvider : AppWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
    ) {
        appWidgetIds.forEach { id ->
            appWidgetManager.updateAppWidget(id, buildViews(context))
        }
    }

    override fun onReceive(context: Context, intent: Intent) {
        super.onReceive(context, intent)
        if (intent.action == ACTION_INCREMENT) {
            val prefs = prefs(context)
            val count = if (prefs.getString(KEY_DATE, null) == todayKey()) {
                prefs.getInt(KEY_COUNT, 0)
            } else {
                0
            }
            prefs.edit()
                .putInt(KEY_COUNT, count + 1)
                .putString(KEY_DATE, todayKey())
                .apply()
            refreshAll(context)
        }
    }

    companion object {
        const val ACTION_INCREMENT = "com.example.smoke_counter.ACTION_INCREMENT"
        private const val PREFS_NAME = "smoke_widget"
        private const val KEY_COUNT = "count"
        private const val KEY_DATE = "date_key"

        private fun prefs(context: Context): SharedPreferences =
            context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)

        private fun buildViews(context: Context): RemoteViews {
            val prefs = prefs(context)
            val views = RemoteViews(context.packageName, R.layout.smoke_widget)
            val count = if (prefs.getString(KEY_DATE, null) == todayKey()) {
                prefs.getInt(KEY_COUNT, 0)
            } else {
                0
            }
            views.setTextViewText(R.id.widget_count, count.toString())

            val incrementIntent = Intent(context, SmokeWidgetProvider::class.java).apply {
                action = ACTION_INCREMENT
            }
            val pendingIntent = PendingIntent.getBroadcast(
                context,
                0,
                incrementIntent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
            )
            views.setOnClickPendingIntent(R.id.widget_button, pendingIntent)
            return views
        }

        fun refreshAll(context: Context) {
            val manager = AppWidgetManager.getInstance(context)
            val ids = manager.getAppWidgetIds(
                ComponentName(context, SmokeWidgetProvider::class.java),
            )
            ids.forEach { id -> manager.updateAppWidget(id, buildViews(context)) }
        }

        fun setWidgetState(context: Context, count: Int, dateKey: String) {
            val prefs = prefs(context)
            val effectiveCount = if (dateKey == todayKey()) count else 0
            prefs.edit()
                .putInt(KEY_COUNT, effectiveCount)
                .putString(KEY_DATE, dateKey)
                .apply()
            refreshAll(context)
        }

        fun widgetState(context: Context): Map<String, Any> {
            val prefs = prefs(context)
            return mapOf(
                "count" to prefs.getInt(KEY_COUNT, 0),
                "dateKey" to (prefs.getString(KEY_DATE, "") ?: ""),
            )
        }

        fun todayKey(): String =
            SimpleDateFormat("yyyy-MM-dd", Locale.US).format(Date())
    }
}