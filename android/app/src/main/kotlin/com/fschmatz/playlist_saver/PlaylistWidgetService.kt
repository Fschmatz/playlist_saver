package com.fschmatz.playlist_saver

import android.content.Context
import android.content.Intent
import android.graphics.BitmapFactory
import android.util.Base64
import android.widget.RemoteViews
import android.widget.RemoteViewsService
import org.json.JSONArray
import org.json.JSONObject
import es.antonborri.home_widget.HomeWidgetPlugin
import android.app.PendingIntent
import android.net.Uri

class PlaylistWidgetService : RemoteViewsService() {
    override fun onGetViewFactory(intent: Intent): RemoteViewsFactory {
        return PlaylistRemoteViewsFactory(this.applicationContext)
    }
}

class PlaylistRemoteViewsFactory(private val context: Context) :
    RemoteViewsService.RemoteViewsFactory {
    private var playlist = mutableListOf<JSONObject>()

    override fun onCreate() {}

    override fun onDataSetChanged() {
        playlist.clear()

        val prefs = HomeWidgetPlugin.getData(context)
        val jsonString = prefs.getString("playlists_json", "[]") ?: "[]"

        try {
            val jsonArray = JSONArray(jsonString)
            for (i in 0 until jsonArray.length()) {
                playlist.add(jsonArray.getJSONObject(i))
            }
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }

    override fun onDestroy() {
        playlist.clear()
    }

    override fun getCount(): Int = playlist.size

    override fun getViewAt(position: Int): RemoteViews {
        val views = RemoteViews(context.packageName, R.layout.widget_list_item)

        // Always clear the ImageView first to prevent stale cached bitmaps
        views.setImageViewBitmap(R.id.iv_cover, null)
        views.setViewVisibility(R.id.iv_downloaded, android.view.View.GONE)

        if (position < playlist.size) {
            val item = playlist[position]
            views.setTextViewText(R.id.tv_title, item.optString("title", ""))
            views.setTextViewText(R.id.tv_artist, item.optString("artist", ""))
            
            val isDownloaded = item.optString("downloaded", "false") == "true"
            if (isDownloaded) {
                views.setViewVisibility(R.id.iv_downloaded, android.view.View.VISIBLE)
            }

            val coverBase64 = item.optString("cover", "")
            if (coverBase64.isNotEmpty()) {
                try {
                    val decodedBytes = Base64.decode(coverBase64, Base64.DEFAULT)
                    val bitmap = BitmapFactory.decodeByteArray(decodedBytes, 0, decodedBytes.size)
                    val roundedBitmap = getRoundedCornerBitmap(bitmap, 12)
                    views.setImageViewBitmap(R.id.iv_cover, roundedBitmap)
                } catch (e: Exception) {
                    views.setImageViewBitmap(R.id.iv_cover, getPlaceholderBitmap(12))
                }
            } else {
                views.setImageViewBitmap(R.id.iv_cover, getPlaceholderBitmap(12))
            }

            val link = item.optString("link", "")
            if (link.isNotEmpty()) {
                val fillInIntent = Intent(Intent.ACTION_VIEW, Uri.parse(link))
                views.setOnClickFillInIntent(R.id.widget_item_container, fillInIntent)
            }
        }
        return views
    }

    private fun getPlaceholderBitmap(dp: Int): android.graphics.Bitmap {
        val size = (58 * context.resources.displayMetrics.density).toInt()
        val pixels = (dp * context.resources.displayMetrics.density).toInt()
        val output = android.graphics.Bitmap.createBitmap(size, size, android.graphics.Bitmap.Config.ARGB_8888)
        val canvas = android.graphics.Canvas(output)
        val paint = android.graphics.Paint(android.graphics.Paint.ANTI_ALIAS_FLAG)
        paint.color = android.graphics.Color.BLACK
        canvas.drawRoundRect(
            android.graphics.RectF(0f, 0f, size.toFloat(), size.toFloat()),
            pixels.toFloat(), pixels.toFloat(), paint
        )
        return output
    }

    private fun getRoundedCornerBitmap(bitmap: android.graphics.Bitmap, dp: Int): android.graphics.Bitmap {
        val pixels = (dp * context.resources.displayMetrics.density).toInt()
        val output = android.graphics.Bitmap.createBitmap(bitmap.width, bitmap.height, android.graphics.Bitmap.Config.ARGB_8888)
        val canvas = android.graphics.Canvas(output)
        val paint = android.graphics.Paint()
        val rect = android.graphics.Rect(0, 0, bitmap.width, bitmap.height)
        val rectF = android.graphics.RectF(rect)
        val roundPx = pixels.toFloat()

        paint.isAntiAlias = true
        canvas.drawARGB(0, 0, 0, 0)
        paint.color = -0xbdbdbe
        canvas.drawRoundRect(rectF, roundPx, roundPx, paint)
        paint.xfermode = android.graphics.PorterDuffXfermode(android.graphics.PorterDuff.Mode.SRC_IN)
        canvas.drawBitmap(bitmap, rect, rect, paint)
        return output
    }

    override fun getLoadingView(): RemoteViews {
        val views = RemoteViews(context.packageName, R.layout.widget_list_item)
        views.setTextViewText(R.id.tv_title, "")
        views.setTextViewText(R.id.tv_artist, "")
        views.setImageViewBitmap(R.id.iv_cover, getPlaceholderBitmap(12))
        views.setViewVisibility(R.id.iv_downloaded, android.view.View.GONE)
        return views
    }

    override fun getViewTypeCount(): Int = 1
    override fun getItemId(position: Int): Long = position.toLong()
    override fun hasStableIds(): Boolean = false
}
