package io.eisner.news_reader.data.api

import com.squareup.moshi.JsonClass
import io.eisner.news_reader.data.Article

@JsonClass(generateAdapter = true)
data class HeadlinesResponse(val status: String, val totalResults: Int, val articles: List<Article>)