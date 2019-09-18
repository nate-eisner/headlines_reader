import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:news_reader/src/data/article.dart';
import 'package:news_reader/src/service/api/news_response.dart';
import 'package:news_reader/src/service/news_service.dart';

import '../../test_utils.dart';

void main() {
  MockNewsApi mockNewsApi;
  MockDatabase mockDatabase;
  MockImageCacheManager mockImageCacheManager;

  NewsService newsService;

  setUp(() {
    mockDatabase = MockDatabase();
    mockNewsApi = MockNewsApi();
    mockImageCacheManager = MockImageCacheManager();

    newsService = NewsService(
      newsApi: mockNewsApi,
      db: Future.value(mockDatabase),
      imageCacheManager: mockImageCacheManager,
    );
  });

  test('Get Headlines empty ok', () async {
    var response = NewsResponse()
      ..articles = []
      ..status = 'Ok';

    when(mockNewsApi.getHeadlines()).thenAnswer((_) =>
        Future.value(Response(statusCode: 200, data: response.toJson())));
    var news = await newsService.getHeadlines();

    expect(news, isNotNull);
    expect(news, isEmpty);
  });

  test('Get Headlines 1 article', () async {
    var article = Article()
      ..url = 'https://google.com'
      ..title = 'Test Headline'
      ..description = 'Description';

    var responseData = {
      "status": "Ok",
      "totalResults": 1,
      "articles": [
        article.toJson(),
      ]
    };

    when(mockNewsApi.getHeadlines()).thenAnswer((_) => Future.value(Response(
          statusCode: 200,
          data: responseData,
        )));
    var news = await newsService.getHeadlines();

    expect(news, isNotNull);
    expect(news, isNotEmpty);
  });
}
