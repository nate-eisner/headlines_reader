import 'package:dio/dio.dart';
import 'package:news_reader/src/config.dart';
import 'package:news_reader/src/data/article.dart';
import 'package:news_reader/src/service/api/news_api.dart';

class NewsService {
  final NewsApi _newsApi;

  NewsService(Config config) : _newsApi = NewsApi.withConfig(config);

  Future<List<Article>> getHeadlines() async {
    Response response = await _newsApi.getHeadlines();
    if (response.statusCode == 200 && response?.data['status'] ??
        'error' == 'ok') {
      var articles = response.data['articles'];
      return articles;
    }
    throw NewsServiceErrors.HeadlinesFailed;
  }
}

enum NewsServiceErrors {
  HeadlinesFailed,
}
