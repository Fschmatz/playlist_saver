package com.fschmatz.playlist_saver

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.graphics.*
import android.net.Uri
import android.os.Build
import android.util.Base64
import android.view.View
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetPlugin
import es.antonborri.home_widget.HomeWidgetProvider
import org.json.JSONArray
import org.json.JSONObject

class PlaylistWidgetProvider : HomeWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences
    ) {
        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(context.packageName, R.layout.playlist_widget)

            try {
                val prefs = HomeWidgetPlugin.getData(context)
                val jsonString = prefs.getString("playlists_json", "[]") ?: "[]"
                val jsonArray = JSONArray(jsonString)
                
                // Android 16 (API 36) exclusively uses modern CollectionItems API
                val builder = RemoteViews.RemoteCollectionItems.Builder()
                
                for (i in 0 until jsonArray.length()) {
                    val item = jsonArray.getJSONObject(i)
                    val id = item.optLong("id", i.toLong())
                    val itemViews = getProcessedItemView(context, item)
                    
                    val link = item.optString("link", "")
                    if (link.isNotEmpty()) {
                        val fillInIntent = Intent(Intent.ACTION_VIEW, Uri.parse(link))
                        itemViews.setOnClickFillInIntent(R.id.widget_item_container, fillInIntent)
                    }
                    
                    builder.addItem(id, itemViews)
                }

                builder.setHasStableIds(true)
                val collectionItems = builder.build()
                views.setRemoteAdapter(R.id.widget_list_view, collectionItems)
            } catch (e: Exception) {
                e.printStackTrace()
            }

            views.setEmptyView(R.id.widget_list_view, R.id.widget_empty_view)

            val clickIntentTemplate = Intent(Intent.ACTION_VIEW)
            var pendingIntentFlags = android.app.PendingIntent.FLAG_UPDATE_CURRENT or android.app.PendingIntent.FLAG_MUTABLE
            if (Build.VERSION.SDK_INT >= 34) {
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

    private fun getProcessedItemView(context: Context, item: JSONObject): RemoteViews {
        val views = RemoteViews(context.packageName, R.layout.widget_list_item)

        views.setImageViewBitmap(R.id.iv_cover, null)
        views.setViewVisibility(R.id.iv_downloaded, View.GONE)

        views.setTextViewText(R.id.tv_title, item.optString("title", ""))
        views.setTextViewText(R.id.tv_artist, item.optString("artist", ""))

        val isDownloaded = item.optString("downloaded", "false") == "true"
        if (isDownloaded) {
            views.setViewVisibility(R.id.iv_downloaded, View.VISIBLE)
        }

        val coverBase64 = item.optString("cover", "")
        if (coverBase64.isNotEmpty()) {
            try {
                val decodedBytes = Base64.decode(coverBase64, Base64.DEFAULT)
                val bitmap = BitmapFactory.decodeByteArray(decodedBytes, 0, decodedBytes.size)
                if (bitmap != null) {
                    views.setImageViewBitmap(R.id.iv_cover, bitmap)
                }
            } catch (e: Exception) {
                e.printStackTrace()
            }
        }

        return views
    }
}
