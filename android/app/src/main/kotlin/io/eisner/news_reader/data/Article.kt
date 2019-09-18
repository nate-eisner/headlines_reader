package io.eisner.news_reader.data

import androidx.room.Entity
import androidx.room.PrimaryKey
import com.squareup.moshi.JsonClass

@Entity
@JsonClass(generateAdapter = true)
data class Article(@PrimaryKey val title: String,
                   val url: String?,
                   val urlToImage: String?,
                   val author: String?,
                   val description: String?,
                   val publishedAt: String?,
                   val content: String?)