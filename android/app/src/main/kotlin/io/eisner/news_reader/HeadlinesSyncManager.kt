package io.eisner.news_reader

import android.util.Log
import androidx.work.Constraints
import androidx.work.NetworkType
import androidx.work.PeriodicWorkRequestBuilder
import androidx.work.WorkManager
import io.eisner.news_reader.sync.SyncWorker
import java.util.*
import java.util.concurrent.TimeUnit

class HeadlinesSyncManager(val app: NewsApp) {

    fun scheduleSync(syncTimeSeconds: Int, apiKey: String): UUID {
        Log.d("NATETAG", "schedule the things!")
        val constraints = Constraints.Builder()
                .setRequiresBatteryNotLow(true)
                .setRequiredNetworkType(NetworkType.CONNECTED)
                .build()

        val periodicWorkRequest = PeriodicWorkRequestBuilder<SyncWorker>(syncTimeSeconds.toLong(), TimeUnit.SECONDS)
                .setInitialDelay(30, TimeUnit.SECONDS)
                .setConstraints(constraints)
                .build()

        WorkManager.getInstance(app)
                .enqueue(periodicWorkRequest)

        return periodicWorkRequest.id
    }

    fun stopSync() {

    }
}