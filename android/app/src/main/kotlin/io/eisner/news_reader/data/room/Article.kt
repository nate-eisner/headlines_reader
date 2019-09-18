package io.eisner.news_reader.data.room

import androidx.room.Entity
import androidx.room.PrimaryKey

@Entity
data class Article(@PrimaryKey val title: String,
                   val url: String?,
                   val urlToImage: String?,
                   val author: String?,
                   val description: String?,
                   val publishedAt: String?,
                   val content: String?)