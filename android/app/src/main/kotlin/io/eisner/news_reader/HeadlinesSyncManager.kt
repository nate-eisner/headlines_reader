package io.eisner.news_reader

import android.util.Log
import androidx.lifecycle.LifecycleOwner
import androidx.lifecycle.Observer
import androidx.work.*
import io.eisner.news_reader.sync.SyncWorker
import io.flutter.plugin.common.MethodChannel
import java.util.*
import java.util.concurrent.TimeUnit

class HeadlinesSyncManager(val app: NewsApp) {

    fun scheduleSync(syncTimeSeconds: Int, apiKey: String): UUID {
        val constraints = Constraints.Builder()
                .setRequiresBatteryNotLow(true)
                .setRequiredNetworkType(NetworkType.CONNECTED)
                .build()

        val periodicWorkRequest = PeriodicWorkRequestBuilder<SyncWorker>(syncTimeSeconds.toLong(), TimeUnit.SECONDS)
                .setInitialDelay(15, TimeUnit.MINUTES)
                .setConstraints(constraints)
                .setInputData(Data.Builder().putString("apiKey", apiKey).build())
                .build()

        WorkManager.getInstance(app)
                .enqueue(periodicWorkRequest)

        return periodicWorkRequest.id
    }

    fun observeWork(uuid: UUID, lifecycleOwner: LifecycleOwner, methodChannel: MethodChannel) {
        Log.d("NEWS", "OBSERVE WORK")
        WorkManager.getInstance(app).getWorkInfoByIdLiveData(uuid)
                .observe(lifecycleOwner, Observer { workInfo ->
                    Log.d("NEWS", "WORK CHANGED")
                    if (workInfo != null && workInfo.state == WorkInfo.State.ENQUEUED) {
                        methodChannel.invokeMethod("syncSuccess", null)
                    }
                })
    }

    fun stopSync() {
        WorkManager.getInstance(app).cancelAllWork()
    }
}