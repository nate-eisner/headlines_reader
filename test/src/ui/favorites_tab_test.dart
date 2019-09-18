import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:news_reader/src/bloc/favorites/bloc.dart';
import 'package:news_reader/src/ui/favorites_tab.dart';

import '../../test_utils.dart';

void main() {
  MockFavoritesBloc mockFavoritesBloc;
  Widget testWidget;

  setUp(() {
    mockFavoritesBloc = MockFavoritesBloc();

    testWidget = MaterialApp(
      home: BlocProvider<FavoritesBloc>(
        builder: (_) => mockFavoritesBloc,
        child: FavoritesTab(),
      ),
    );
  });

  testWidgets('init should request favorites', (WidgetTester tester) async {
    await tester.pumpWidget(testWidget);

    verify(mockFavoritesBloc.dispatch(any)).called(1);
  });

  testWidgets('show list when has data', (WidgetTester tester) async {
    when(mockFavoritesBloc.currentState).thenReturn(HasFavoritesState([]));
    await tester.pumpWidget(testWidget);

    expect(find.byKey(Key('favorites list')), findsOneWidget);
  });

  testWidgets('show loading', (WidgetTester tester) async {
    when(mockFavoritesBloc.currentState).thenReturn(LoadingArticlesState());
    await tester.pumpWidget(testWidget);

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
