import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:news_reader/src/config.dart';
import 'package:news_reader/src/service/news_service.dart';

import './bloc.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final NewsService _newsService;

  NewsBloc(Config config) : _newsService = NewsService(config);

  @override
  NewsState get initialState => InitialNewsState();

  @override
  Stream<NewsState> mapEventToState(
    NewsEvent event,
  ) async* {
    if (event is GetHeadlines) {
      yield NewsLoadingState();
      try {
        var news = await _newsService.getHeadlines();
        yield HasNewsState(news);
      } catch (e) {
        print(e);
        yield NewsErrorState();
      }
    }
  }
}
