import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:news_reader/src/data/article.dart';

@immutable
abstract class NewsState extends Equatable {
  NewsState([List props = const <dynamic>[]]) : super(props);
}

class InitialNewsState extends NewsState {}

class NewsLoadingState extends NewsState {}

class NewsErrorState extends NewsState {}

class HasNewsState extends NewsState {
  List<Article> get news => props[0];

  HasNewsState(List<Article> articles) : super([articles]);
}
