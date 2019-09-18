package io.eisner.news_reader.sync

import android.content.Context
import android.util.Log
import androidx.room.Room
import androidx.work.Worker
import androidx.work.WorkerParameters
import io.eisner.news_reader.NewsApp
import io.eisner.news_reader.data.room.ArticleDatabase

class SyncWorker(context: Context, workerParameters: WorkerParameters) :
        Worker(context, workerParameters) {
    override fun doWork(): Result {
        val db = Room.databaseBuilder(
                applicationContext,
                ArticleDatabase::class.java, "news_database.db"
        ).build()
        for (article in db.articleDao().getAll()) {
            Log.d("NATETAG", "Article - ${article.title}")
        }
        
        db.articleDao().deleteAll(*db.articleDao().getAll().toTypedArray())
        
        db.close()
        return Result.success()
    }
}