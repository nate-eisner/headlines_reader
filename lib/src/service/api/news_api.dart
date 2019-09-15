import 'package:dio/dio.dart';
import 'package:news_reader/src/config.dart';

class NewsApi {
  final Dio _dio;

  NewsApi.withConfig(Config config)
      : _dio = Dio(BaseOptions(
          baseUrl: config.baseUrl,
          headers: {'X-Api-Key': config.apiKey},
        ))
          ..interceptors.add(LogInterceptor(responseBody: true));

  /// headlines
  /// https://newsapi.org/v2/top-headlines?country=us
  Future<Response> getHeadlines({String country = 'us'}) {
    return _dio.get('/top-headlines', queryParameters: {'country': country});
  }
}
