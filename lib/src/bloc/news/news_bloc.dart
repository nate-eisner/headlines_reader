import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:news_reader/src/service/news_service.dart';

import './bloc.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final NewsService _newsService;

  NewsBloc(NewsService service) : _newsService = service;

  @override
  NewsState get initialState => InitialNewsState();

  @override
  Stream<NewsState> mapEventToState(
    NewsEvent event,
  ) async* {
    if (event is GetHeadlines) {
      if (event.hardRefresh) {
        yield NewsLoadingState();
        try {
          var news = await _newsService.getCachedHeadlines();
          yield HasNewsState(news);
          news = await _newsService.getHeadlines();
          yield HasNewsState(news);
        } catch (e) {
          yield NewsErrorState();
          // return cached news as fail safe
          var news = await _newsService.getCachedHeadlines();
          yield HasNewsState(news);
        }
      } else {
        var news = await _newsService.getCachedHeadlines();
        yield HasNewsState(news);
      }
    }
  }
}
