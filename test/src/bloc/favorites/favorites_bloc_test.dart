import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:news_reader/src/bloc/favorites/bloc.dart';
import 'package:news_reader/src/data/article.dart';

import '../../../test_utils.dart';

void main() {
  MockNewsService mockNewsService;
  MockNewsBloc mockNewsBloc;

  FavoritesBloc favoritesBloc;
  setUp(() {
    mockNewsService = MockNewsService();
    mockNewsBloc = MockNewsBloc();

    favoritesBloc = FavoritesBloc(mockNewsService, mockNewsBloc);
  });

  test('Favorite an article', () {
    final expectedResponse = [
      isA<InitialArticleState>(),
      isA<HasFavoritesState>(),
    ];
    expectLater(
      favoritesBloc.state,
      emitsInOrder(expectedResponse),
    ).then((_) {
      verify(mockNewsService.saveArticle(any)).called(1);
      verify(mockNewsBloc.dispatch(any)).called(1);
    });

    favoritesBloc.dispatch(StarArticle(Article()));
  });

  test('Un-favorite an article', () {
    final expectedResponse = [
      isA<InitialArticleState>(),
      isA<HasFavoritesState>(),
    ];
    expectLater(
      favoritesBloc.state,
      emitsInOrder(expectedResponse),
    ).then((_) {
      verify(mockNewsService.deleteArticle(any)).called(1);
      verify(mockNewsBloc.dispatch(any)).called(1);
    });

    favoritesBloc.dispatch(UnStarArticle(Article()));
  });

  test('Get favorites', () {
    final expectedResponse = [
      isA<InitialArticleState>(),
      isA<LoadingArticlesState>(),
      isA<HasFavoritesState>(),
    ];
    expectLater(
      favoritesBloc.state,
      emitsInOrder(expectedResponse),
    );

    favoritesBloc.dispatch(GetFavorites());
  });
}
