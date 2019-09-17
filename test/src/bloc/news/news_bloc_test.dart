import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:news_reader/src/bloc/favorites/bloc.dart';
import 'package:news_reader/src/bloc/news/news_bloc.dart';
import 'package:news_reader/src/bloc/news/news_event.dart';
import 'package:news_reader/src/bloc/news/news_state.dart';
import 'package:news_reader/src/data/article.dart';

import '../../../widget_test_utils.dart';

void main() {
  MockNewsService mockNewsService;

  NewsBloc newsBloc;

  setUp(() {
    mockNewsService = MockNewsService();

    newsBloc = NewsBloc(mockNewsService);
  });

  test('Get Headlines - refresh', () {
    final expectedResponse = [
      isA<InitialNewsState>(),
      isA<NewsLoadingState>(),
      isA<HasNewsState>(),
    ];
    expectLater(
      newsBloc.state,
      emitsInOrder(expectedResponse),
    ).then((_) {
      verify(mockNewsService.getHeadlines()).called(1);
    });

    newsBloc.dispatch(GetHeadlines(true));
  });

  test('Get Headlines - from cache', () {
    final expectedResponse = [
      isA<InitialNewsState>(),
      isA<HasNewsState>(),
    ];
    expectLater(
      newsBloc.state,
      emitsInOrder(expectedResponse),
    ).then((_) {
      verifyNever(mockNewsService.getHeadlines());
      verify(mockNewsService.getCachedHeadlines()).called(1);
    });

    newsBloc.dispatch(GetHeadlines(false));
  });
}
