package io.eisner.news_reader

import android.content.Context
import android.content.SharedPreferences
import android.os.Bundle
import androidx.lifecycle.Lifecycle
import androidx.lifecycle.LifecycleOwner
import androidx.lifecycle.LifecycleRegistry
import io.flutter.app.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import java.util.*

class MainActivity : FlutterActivity(), LifecycleOwner {
    private val flutterChannel = "io.eisner.news_sync"
    private val syncWorkUUIDKey = "syncUUIDKey"
    private val headlinesSyncManager: HeadlinesSyncManager by lazy { HeadlinesSyncManager(application as NewsApp) }
    private lateinit var methodChannel: MethodChannel
    private val sharedPreferences: SharedPreferences
        get() = getSharedPreferences("Settings", Context.MODE_PRIVATE)

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        GeneratedPluginRegistrant.registerWith(this)
        methodChannel = MethodChannel(flutterView, flutterChannel).apply {
            setMethodCallHandler { call, _ ->
                if (call.method == "sync") {
                    val syncTimeInS = call.argument<Int>("timeInSeconds") ?: 15 * 60
                    val newsApiKey = call.argument<String>("apiKey") ?: ""
                    val uuid = headlinesSyncManager.scheduleSync(syncTimeInS, newsApiKey)
                    sharedPreferences.edit().putString(syncWorkUUIDKey, uuid.toString()).apply()
                    headlinesSyncManager.observeWork(uuid, this@MainActivity, methodChannel)
                } else if (call.method == "stop") {
                    headlinesSyncManager.stopSync()
                }
            }
        }
        checkSync()

        lifecycleRegistry.handleLifecycleEvent(Lifecycle.Event.ON_CREATE)
    }

    private fun checkSync() {
        val uuid: String? = sharedPreferences.getString(syncWorkUUIDKey, null)
        uuid?.let {
            headlinesSyncManager.observeWork(UUID.fromString(uuid), this@MainActivity, methodChannel)
        }
    }

    private val lifecycleRegistry = LifecycleRegistry(this)

    override fun getLifecycle(): Lifecycle {
        return lifecycleRegistry
    }

    override fun onDestroy() {
        lifecycleRegistry.handleLifecycleEvent(Lifecycle.Event.ON_DESTROY)
        super.onDestroy()
    }

    override fun onStart() {
        super.onStart()
        lifecycleRegistry.handleLifecycleEvent(Lifecycle.Event.ON_START)
    }

    override fun onResume() {
        super.onResume()
        lifecycleRegistry.handleLifecycleEvent(Lifecycle.Event.ON_RESUME)
    }

    override fun onPause() {
        lifecycleRegistry.handleLifecycleEvent(Lifecycle.Event.ON_PAUSE)
        super.onPause()
    }

    override fun onStop() {
        lifecycleRegistry.handleLifecycleEvent(Lifecycle.Event.ON_STOP)
        super.onStop()
    }
}
