import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:news_reader/src/bloc/favorites/bloc.dart';
import 'package:news_reader/src/data/article.dart';
import 'package:news_reader/src/ui/news_list.dart';

import '../../widget_test_utils.dart';

final testArticle = Article()
  ..title = 'Title'
  ..url = 'test.com'
  ..urlToImage = 'test.com'
  ..content = 'content'
  ..description = 'description'
  ..author = 'Nate';

void main() {
  MockFavoritesBloc mockFavoritesBloc;

  setUp(() {
    mockFavoritesBloc = MockFavoritesBloc();
  });

  testWidgets('Show news', (WidgetTester tester) async {
    List<Article> news = [testArticle];
    await tester
        .pumpWidget(MaterialApp(home: Scaffold(body: NewsList(news: news))));

    expect(find.byKey(Key('News List')), findsOneWidget);
    expect(find.byIcon(Icons.star_border), findsOneWidget);
  });

  testWidgets('Empty news', (WidgetTester tester) async {
    List<Article> emptyList = [];
    await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: NewsList(news: emptyList))));

    expect(find.byKey(Key('News List')), findsNothing);
  });

  testWidgets('Show favorite', (WidgetTester tester) async {
    var fav = testArticle;
    fav.isFavorite = true;
    List<Article> news = [fav];
    await tester
        .pumpWidget(MaterialApp(home: Scaffold(body: NewsList(news: news))));

    expect(find.byKey(Key('News List')), findsOneWidget);
    expect(find.byIcon(Icons.star), findsOneWidget);
  });

  testWidgets('Toggle favorite', (WidgetTester tester) async {
    var fav = testArticle;
    fav.isFavorite = true;
    List<Article> news = [fav];
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BlocProvider<FavoritesBloc>(
            builder: (_) => mockFavoritesBloc,
            child: NewsList(news: news),
          ),
        ),
      ),
    );

    await tester.tap(find.byIcon(Icons.star));
    verify(mockFavoritesBloc.dispatch(UnStarArticle(fav))).called(1);

    await tester.pump();

    await tester.tap(find.byIcon(Icons.star_border));
    verify(mockFavoritesBloc.dispatch(StarArticle(fav))).called(1);
  });
}
