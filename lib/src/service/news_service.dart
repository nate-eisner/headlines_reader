import 'package:dio/dio.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:news_reader/src/config.dart';
import 'package:news_reader/src/data/article.dart';
import 'package:news_reader/src/data/sql/database.dart';
import 'package:news_reader/src/service/api/news_api.dart';
import 'package:news_reader/src/service/api/news_response.dart';

class NewsService {
  final NewsApi _newsApi;
  final BaseCacheManager imageCacheManager = DefaultCacheManager();

  NewsService(Config config) : _newsApi = NewsApi.withConfig(config);

  Future<List<Article>> getHeadlines() async {
    Response response = await _newsApi.getHeadlines();
    if (response.statusCode == 200) {
      var newsResponse = NewsResponse.fromJson(response.data);
      var list = newsResponse.articles.where((article) {
        return article.url != null &&
            article.description != null &&
            article.title != null &&
            article.description != null;
      }).toList();
      Future.microtask(() => _cacheHeadLines(list));
      return mapWithFavorites(list);
    }
    throw NewsServiceErrors.HeadlinesFailed;
  }

  Future<List<Article>> mapWithFavorites(List<Article> list) async {
    var favoritesMap = await getFavoritesAsMap();
    return list.map((article) {
      article.isFavorite = favoritesMap.containsKey(article.title);
      return article;
    }).toList();
  }

  Future<List<Article>> getFavorites() async {
    final db = await database();
    final List<Map<String, dynamic>> maps = await db.query(favoritesTable);
    return List.generate(maps.length, (i) {
      return Article.fromDB(maps[i]);
    });
  }

  Future<List<Article>> getCachedHeadlines() async {
    final db = await database();
    final List<Map<String, dynamic>> maps = await db.query(cacheTable);
    var list = List.generate(maps.length, (i) {
      return Article.fromDB(maps[i]);
    });
    return await mapWithFavorites(list);
  }

  Future<Map<String, Article>> getFavoritesAsMap() async {
    var favorites = await getFavorites();
    return Map.fromIterable(
      favorites,
      key: (article) => article.title,
      value: (article) => article,
    );
  }

  Future<void> saveArticle(Article article, [bool isCache = false]) async {
    final db = await database();
    await db.insert(isCache ? cacheTable : favoritesTable, article.toDBMap());
    await imageCacheManager.downloadFile(article.urlToImage);
  }

  Future<void> deleteArticle(Article article) async {
    final db = await database();
    await db
        .delete(favoritesTable, where: 'title = ?', whereArgs: [article.title]);
  }

  _cacheHeadLines(Iterable<Article> news) async {
    final db = await database();
    db.delete(cacheTable);
    news.forEach((article) {
      saveArticle(article, true);
    });
  }
}

enum NewsServiceErrors {
  HeadlinesFailed,
}
