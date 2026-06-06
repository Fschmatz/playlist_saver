package com.fschmatz.playlist_saver

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.net.Uri
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetProvider

class PlaylistWidgetProvider : HomeWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences
    ) {
        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(context.packageName, R.layout.playlist_widget)

            val serviceIntent = Intent(context, PlaylistWidgetService::class.java).apply {
                putExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, widgetId)
                data = Uri.parse(toUri(Intent.URI_INTENT_SCHEME) + "&t=${System.currentTimeMillis()}")
            }

            views.setRemoteAdapter(R.id.widget_list_view, serviceIntent)
            views.setEmptyView(R.id.widget_list_view, R.id.widget_empty_view)

            val clickIntentTemplate = Intent(Intent.ACTION_VIEW)
            var pendingIntentFlags = android.app.PendingIntent.FLAG_UPDATE_CURRENT or android.app.PendingIntent.FLAG_MUTABLE
            if (android.os.Build.VERSION.SDK_INT >= 34) { // Android 14+
                pendingIntentFlags = pendingIntentFlags or android.app.PendingIntent.FLAG_ALLOW_UNSAFE_IMPLICIT_INTENT
            }
            
            val pendingIntentTemplate = android.app.PendingIntent.getActivity(
                context, 0, clickIntentTemplate, pendingIntentFlags
            )
            views.setPendingIntentTemplate(R.id.widget_list_view, pendingIntentTemplate)

            appWidgetManager.updateAppWidget(widgetId, views)
            appWidgetManager.notifyAppWidgetViewDataChanged(widgetId, R.id.widget_list_view)
        }
    }
}
