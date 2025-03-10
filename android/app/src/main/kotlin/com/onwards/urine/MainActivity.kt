package com.wonpl.urine

import android.content.Intent
import android.net.Uri
import android.os.Bundle
import android.widget.Toast
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL_PLAYSTORE = "com.wonpl.urine/playstore"
    private val CHANNEL_SHOP = "com.wonpl.urine/shop"

    override fun configureFlutterEngine(flutterEngine: io.flutter.embedding.engine.FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)


        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL_PLAYSTORE).setMethodCallHandler { call, result ->
            if (call.method == "redirectToPlayStore") {
                redirectToPlayStore()
                result.success(null)
            } else {
                result.notImplemented()
            }
        }

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL_SHOP).setMethodCallHandler { call, result ->
            if (call.method == "openShop") {
                redirectToYocheckShop()
                result.success(null)
            } else {
                result.notImplemented()
            }
        }
    }

    private fun redirectToPlayStore() {
        try {
            //val packageName = packageName
            val uri = Uri.parse("https://play.google.com/store/apps/details?id=com.wonpl.urine&hl=ko")
            val intent = Intent(Intent.ACTION_VIEW, uri).apply {
                addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            }
            startActivity(intent)
        } catch (e: Exception) {
            Toast.makeText(this, "Could not open Play Store", Toast.LENGTH_SHORT).show()
        }
    }

    private fun redirectToYocheckShop() {
        try {
            //val packageName = packageName
            val uri = Uri.parse("http://www.optosta.com/shop/list.php?ca_id=20")
            val intent = Intent(Intent.ACTION_VIEW, uri).apply {
                addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            }
            startActivity(intent)
        } catch (e: Exception) {
            Toast.makeText(this, "Could not open Play Store", Toast.LENGTH_SHORT).show()
        }
    }
}
