package io.eisner.news_reader.sync

import android.content.Context
import android.util.Log
import androidx.room.Room
import androidx.work.Worker
import androidx.work.WorkerParameters
import io.eisner.news_reader.api.NewsApiService
import io.eisner.news_reader.data.room.ArticleDatabase
import retrofit2.Retrofit
import retrofit2.converter.moshi.MoshiConverterFactory


class SyncWorker(context: Context, private val workerParameters: WorkerParameters) :
        Worker(context, workerParameters) {


    override fun doWork(): Result {
        val retrofit: Retrofit = Retrofit.Builder()
                .baseUrl("https://newsapi.org/v2/")
                .addConverterFactory(MoshiConverterFactory.create())
                .build()

        val service: NewsApiService = retrofit.create(NewsApiService::class.java)

        try {
            val apiKey = workerParameters.inputData.getString("apiKey") ?: ""
            val response = service.getHeadlines(apiKey).execute()
            if (response.isSuccessful) {
                response.body()?.articles?.let { articles ->
                    if (articles.isEmpty()) return@let

                    val db = Room.databaseBuilder(
                            applicationContext,
                            ArticleDatabase::class.java, "news_database.db"
                    ).build()
                    db.articleDao().deleteAll(*db.articleDao().getAll().toTypedArray())
                    db.articleDao().insertAll(*articles.toTypedArray())
                    db.close()
                    return Result.success()
                }
            }
        } catch (exception: Exception) {
            Log.e("NEWS", "Failed to get headlines", exception)
        }

        return Result.failure()
    }
}