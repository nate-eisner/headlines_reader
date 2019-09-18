package io.eisner.news_reader.data.room

import androidx.room.Dao
import androidx.room.Delete
import androidx.room.Insert
import androidx.room.Query
import io.eisner.news_reader.data.Article

@Dao
interface ArticleDao {
    @Query("SELECT * FROM article")
    fun getAll(): List<Article>

    @Query("SELECT * FROM article WHERE title IN (:titles)")
    fun loadAllByTitle(vararg titles: String): List<Article>

    @Insert
    fun insertAll(vararg article: Article)

    @Delete
    fun delete(article: Article)

    @Delete
    fun deleteAll(vararg article: Article)
}