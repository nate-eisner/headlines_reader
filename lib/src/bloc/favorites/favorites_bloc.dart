import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:news_reader/src/bloc/news/news_bloc.dart';
import 'package:news_reader/src/bloc/news/news_event.dart';
import 'package:news_reader/src/service/news_service.dart';

import './bloc.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  final NewsBloc _newsBloc;
  final NewsService _newsService;

  FavoritesBloc(NewsService service, NewsBloc newsBloc)
      : _newsService = service,
        _newsBloc = newsBloc;

  @override
  FavoritesState get initialState => InitialArticleState();

  @override
  Stream<FavoritesState> mapEventToState(
    FavoritesEvent event,
  ) async* {
    if (event is StarArticle) {
      await _newsService.saveArticle(event.article);
      var articles = await _newsService.getFavorites();
      yield HasFavoritesState(articles);
      _newsBloc.dispatch(GetHeadlines(false));
    }

    if (event is UnStarArticle) {
      await _newsService.deleteArticle(event.article);
      var articles = await _newsService.getFavorites();
      yield HasFavoritesState(articles);
      _newsBloc.dispatch(GetHeadlines(false));
    }

    if (event is GetFavorites) {
      yield LoadingArticlesState();
      var articles = await _newsService.getFavorites();
      yield HasFavoritesState(articles);
    }
  }
}
