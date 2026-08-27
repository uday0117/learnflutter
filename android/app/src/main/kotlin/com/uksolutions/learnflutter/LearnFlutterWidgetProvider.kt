package com.uksolutions.learnflutter

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.net.Uri
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetProvider

class LearnFlutterWidgetProvider : HomeWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences
    ) {
        appWidgetIds.forEach { widgetId ->
            val streak = widgetData.getInt("streak", 0)
            val widgetName = widgetData.getString("widget_name", "Text") ?: "Text"
            val widgetIdStr = widgetData.getString("widget_id", "text") ?: "text"
            val progress = widgetData.getInt("progress", 0)

            val views = RemoteViews(context.packageName, R.layout.learn_widget).apply {
                setTextViewText(R.id.widget_streak, "🔥 $streak")
                setTextViewText(R.id.widget_name, widgetName)
                setTextViewText(R.id.widget_progress, "$progress% explored")

                val deepLink = Uri.parse("https://ukrsolutions.in/learnflutter/widget/$widgetIdStr")
                val pendingIntent = HomeWidgetLaunchIntent.getActivity(
                    context,
                    MainActivity::class.java,
                    deepLink
                )
                setOnClickPendingIntent(R.id.widget_container, pendingIntent)
            }

            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }
}
