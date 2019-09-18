package io.eisner.news_reader.data.room

import androidx.room.Database
import androidx.room.RoomDatabase
import io.eisner.news_reader.data.Article

@Database(entities = [Article::class], version = 1)
abstract class ArticleDatabase: RoomDatabase() {
    abstract fun articleDao(): ArticleDao
}