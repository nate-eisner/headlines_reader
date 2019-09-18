package io.eisner.news_reader

import android.os.Bundle
import androidx.lifecycle.Lifecycle
import androidx.lifecycle.LifecycleOwner
import androidx.lifecycle.LifecycleRegistry
import androidx.lifecycle.Observer
import androidx.work.WorkInfo
import androidx.work.WorkManager
import io.flutter.app.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity : FlutterActivity(), LifecycleOwner {
    private val flutterChannel = "io.eisner.new_reader"
    private val headlinesSyncManager: HeadlinesSyncManager by lazy { HeadlinesSyncManager(application as NewsApp) }
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        GeneratedPluginRegistrant.registerWith(this)
        MethodChannel(flutterView, flutterChannel).setMethodCallHandler { call, _ ->
            if (call.method == "sync") {
                val syncTimeInS = call.argument<Int>("timeInSeconds") ?: 15 * 60
                val newsApiKey = call.argument<String>("apiKey") ?: ""
                val uuid = headlinesSyncManager.scheduleSync(syncTimeInS, newsApiKey)

                WorkManager.getInstance(this).getWorkInfoByIdLiveData(uuid)
                        .observe(this, Observer { workInfo ->
                            if (workInfo != null && workInfo.state == WorkInfo.State.ENQUEUED) {
                                MethodChannel(flutterView, flutterChannel).invokeMethod("syncSuccess", null)
                            }
                        })
            } else if (call.method == "stop") {
                headlinesSyncManager.stopSync()
            }
        }
        lifecycleRegistry.handleLifecycleEvent(Lifecycle.Event.ON_CREATE)
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
