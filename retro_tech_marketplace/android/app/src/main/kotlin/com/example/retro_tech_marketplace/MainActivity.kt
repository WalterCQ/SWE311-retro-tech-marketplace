package com.example.retro_tech_marketplace

import android.content.Intent
import android.net.Uri
import android.os.Build
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "retro_tech_marketplace/app_update"
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "getAppInfo" -> {
                    val packageInfo = packageManager.getPackageInfo(packageName, 0)
                    val versionCode = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
                        packageInfo.longVersionCode
                    } else {
                        @Suppress("DEPRECATION")
                        packageInfo.versionCode.toLong()
                    }
                    result.success(
                        mapOf(
                            "versionName" to (packageInfo.versionName ?: ""),
                            "buildNumber" to versionCode.toString()
                        )
                    )
                }
                "openUrl" -> {
                    val url = call.argument<String>("url")
                    if (url.isNullOrBlank()) {
                        result.error("invalid_url", "Missing update URL.", null)
                        return@setMethodCallHandler
                    }
                    try {
                        val intent = Intent(Intent.ACTION_VIEW, Uri.parse(url))
                        startActivity(intent)
                        result.success(true)
                    } catch (error: Exception) {
                        result.error("open_url_failed", error.message, null)
                    }
                }
                else -> result.notImplemented()
            }
        }
    }
}
