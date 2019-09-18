import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:news_reader/src/bloc/news/news_bloc.dart';
import 'package:news_reader/src/ui/headlines_tab.dart';

import '../../test_utils.dart';

void main() {
  MockNewsService mockNewsService;
  NewsBloc newsBloc;
  Widget testWidget;

  setUp(() {
    mockNewsService = MockNewsService();
    newsBloc = NewsBloc(mockNewsService);

    testWidget = MaterialApp(
      home: BlocProvider<NewsBloc>(
        builder: (_) => newsBloc,
        child: Scaffold(body: HeadlinesTab()),
      ),
    );
  });

  testWidgets('init should request headlines', (WidgetTester tester) async {
    when(mockNewsService.getCachedHeadlines())
        .thenAnswer((_) => Future.value([]));
    when(mockNewsService.getHeadlines()).thenAnswer((_) => Future.value([]));
    await tester.runAsync(() async {
      await tester.pumpWidget(testWidget);
      await tester.pump();
      verify(mockNewsService.getHeadlines()).called(1);
    });
  });

  testWidgets('headlines error', (WidgetTester tester) async {
    await tester.runAsync(() async {
      when(mockNewsService.getCachedHeadlines())
          .thenAnswer((_) => Future.value([]));
      when(mockNewsService.getHeadlines()).thenThrow('error');
      await tester.pumpWidget(testWidget);
      await Future.delayed(Duration(milliseconds: 200));
      await tester.pumpAndSettle();

      expect(find.byKey(Key('snackbar-error')), findsOneWidget);
      verify(mockNewsService.getCachedHeadlines()).called(2);
    });
  });
}
