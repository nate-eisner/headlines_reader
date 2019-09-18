import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:news_reader/src/bloc/favorites/bloc.dart';
import 'package:news_reader/src/bloc/news/news_bloc.dart';
import 'package:news_reader/src/ui/news_home.dart';

import '../../test_utils.dart';

void main() {
  MockNewsBloc mockNewsBloc;
  MockFavoritesBloc mockFavoritesBloc;
  Widget testWidget;

  setUp(() {
    mockNewsBloc = MockNewsBloc();
    mockFavoritesBloc = MockFavoritesBloc();
    testWidget = MaterialApp(
      home: MultiBlocProvider(
        providers: [
          BlocProvider<NewsBloc>(
            builder: (_) => mockNewsBloc,
          ),
          BlocProvider<FavoritesBloc>(
            builder: (_) => mockFavoritesBloc,
          )
        ],
        child: NewsHome(),
      ),
    );
  });

  testWidgets('Initial State on headlines', (WidgetTester tester) async {
    await tester.pumpWidget(testWidget);
    _verifyOnHeadlines();
  });

  testWidgets('Change to favorties', (WidgetTester tester) async {
    await tester.pumpWidget(testWidget);
    _verifyOnHeadlines();
    await tester.tap(find.byIcon(Icons.star));
    await tester.pumpAndSettle();
    _verifyOnFavorites();
  });

  testWidgets('Change to favorties and back to headlines',
      (WidgetTester tester) async {
    await tester.pumpWidget(testWidget);
    _verifyOnHeadlines();

    await tester.tap(find.byIcon(Icons.star));
    await tester.pumpAndSettle();

    _verifyOnFavorites();
    await tester.tap(find.byIcon(Icons.rss_feed));
    await tester.pumpAndSettle();
    _verifyOnHeadlines();
  });
}

_verifyOnHeadlines() {
  expect(find.text('Headlines'), findsWidgets);
  expect(find.byKey(Key('NewsFeed')), findsOneWidget);
  expect(find.byKey(Key('FavoritesTab')), findsNothing);
  expect(find.byKey(Key('refresh')), findsOneWidget);
}

_verifyOnFavorites() {
  expect(find.text('Favorites'), findsWidgets);
  expect(find.byKey(Key('NewsFeed')), findsNothing);
  expect(find.byKey(Key('FavoritesTab')), findsOneWidget);
  expect(find.byKey(Key('refresh')), findsNothing);
}
