package io.eisner.news_reader.api

import io.eisner.news_reader.data.api.HeadlinesResponse
import retrofit2.Call
import retrofit2.http.GET
import retrofit2.http.Header
import retrofit2.http.Query

interface NewsApiService {
    @GET("top-headlines")
    fun getHeadlines(@Header("X-Api-Key") apiKey: String, @Query("country") country: String = "us"):
            Call<HeadlinesResponse>
}