package io.eisner.news_reader

import androidx.room.Room
import io.eisner.news_reader.data.room.ArticleDatabase
import io.flutter.app.FlutterApplication

class NewsApp : FlutterApplication() {
//    lateinit var database: ArticleDatabase
    override fun onCreate() {
        super.onCreate()
    }
}